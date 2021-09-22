<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DealerComplainBSCEdit.ascx.cs"
    Inherits="DMS.Website.Controls.DealerComplainBSCEdit" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>
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

<script type="text/javascript" language="javascript">
    var msgBSCList = {
        msg1:"<%=GetLocalResourceObject("CheckSubmit.confirm").ToString()%>",
        msg2:"<%=GetLocalResourceObject("CheckSubmit.success").ToString()%>",
        msg3:"<%=GetLocalResourceObject("CheckSubmit.confirmBeforeSubmit").ToString()%>",
        msg4:"提交成功"
    }
    
    var CloseBSCWindow = function() {
        Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
        //RefreshMainPage();
    }
    
    var SetBSCSubmit = function(b) {       
        if (b) {
            Ext.getCmp('<%=this.SubmitButton.ClientID%>').show();
        } else {
            Ext.getCmp('<%=this.SubmitButton.ClientID%>').hide();
        }       
    }
    
    var SetBSCCancel = function(b) {
        
        if (b) {
            Ext.getCmp('<%=this.CancelButton.ClientID%>').show();
        } else {
            Ext.getCmp('<%=this.CancelButton.ClientID%>').hide();
        }
    }
    
    var SetBSCDelivered = function(b) {
        
        if (b) {
            Ext.getCmp('<%=this.DeliverToBSCButton.ClientID%>').show();
        } else {
            Ext.getCmp('<%=this.DeliverToBSCButton.ClientID%>').hide();
        }
    }
    
     var SetBSCConfirmed = function(b) {
        
        if (b) {
            Ext.getCmp('<%=this.ConfirmButton.ClientID%>').show();
        } else {
            Ext.getCmp('<%=this.ConfirmButton.ClientID%>').hide();
        }
    }
    
    var SetBSCConfirm = function(b) {
        if (b) {
            Ext.getCmp('<%=this.ConfirmButton.ClientID%>').show();
        } else {
            Ext.getCmp('<%=this.ConfirmButton.ClientID%>').hide();
        }
    }
    
    //初次载入详细信息窗口时读取数据
    function RefreshDetailWindowBSC() {       
        
        if (Ext.getCmp('<%=this.hidShowType.ClientID%>').getValue() =="New")
        {        
            Ext.getCmp('<%=this.FieldSet1.ClientID%>').show();
            Ext.getCmp('<%=this.FieldSet2.ClientID%>').show();
            Ext.getCmp('<%=this.FieldSet3.ClientID%>').show();
            Ext.getCmp('<%=this.FieldSet4.ClientID%>').show();
            Ext.getCmp('<%=this.FieldSet5.ClientID%>').show();
            Ext.getCmp('<%=this.SubmitButton.ClientID%>').show();
            Ext.getCmp('<%=this.hidCheckUPNAndDateFlag.ClientID%>').setValue("true");
            
            Ext.getCmp('<%=this.BtnChkUPN.ClientID%>').hide();
            Ext.getCmp('<%=this.BtnCancelChkUPN.ClientID%>').hide();
            
            //Ext.getCmp('<%=this.BtnChkUPN.ClientID%>').enable('true');
            //Ext.getCmp('<%=this.BtnCancelChkUPN.ClientID%>').disable('True');            
            Ext.getCmp('<%=this.windowCarrier.ClientID%>').hide();
        } else {
            Ext.getCmp('<%=this.FieldSet1.ClientID%>').show();
            Ext.getCmp('<%=this.FieldSet2.ClientID%>').show();
            Ext.getCmp('<%=this.FieldSet3.ClientID%>').show();
            Ext.getCmp('<%=this.FieldSet4.ClientID%>').show();
            Ext.getCmp('<%=this.FieldSet5.ClientID%>').show();
            Ext.getCmp('<%=this.SubmitButton.ClientID%>').hide();
            Ext.getCmp('<%=this.BtnChkUPN.ClientID%>').hide();
            Ext.getCmp('<%=this.BtnCancelChkUPN.ClientID%>').hide();
            
            Ext.getCmp('<%=this.windowCarrier.ClientID%>').hide();
            Ext.getCmp('<%=this.gpLog.ClientID%>').reload();
        }
        
       
    }
    
    var iBSCCheck = true;
    function CheckBSCField(i) {
        
        if (i.items!=null){
            i.items.each(
            function(item,index,length){                                
                if (item.xtype == 'textfield' || item.xtype == "numberfield" || item.xtype == 'datefield' || item.xtype == 'coolitetriggercombo') {
                    if (iBSCCheck && !item.isValid()) {
                        iBSCCheck = false;                        
                        item.focus();
                        return false;
                    }
                } 
                else if (item.xtype == 'checkboxgroup' || item.xtype == 'radiogroup') {
                    if (iBSCCheck) {
                         var checkboxgroupChk = false
                         for (var i = 0; i < item.items.length; i++)    
                         {    
                            if (item.items.itemAt(i).checked)    
                            {    
                               checkboxgroupChk = true;                                             
                            }                         
                         }                         
                         if (!checkboxgroupChk && item.id != Ext.getCmp('<%=this.IVUS.ClientID%>').id && item.id != Ext.getCmp('<%=this.GENERATOR.ClientID%>').id){
                           item.focus();
                           alert(item.blankText);
                           iBSCCheck = false;
                           return false;
                         }   
                     }                 
                } 
                
                else {
                   
                    CheckBSCField(item);
                }
            });
        }
    }
    
    var CancelBSCSubmit = function() {
        Ext.Msg.confirm('Message', msgBSCList.msg1,
            function(e) {
                if (e == 'yes') {
                    Coolite.AjaxMethods.DealerComplainBSCEdit.DoCancel(
                        {
                            success: function() {
                                Ext.Msg.alert('Message', msgBSCList.msg2);
                                Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                RefreshMainPage();
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                    );
                }
            }
        );
    }
    
    var ConfirmBSCSubmit = function() {
        Ext.Msg.confirm('Message', msgBSCList.msg1,
            function(e) {
                if (e == 'yes') {
                    Coolite.AjaxMethods.DealerComplainBSCEdit.DoConfirm(
                        {
                            success: function() {
                                Ext.Msg.alert('Message', msgBSCList.msg2);
                                Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                RefreshMainPage();
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                    );
                }
            }
        );
    }
    
    var CheckBSCSubmit = function() {
        iBSCCheck = true;
        CheckBSCField(<%=Panel1.ClientID%>);   
        if (iBSCCheck) {
            var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
            Ext.Msg.confirm('Message', msgBSCList.msg3,
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.DealerComplainBSCEdit.DoSubmit(
                            {
                                success: function() {
                                    if (rtnVal.getValue() == "Success") {
                                        Ext.Msg.alert('Message', msgBSCList.msg2);
                                        Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                        RefreshMainPage();
                                    } else {
                                        Ext.Msg.alert('Error', rtnVal.getValue());
                                    }
                                },
                                failure: function(err) {
                                    Ext.Msg.alert('Error', err);
                                }
                            }
                        );
                    }
                }
            );  
        }
    }
    
    
    
//    var CheckUPNAndDate = function() {
//        iBSCCheck = true;
//        CheckBSCField(<%=PanelProductInfo.ClientID%>);
//        if (iBSCCheck) {
//            var rtnCheckUPNRtnVal = Ext.getCmp('<%=this.hidCheckUPNRtnVal.ClientID%>');
//            
//            Coolite.AjaxMethods.DealerComplainBSCEdit.CheckUPNAndDate(
//                {
//                    success: function() {
//                        if (rtnCheckUPNRtnVal.getValue() == "Success") {                        
//                            Ext.getCmp('<%=this.FieldSet1.ClientID%>').show();
//                            Ext.getCmp('<%=this.FieldSet2.ClientID%>').show();
//                            Ext.getCmp('<%=this.FieldSet3.ClientID%>').show();
//                            Ext.getCmp('<%=this.FieldSet4.ClientID%>').show();
//                            Ext.getCmp('<%=this.FieldSet5.ClientID%>').show();
//                            Ext.getCmp('<%=this.SubmitButton.ClientID%>').show();
//                            
//                            Ext.getCmp('<%=this.cbUPN.ClientID%>').disable('True');
//                            Ext.getCmp('<%=this.INITIALPDATE.ClientID%>').disable('True');
//                            Ext.getCmp('<%=this.cbLOT.ClientID%>').disable('True');
//                            Ext.getCmp('<%=this.EDATE.ClientID%>').disable('True');
//                            Ext.getCmp('<%=this.BtnChkUPN.ClientID%>').disable('True');
//                            Ext.getCmp('<%=this.BtnCancelChkUPN.ClientID%>').enable('true');
//                            
//                            Ext.getCmp('<%=this.hidCheckUPNAndDateFlag.ClientID%>').setValue("true");
//                            
//                            
//                            RefreshMainPage();
//                        } else {
//                            Ext.getCmp('<%=this.hidCheckUPNAndDateFlag.ClientID%>').setValue("false");
//                            Ext.Msg.alert('Error', rtnCheckUPNRtnVal.getValue());
//                        }
//                    },
//                    failure: function(err) {
//                        Ext.Msg.alert('Error', err);
//                    }
//                }
//            ); 
//        }                  
//    }
    
    var isCanReturnCheck = function() { 
      if (Ext.getCmp('<%=this.UPNEXPECTED_2.ClientID%>').checked){
         //更新退回数量为1
         Ext.getCmp('<%=this.UPNQUANTITY.ClientID%>').setValue("0");
         Ext.getCmp('<%=this.NORETURN_10.ClientID%>').enable('true');
         Ext.getCmp('<%=this.NORETURN_20.ClientID%>').enable('true');
         Ext.getCmp('<%=this.NORETURN_30.ClientID%>').enable('true');
         Ext.getCmp('<%=this.NORETURN_40.ClientID%>').enable('true');
         Ext.getCmp('<%=this.NORETURN_99.ClientID%>').enable('true');
         Ext.getCmp('<%=this.NORETURNREASON.ClientID%>').enable('true');
         
         Ext.getCmp('<%=this.NORETURN_50.ClientID%>').setValue(false);
        
        
      } else {
        Ext.getCmp('<%=this.UPNQUANTITY.ClientID%>').setValue("1");
        Ext.getCmp('<%=this.NORETURN_10.ClientID%>').disable('True');
        Ext.getCmp('<%=this.NORETURN_20.ClientID%>').disable('True');
        Ext.getCmp('<%=this.NORETURN_30.ClientID%>').disable('True');
        Ext.getCmp('<%=this.NORETURN_40.ClientID%>').disable('True');
        Ext.getCmp('<%=this.NORETURN_99.ClientID%>').disable('True');
        Ext.getCmp('<%=this.NORETURNREASON.ClientID%>').disable('True');       
       
        Ext.getCmp('<%=this.NORETURN_10.ClientID%>').setValue(false);
        Ext.getCmp('<%=this.NORETURN_20.ClientID%>').setValue(false);
        Ext.getCmp('<%=this.NORETURN_30.ClientID%>').setValue(false);
        Ext.getCmp('<%=this.NORETURN_40.ClientID%>').setValue(false);
        Ext.getCmp('<%=this.NORETURN_99.ClientID%>').setValue(false);
        Ext.getCmp('<%=this.NORETURNREASON.ClientID%>').setValue("");
        
       
        Ext.getCmp('<%=this.NORETURN_50.ClientID%>').setValue(true);
        
      }
    }
    
    var isSingleUseCheck = function() {
        if (Ext.getCmp('<%=this.SINGLEUSE_1.ClientID%>').checked){
            Ext.getCmp('<%=this.RESTERILIZED_1.ClientID%>').setValue(false);
            Ext.getCmp('<%=this.RESTERILIZED_2.ClientID%>').setValue(true);
            Ext.getCmp('<%=this.RESTERILIZED_3.ClientID%>').setValue(false);
            Ext.getCmp('<%=this.RESTERILIZED_4.ClientID%>').setValue(false);
            Ext.getCmp('<%=this.USEDEXPIRY_1.ClientID%>').setValue(false);
            Ext.getCmp('<%=this.USEDEXPIRY_2.ClientID%>').setValue(true);
            Ext.getCmp('<%=this.USEDEXPIRY_4.ClientID%>').setValue(false);
        }
    }
   
    
//    var CancelCheckUPNAndDate = function() {             
//                           
//        Ext.getCmp('<%=this.FieldSet1.ClientID%>').hide();
//        Ext.getCmp('<%=this.FieldSet2.ClientID%>').hide();
//        Ext.getCmp('<%=this.FieldSet3.ClientID%>').hide();
//        Ext.getCmp('<%=this.FieldSet4.ClientID%>').hide();
//        Ext.getCmp('<%=this.FieldSet5.ClientID%>').hide();
//        Ext.getCmp('<%=this.SubmitButton.ClientID%>').hide();
//                        
//        Ext.getCmp('<%=this.cbUPN.ClientID%>').enable('true');
//        Ext.getCmp('<%=this.INITIALPDATE.ClientID%>').enable('true');
//        Ext.getCmp('<%=this.cbLOT.ClientID%>').enable('true');
//        Ext.getCmp('<%=this.EDATE.ClientID%>').enable('true');
//        Ext.getCmp('<%=this.BtnChkUPN.ClientID%>').enable('true');
//        Ext.getCmp('<%=this.hidCheckUPNAndDateFlag.ClientID%>').setValue("false");
//        
//        RefreshMainPage();
//                    
//    }
    
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
    
   function CheckInitialDate() {
     var InitialDate = Ext.getCmp('<%=this.INITIALPDATE.ClientID%>');
     var UPNExpDate = Ext.getCmp('<%=this.UPNExpDate.ClientID%>');
     if (UPNExpDate ==null || UPNExpDate.getValue()=='') {
       alert("请先选择产品型号及批号！");
     } else if (parseInt(InitialDate.getValue().getFullYear().toString()+add_zero(InitialDate.getValue().getMonth()+1)) > parseInt(UPNExpDate.getValue())){
       alert("手术日期大于产品有效期，属于过期使用！");
       InitialDate.setValue("");
     }
   
   }
   
   function CheckEDate() {
     var InitialDate = Ext.getCmp('<%=this.INITIALPDATE.ClientID%>');
     var EDate = Ext.getCmp('<%=this.EDATE.ClientID%>');
     var nowDate = new Date();
     
     if (InitialDate==null || InitialDate.getValue()=='') {
       alert("请先选择首次手术日期！");
       EDate.setValue("");
     } else if (InitialDate.getValue() > EDate.getValue()){
       alert("事件日期不能小于手术日期！");
       EDate.setValue("");
     } else if (nowDate < EDate.getValue()){
       alert("事件日期不能大于当前日期！");
       EDate.setValue("");
     } 
   
   }
   
   function add_zero(temp)
    {
     if(temp<10) return "0"+temp;
     else return temp;
   }

   function ProductTypeCheck() {
       
       var ProductType = Ext.getCmp('<%=this.PRODUCTTYPE.ClientID%>');
       if (ProductType.checked.getValue() == '25') {
           alert("如果物权是平台或T1，或为多包装产品，请选择退款处理！");
       }
   }
</script>

<ext:Hidden ID="hidInstanceId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidShowType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnVal" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidCheckUPNRtnVal" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidCheckUPNAndDateFlag" runat="server">
</ext:Hidden>
<ext:Store ID="StoreRETURNTYPE" runat="server" UseIdConfirmation="true">
    <Reader>
        <ext:JsonReader ReaderID="Key">
            <Fields>
                <ext:RecordField Name="Key" />
                <ext:RecordField Name="Value" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <SortInfo Field="Key" Direction="ASC" />
</ext:Store>
<ext:Store ID="WarehouseStore" runat="server" OnRefreshData="Store_AllWHMByLotUPN">
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Name" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <BaseParams>
        <ext:Parameter Name="UPNId" Value="#{cbUPN}.getValue()==''?'00000000':#{cbUPN}.getValue()"
            Mode="Raw" />
        <ext:Parameter Name="LotId" Value="#{cbLOT}.getValue()==''?'00000000':#{cbLOT}.getValue()"
            Mode="Raw" />
    </BaseParams>
    <Listeners>
        <Load Handler="#{cbWarehouse}.setValue(#{cbWarehouse}.store.getTotalCount()>0?#{cbWarehouse}.store.getAt(0).get('Id'):'');" />
        <LoadException Handler="Ext.Msg.alert('Warehouse - Load failed', e.message || response.statusText);" />
    </Listeners>
    <SortInfo Field="Name" Direction="ASC" />
</ext:Store>
<ext:Store ID="LotStore" runat="server"  >
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Name" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="#{cbLOT}.setValue(#{cbLOT}.store.getTotalCount()>0?#{cbLOT}.store.getAt(0).get('Id'):'');" />
        <LoadException Handler="Ext.Msg.alert('Lot - Load failed', e.message || response.statusText);" />
    </Listeners>
    <SortInfo Field="Name" Direction="ASC" />
</ext:Store>
<ext:Store ID="UPNStore" runat="server" OnRefreshData="Store_AllUPNByLot" AutoLoad="true">
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Name" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <BaseParams>
        <ext:Parameter Name="LotId" Value="#{cbLOT}.getValue()==''?'00000000':#{cbLOT}.getValue()"
            Mode="Raw" />
    </BaseParams>
    <Listeners>
        <%--<Load Handler="#{cbUPN}.setValue(#{cbUPN}.store.getTotalCount()>0?#{cbUPN}.store.getAt(0).get('Id'):'');" />--%>
        <LoadException Handler="Ext.Msg.alert('UPN - Load failed', e.message || response.statusText);" />
    </Listeners>
    <SortInfo Field="Name" Direction="ASC" />
</ext:Store>
<ext:Store ID="OrderLogStore" runat="server" UseIdConfirmation="false" OnRefreshData="OrderLogStore_RefershData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="PohId" />
                <ext:RecordField Name="OperUser" />
                <ext:RecordField Name="OperUserId" />
                <ext:RecordField Name="OperUserName" />
                <ext:RecordField Name="OperType" />
                <ext:RecordField Name="OperTypeName" />
                <ext:RecordField Name="OperDate" Type="Date" />
                <ext:RecordField Name="OperNote" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="HospitalStore" runat="server" OnRefreshData="HospitalStore_RefreshData"
    AutoLoad="true">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="HosKeyAccount">
            <Fields>
                <ext:RecordField Name="HosKeyAccount" />
                <ext:RecordField Name="HosHospitalName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="#{cbHospital}.setValue(#{cbHospital}.store.getTotalCount()>0?#{cbHospital}.store.getAt(0).get('HosKeyAccount'):'');" />
        <LoadException Handler="Ext.Msg.alert('Lot - Load failed', e.message || response.statusText);" />
    </Listeners>
    <SortInfo Field="HosHospitalName" Direction="ASC" />
</ext:Store>
<%--<ext:Store runat="server" ID="StoreUPN">
    <Reader>
        <ext:JsonReader ReaderID="PMA_UPN">
            <Fields>
                <ext:RecordField Name="PMA_UPN" />
                <ext:RecordField Name="CFN_ChineseName" />
                <ext:RecordField Name="ATTRIBUTE_NAME" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>--%>
<ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Window.Title %>"
    Width="980" Height="490" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false" CenterOnLoad="true" Y="5" AutoScroll="true">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:Panel ID="Panel6" runat="server" Header="false" Frame="false" BodyBorder="false"
                    AutoHeight="true">
                    <Body>
                        <div style="text-align: center; font-size: medium; font-family: @微软雅黑">
                            <asp:Literal ID="Literal1" runat="server" Text="<%$ Resources: DetailWindow.Title%>" /></div>
                    </Body>
                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:Panel ID="Panel1" runat="server" Header="false" Frame="false" BodyBorder="false"
                    AutoHeight="true">
                    <Body>
                        <ext:RowLayout ID="RowLayoutTop" runat="server">
                            <ext:LayoutRow>
                                <ext:FieldSet ID="FieldSet6" runat="server" Header="true" Frame="false" BodyBorder="true"
                                    AutoHeight="true" AutoWidth="true" Title="填写投诉退货关键信息">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout6" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel13" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:Label ID="Label2" runat="server" Text="产品型号(UPN)请填写产品外包装号码。" Style="color: red;" />
                                                        <br />
                                                        <ext:Label ID="Label6" runat="server" Text="产品批号(Lot)中'@@'后面部分为二维码。" Style="color: red;" />
                                                        <br />
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel69" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout24" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel70" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout44" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <%--<ext:TextField ID="LOT" runat="server" Width="200" FieldLabel="<font color='red'>*</font>产品批号（Lot）"
                                                                                    AllowBlank="false" Enabled="false" noedit="false" BlankText="请填写产品批号" Cls="lightyellow-row"
                                                                                    MsgTarget="Side" />--%>
                                                                                <ext:ComboBox ID="cbLOT" runat="server" EmptyText="请选择产品批号" Width="200" Editable="true" Mode="Local" 
                                                                                    TypeAhead="false" StoreID="LotStore" ValueField="Id" DisplayField="Name" FieldLabel="<font color='red'>*</font>产品批号（Lot）"
                                                                                    ListWidth="300" Resizable="true" BlankText="请选择产品批号" AllowBlank="false" Cls="lightyellow-row"
                                                                                    MsgTarget="Side">
                                                                                    <Triggers>
                                                                                        <ext:FieldTrigger Icon="Clear" Qtip="请选择产品批号" />
                                                                                    </Triggers>
                                                                                    <Listeners>
                                                                                        <TriggerClick Handler="this.clearValue();#{UPNStore}.reload();#{cbUPN}.clearValue();" />
                                                                                        <Select Handler="#{cbUPN}.clearValue();#{UPNStore}.reload();#{WarehouseStore}.reload();#{cbWarehouse}.clearValue();#{INITIALPDATE}.setValue();#{EDATE}.setValue(); " />
                                                                                    </Listeners>
                                                                                </ext:ComboBox>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel55" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout32" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <%-- <ext:TextField ID="UPN" runat="server" Width="200" FieldLabel="<font color='red'>*</font>产品型号（UPN）"
                                                                                    AllowBlank="false" BlankText="请填写产品型号" Enabled="false" noedit="false" Cls="lightyellow-row"
                                                                                    MsgTarget="Side" />--%>
                                                                                <ext:ComboBox ID="cbUPN" runat="server" EmptyText="请选择产品型号" Width="200" Editable="true"
                                                                                    TypeAhead="false" StoreID="UPNStore" ValueField="Id" DisplayField="Name" FieldLabel="<font color='red'>*</font>产品型号（UPN）"
                                                                                    ListWidth="300" Resizable="true" BlankText="请选择产品型号" AllowBlank="false" Cls="lightyellow-row"
                                                                                    MsgTarget="Side">
                                                                                    <Triggers>
                                                                                        <ext:FieldTrigger Icon="Clear" Qtip="请选择产品型号" />
                                                                                    </Triggers>
                                                                                    <Listeners>
                                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                                        <TriggerClick Handler="this.clearValue();#{WarehouseStore}.reload();#{cbWarehouse}.clearValue();" />
                                                                                        <Select Handler="Coolite.AjaxMethods.DealerComplainBSCEdit.AuotCompleteUPNInfo();#{cbWarehouse}.clearValue();#{WarehouseStore}.reload();#{INITIALPDATE}.setValue();#{EDATE}.setValue();" />
                                                                                    </Listeners>
                                                                                </ext:ComboBox>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="PanelProductInfo" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout19" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel57" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout40" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:ComboBox ID="cbWarehouse" runat="server" EmptyText="请选择仓库" Width="200" Editable="true"
                                                                                    TypeAhead="false" StoreID="WarehouseStore" ValueField="Id" DisplayField="Name"
                                                                                    FieldLabel="仓库" ListWidth="300" Resizable="true" BlankText="请选择仓库" AllowBlank="false"
                                                                                    Cls="lightyellow-row" MsgTarget="Side">
                                                                                    <Triggers>
                                                                                        <ext:FieldTrigger Icon="Clear" Qtip="请选择仓库" />
                                                                                    </Triggers>
                                                                                    <Listeners>
                                                                                        <Select Handler="#{RETURNTYPE}.clearValue();" />
                                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                                        <TriggerClick Handler="this.clearValue();#{WarehouseStore}.reload();#{cbWarehouse}.clearValue();#{StoreRETURNTYPE}.reload();#{RETURNTYPE}.clearValue();" />
                                                                                    </Listeners>
                                                                                </ext:ComboBox>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="INITIALPDATE" runat="server" Width="200" FieldLabel="<font color='red'>*</font>首次手术日期"
                                                                                    AllowBlank="false" Cls="lightyellow-row" MsgTarget="Side">
                                                                                    <Listeners>
                                                                                        <Select Handler="CheckInitialDate();#{EDATE}.setValue();" />
                                                                                    </Listeners>
                                                                                </ext:DateField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="txtQrCode" runat="server" Width="200" FieldLabel="二维码" Enabled="false"
                                                                                    noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="SalesDate" runat="server" Width="200" FieldLabel="销售日期"
                                                                                    AllowBlank="false" Cls="lightyellow-row" MsgTarget="Side">
                                                                                </ext:DateField>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel60" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout41" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="UPNExpDate" runat="server" Width="200" FieldLabel="产品有效期" Enabled="false"
                                                                                    noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="EDATE" runat="server" Width="200" FieldLabel="<font color='red'>*</font>事件日期"
                                                                                    AllowBlank="false" Cls="lightyellow-row" MsgTarget="Side">
                                                                                    <Listeners>
                                                                                        <Select Handler="CheckEDate();" />
                                                                                    </Listeners>
                                                                                </ext:DateField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="txtRegistration" runat="server" Width="200" FieldLabel="注册证" Enabled="false"
                                                                                    noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".10">
                                                                <ext:Panel ID="Panel16" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout34" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Button ID="BtnChkUPN" runat="server" Text="信息核查" Icon="CheckError">
                                                                                    <%-- <Listeners>
                                                                                        <Click Handler="CheckUPNAndDate();" />
                                                                                    </Listeners>--%>
                                                                                </ext:Button>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".24">
                                                                <ext:Panel ID="Panel17" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Button ID="BtnCancelChkUPN" runat="server" Text="修改信息" Icon="Delete">
                                                                                    <%--<Listeners>
                                                                                        <Click Handler="CancelCheckUPNAndDate();" />
                                                                                    </Listeners>--%>
                                                                                </ext:Button>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                        </ext:RowLayout>
                                    </Body>
                                </ext:FieldSet>
                            </ext:LayoutRow>
                            <ext:LayoutRow>
                                <ext:FieldSet ID="FieldSet1" runat="server" Header="true" Frame="false" BodyBorder="true"
                                    AutoHeight="true" AutoWidth="true" Title="<%$ Resources: TabPanel.TabHeader.Title %>">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout1" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:Label ID="Label1" runat="server" Text="<%$ Resources: TabPanel.TabHeader.Warn%>"
                                                            Style="color: red;" />
                                                        <br />
                                                        <br />
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel2" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel14" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="EID" runat="server" Width="200" FieldLabel="申请人" Enabled="false"
                                                                                    noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="BSCSalesName" runat="server" Width="200" FieldLabel="<font color='red'>*</font>销售人员姓名"
                                                                                    Enabled="false" noedit="false" Cls="lightyellow-row" AllowBlank="false" BlankText="请填写销售人员姓名"
                                                                                    MsgTarget="Side" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="INITIALNAME" runat="server" Width="200" FieldLabel="<font color='red'>*</font>原报告人姓名"
                                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请填写原报告人姓名" MsgTarget="Side" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="INITIALEMAIL" runat="server" Width="200" FieldLabel="原报告人电子邮箱地址" AllowBlank="false" BlankText="请填写原报告人电子邮箱地址" />
                                                                            </ext:Anchor>
                                                                            <%--<ext:Anchor>
                                                                                <ext:TextField ID="FIRSTBSCNAME" runat="server" Width="200" FieldLabel="<font color='red'>*</font>BSC第一联络人姓名"
                                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请填写BSC第一联络人姓名" MsgTarget="Side" />
                                                                            </ext:Anchor>--%>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="REQUESTDATE" runat="server" Width="200" FieldLabel="申请日期" Enabled="false"
                                                                                    noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="BSCSalesPhone" runat="server" Width="200" FieldLabel="<font color='red'>*</font>销售人员手机"
                                                                                    Enabled="false" noedit="false" Cls="lightyellow-row" AllowBlank="false" BlankText="请填写销售人员手机"
                                                                                    MsgTarget="Side" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="INITIALPHONE" runat="server" Width="200" FieldLabel="<font color='red'>*</font>原报告人电话"
                                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请填写原报告人电话" MsgTarget="Side" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PHYSICIAN" runat="server" Width="200" FieldLabel="<font color='red'>*</font>医生姓名"
                                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请填写医生姓名" MsgTarget="Side" />
                                                                            </ext:Anchor>
                                                                            <%--<ext:Anchor>
                                                                                <ext:DateField ID="BSCAWAREDATE" runat="server" Width="200" FieldLabel="<font color='red'>*</font>BSC接报日期"
                                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请选择BSC接报日期" MsgTarget="Side" />
                                                                            </ext:Anchor>--%>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".34">
                                                                <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="APPLYNO" runat="server" Width="200" FieldLabel="申请单编号" Enabled="false"
                                                                                    noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="INITIALJOB" runat="server" Width="200" FieldLabel="<font color='red'>*</font>原报告人职业"
                                                                                    AllowBlank="false" Enabled="false" noedit="TRUE" BlankText="请填写原报告人职业" MsgTarget="Side" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PHYSICIANPHONE" runat="server" Width="200" FieldLabel="<font color='red'>*</font>医生电话"
                                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请填写医生电话" MsgTarget="Side" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="NOTIFYDATE" runat="server" Width="200" FieldLabel="投诉通知日期" Enabled="false"
                                                                                    noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor Horizontal="100%">
                                                                                <ext:CheckboxGroup ID="CONTACTMETHOD" runat="server" FieldLabel="<font color='red'>*</font>联系方式"
                                                                                    AllowBlank="false" Enabled="false" noedit="TRUE">
                                                                                    <Items>
                                                                                        <ext:Checkbox ID="CONTACTMETHOD_1" runat="server" BoxLabel="CNF" Enabled="false"
                                                                                            cvalue="1" noedit="TRUE" />
                                                                                        <ext:Checkbox ID="CONTACTMETHOD_2" runat="server" BoxLabel="电子 CNF" Enabled="false"
                                                                                            cvalue="2" noedit="TRUE" />
                                                                                        <ext:Checkbox ID="CONTACTMETHOD_3" runat="server" BoxLabel="电子邮件" Enabled="false"
                                                                                            cvalue="3" noedit="TRUE" />
                                                                                        <ext:Checkbox ID="CONTACTMETHOD_4" runat="server" BoxLabel="传真" Enabled="false" cvalue="4"
                                                                                            noedit="TRUE" />
                                                                                        <ext:Checkbox ID="CONTACTMETHOD_5" runat="server" BoxLabel="现场服务代表" Enabled="false"
                                                                                            cvalue="5" noedit="TRUE" />
                                                                                        <ext:Checkbox ID="CONTACTMETHOD_6" runat="server" BoxLabel="邮件" Enabled="false" cvalue="6"
                                                                                            noedit="TRUE" />
                                                                                        <ext:Checkbox ID="CONTACTMETHOD_7" runat="server" BoxLabel="电话" Enabled="false" cvalue="7"
                                                                                            noedit="TRUE" />
                                                                                        <ext:Checkbox ID="CONTACTMETHOD_8" runat="server" BoxLabel="语音邮件" Enabled="false"
                                                                                            cvalue="8" noedit="TRUE" />
                                                                                    </Items>
                                                                                </ext:CheckboxGroup>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor Horizontal="100%">
                                                                                <ext:CheckboxGroup ID="COMPLAINTSOURCE" runat="server" FieldLabel="<font color='red'>*</font>投诉来源"
                                                                                    AllowBlank="false" Enabled="false" noedit="TRUE">
                                                                                    <Items>
                                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_1" runat="server" BoxLabel="公司代表" Enabled="false"
                                                                                            cvalue="1" noedit="TRUE" />
                                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_2" runat="server" BoxLabel="消费者" Enabled="false"
                                                                                            cvalue="2" noedit="TRUE" />
                                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_3" runat="server" BoxLabel="经销商" Enabled="false"
                                                                                            cvalue="3" noedit="TRUE" />
                                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_4" runat="server" BoxLabel="外部" Enabled="false"
                                                                                            cvalue="4" noedit="TRUE" />
                                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_5" runat="server" BoxLabel="医疗专家" Enabled="false"
                                                                                            cvalue="5" noedit="TRUE" />
                                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_6" runat="server" BoxLabel="文献资料" Enabled="false"
                                                                                            cvalue="6" noedit="TRUE" />
                                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_7" runat="server" BoxLabel="研究" Enabled="false"
                                                                                            cvalue="7" noedit="TRUE" />
                                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_8" runat="server" BoxLabel="用户设备" Enabled="false"
                                                                                            cvalue="8" noedit="TRUE" />
                                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_9" runat="server" BoxLabel="其他 － 请说明" Enabled="false"
                                                                                            cvalue="9" noedit="TRUE" />
                                                                                    </Items>
                                                                                </ext:CheckboxGroup>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor Horizontal="100%">
                                                                                <ext:RadioGroup ID="PRODUCTTYPE" runat="server" FieldLabel="<font color='red'>*</font>产品类型"
                                                                                    AllowBlank="true" AutoWidth="true" BlankText="请选择投诉信息中的产品类型">
                                                                                <%--<ext:CheckboxGroup ID="PRODUCTTYPE" runat="server" FieldLabel="<font color='red'>*</font>产品类型"
                                                                                    AllowBlank="true" AutoWidth="true" BlankText="请选择投诉信息中的产品类型">--%>
                                                                                    <Items>
                                                                                        <%--<ext:Checkbox ID="PRODUCTTYPE_1" runat="server" BoxLabel="现金订货" cvalue="1" />
                                                                                        <ext:Checkbox ID="PRODUCTTYPE_2" runat="server" BoxLabel="平台寄售" cvalue="2" />
                                                                                         <ext:Checkbox ID="PRODUCTTYPE_20" runat="server" BoxLabel="波科寄售" cvalue="20" />
                                                                                       
                                                                                        <ext:Checkbox ID="PRODUCTTYPE_3" runat="server" BoxLabel="短期寄售" cvalue="3" />
                                                                                        <ext:Checkbox ID="PRODUCTTYPE_4" runat="server" BoxLabel="北京/广州_FSL短期寄售" cvalue="4" />
                                                                                        <ext:Checkbox ID="PRODUCTTYPE_5" runat="server" BoxLabel="样品" cvalue="5" Enabled="false"
                                                                                            noedit="TRUE" />--%>
                                                                                        
                                                                                        <ext:Radio ID="PRODUCTTYPE_6" runat="server" BoxLabel="机器/机器配件" cvalue="6" Enabled="false" />
                                                                                        <ext:Radio ID="PRODUCTTYPE_21" runat="server" BoxLabel="市场部/销售部样品" cvalue="21" Enabled="false" />
                                                                                        <ext:Radio ID="PRODUCTTYPE_22" runat="server" BoxLabel="临床试验用的样品" cvalue="22" Enabled="false"/>
                                                                                        <ext:Radio ID="PRODUCTTYPE_23" runat="server" BoxLabel="新技术应用的样品" cvalue="23"  Enabled="false"/>
                                                                                        <ext:Radio ID="PRODUCTTYPE_24" runat="server" BoxLabel="销售员(SRAI)/工程师(FSEAI)" cvalue="24" Enabled="false"/>
                                                                                        <ext:Radio ID="PRODUCTTYPE_25" runat="server" BoxLabel="综合: 平台物权、T1物权、T2物权、医院物权、波科物权" cvalue="25" >
                                                                                            <Listeners>
                                                                                                <Check Handler="ProductTypeCheck();" />
                                                                                            </Listeners>
                                                                                        </ext:Radio>
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel10" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="FEEDBACKREQUESTED" runat="server" FieldLabel="<font color='red'>*</font>是否需要发送客户调查回函"
                                                                                    AllowBlank="true" BlankText="请选择投诉信息中的是否需要发送客户调查回函" Width="120" Visible="false">
                                                                                    <Items>
                                                                                        <ext:Radio ID="FEEDBACKREQUESTED_01" runat="server" BoxLabel="是" cvalue="1" />
                                                                                        <ext:Radio ID="FEEDBACKREQUESTED_02" runat="server" BoxLabel="否" cvalue="2" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="COMPLAINTID" runat="server" Width="200" FieldLabel="投诉号码" Enabled="false"
                                                                                    noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".67">
                                                                <ext:Panel ID="Panel11" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="FEEDBACKSENDTO" runat="server" Width="400" FieldLabel="如果需要，收信地址为"  Visible="false"/>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="REFERBOX" runat="server" Width="200" FieldLabel="收到返回产品登记号" Enabled="false"
                                                                                    noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel12" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel15" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:ComboBox ID="RETURNTYPE" runat="server" FieldLabel="<font color='red'>*</font>产品换货或退款"
                                                                                    Width="200" Editable="false" TypeAhead="true" StoreID="StoreRETURNTYPE" ValueField="Key"
                                                                                    DisplayField="Value" BlankText="选择产品换货或退款" AllowBlank="false" Cls="lightyellow-row"
                                                                                    MsgTarget="Under">
                                                                                    <Listeners>
                                                                                        <Select Handler="Coolite.AjaxMethods.DealerComplainBSCEdit.CheckReturnType({failure: function(err) { alert(err); Ext.Msg.alert('Failure', err);}});" />
                                                                                    </Listeners>
                                                                                </ext:ComboBox>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".67">
                                                                <ext:Panel ID="Panel68" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout43" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="DN" runat="server" Width="200" FieldLabel="波科DN号" Enabled="false"
                                                                                    noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel71" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout25" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".99">
                                                                <ext:Panel ID="Panel72" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout45" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:ComboBox ID="CFMRETURNTYPE" runat="server" FieldLabel="波科确认产品换货或退款"
                                                                                    Width="200" Editable="false" TypeAhead="true" StoreID="StoreRETURNTYPE" ValueField="Key"
                                                                                    DisplayField="Value">
                                                                                </ext:ComboBox>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>                                                         
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                        </ext:RowLayout>
                                    </Body>
                                </ext:FieldSet>
                            </ext:LayoutRow>
                            <ext:LayoutRow>
                                <ext:FieldSet ID="FieldSet2" runat="server" Header="true" Frame="false" BodyBorder="true"
                                    AutoHeight="true" AutoWidth="true" Title="<%$ Resources: TabPanel.TabSales.Title %>">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout2" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel18" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel19" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="ISPLATFORM" runat="server" FieldLabel="<font color='red'>*</font>是否是平台"
                                                                                    AllowBlank="false" Enabled="false" noedit="TRUE" Width="100">
                                                                                    <Items>
                                                                                        <ext:Radio ID="ISPLATFORM_1" runat="server" BoxLabel="是" Enabled="false" cvalue="1"
                                                                                            noedit="TRUE" />
                                                                                        <ext:Radio ID="ISPLATFORM_2" runat="server" BoxLabel="否" Enabled="false" cvalue="2"
                                                                                            noedit="TRUE" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".67">
                                                                <ext:Panel ID="Panel20" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout10" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="BSCSOLDTOACCOUNT" runat="server" Width="200" FieldLabel="一级经销商账号"
                                                                                    Enabled="false" noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel24" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".67">
                                                                <ext:Panel ID="Panel25" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout13" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="BSCSOLDTONAME" runat="server" Width="400" FieldLabel="<font color='red'>*</font>一级经销商名称"
                                                                                    AllowBlank="false" Enabled="false" noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="SUBSOLDTONAME" runat="server" Width="400" FieldLabel="二级经销商名称"
                                                                                    Enabled="false" noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="DISTRIBUTORCUSTOMER" runat="server" Width="400" FieldLabel="<font color='red'>*</font>医院名称"
                                                                                    AllowBlank="true" Cls="lightyellow-row" BlankText="请填写医院名称" MsgTarget="Side" Hidden="true"/>                                                                                    
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:ComboBox ID="cbHospital" runat="server" EmptyText="请选择医院" Width="200" Editable="true" Mode="Local" 
                                                                                    TypeAhead="false" StoreID="HospitalStore" ValueField="HosKeyAccount" DisplayField="HosHospitalName" FieldLabel="<font color='red'>*</font>医院名称"
                                                                                    ListWidth="300" Resizable="true" BlankText="请选择医院" AllowBlank="false" Cls="lightyellow-row"
                                                                                    MsgTarget="Side" >
                                                                                    <Triggers>
                                                                                        <ext:FieldTrigger Icon="Clear" Qtip="请选择医院" />
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
                                                            <ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel26" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout14" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="BSCSOLDTOCITY" runat="server" Width="200" FieldLabel="<font color='red'>*</font>一级经销商所在城市"
                                                                                    AllowBlank="false" Enabled="false" noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="SUBSOLDTOCITY" runat="server" Width="200" FieldLabel="二级经销商所在城市"
                                                                                    Enabled="false" noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="DISTRIBUTORCITY" runat="server" Width="200" FieldLabel="<font color='red'>*</font>医院所在城市"
                                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请填写医院所在城市" MsgTarget="Side" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                        </ext:RowLayout>
                                    </Body>
                                </ext:FieldSet>
                            </ext:LayoutRow>
                            <ext:LayoutRow>
                                <ext:FieldSet ID="FieldSet3" runat="server" Header="true" Frame="false" BodyBorder="true"
                                    AutoHeight="true" AutoWidth="true" Title="<%$ Resources: TabPanel.TabItem.Title %>">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout3" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel21" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:Label ID="Label3" runat="server" Text="<%$ Resources: TabPanel.TabItem.Warn%>"
                                                            Style="color: red;" />
                                                        <br />
                                                        <br />
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel22" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout6" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".4">
                                                                <ext:Panel ID="Panel23" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout11" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="DESCRIPTION" runat="server" Width="240" FieldLabel="UPN描述" Enabled="false"
                                                                                    noedit="TRUE" />
                                                                                <%--<ext:TextField ID="TBUPN" runat="server" Width="120" FieldLabel="<font color='red'>*</font>UPN产品型号（UPN）"
                                                                                    AllowBlank="false" Enabled="false" noedit="TRUE" />--%>
                                                                                <%-- <ext:ComboBox ID="UPN" runat="server" FieldLabel="<font color='red'>*</font>UPN号"
                                                                                    Editable="true" StoreID="StoreUPN" DisplayField="PMA_UPN" ValueField="PMA_UPN"
                                                                                    TypeAhead="false" Mode="Local" ForceSelection="true" TriggerAction="All" EmptyText="选择UPN号..."
                                                                                    SelectOnFocus="true" AllowBlank="false" ItemSelector="div.list-item">
                                                                                    <Listeners>
                                                                                        <Select Handler="#{DESCRIPTION}.setValue(record.data.CFN_ChineseName);#{BU}.setValue(record.data.ATTRIBUTE_NAME);" />
                                                                                    </Listeners>
                                                                                    <Template runat="server">
                                                                                        <tpl for=".">
                                                                                            <div class="list-item">
                                                                                                {PMA_UPN}-{CFN_ChineseName}
                                                                                            </div>
                                                                                        </tpl>
                                                                                    </Template>
                                                                                </ext:ComboBox>--%>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="BU" runat="server" Width="240" FieldLabel="UPN所属的业务部门" AllowBlank="false"
                                                                                    Enabled="false" noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".2">
                                                                <ext:Panel ID="Panel27" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout12" runat="server" LabelAlign="Left" LabelWidth="140">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="ConvertFactor" runat="server" Width="80" FieldLabel="包装数" Enabled="false"
                                                                                    noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <%--<ext:TextField ID="TBLOT" runat="server" Width="120" FieldLabel="<font color='red'>*</font>批次/批号"
                                                                                    AllowBlank="false" Enabled="false" noedit="TRUE" />--%>
                                                                                <ext:TextField ID="TBNUM" runat="server" Width="80" FieldLabel="产品数量（单位盒）" AllowBlank="false"
                                                                                    Enabled="false" noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".4">
                                                                <ext:Panel ID="Panel28" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout15" runat="server" LabelAlign="Left" LabelWidth="140">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="SINGLEUSE" runat="server" FieldLabel="<font color='red'>*</font>是否为一次性器械"
                                                                                    AllowBlank="true" Width="100" BlankText="请选择产品/批次信息中的是否为一次性器械" MsgTarget="Side">
                                                                                    <Items>
                                                                                        <ext:Radio ID="SINGLEUSE_1" runat="server" BoxLabel="是" cvalue="1"  >
                                                                                            <Listeners>
                                                                                                <Check Handler="isSingleUseCheck();" />
                                                                                            </Listeners>
                                                                                        </ext:Radio>
                                                                                        <ext:Radio ID="SINGLEUSE_2" runat="server" BoxLabel="否" cvalue="2" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="RESTERILIZED" runat="server" FieldLabel="<font color='red'>*</font>能否重复消毒"
                                                                                    AllowBlank="true" BlankText="请选择产品/批次信息中的能否重复消毒" MsgTarget="Side" AutoWidth="true">
                                                                                    <Items>
                                                                                        <ext:Radio ID="RESTERILIZED_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                                        <ext:Radio ID="RESTERILIZED_2" runat="server" BoxLabel="否" cvalue="2" />
                                                                                        <ext:Radio ID="RESTERILIZED_3" runat="server" BoxLabel="不知道" cvalue="3" />
                                                                                        <ext:Radio ID="RESTERILIZED_4" runat="server" BoxLabel="不适用" cvalue="4" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel29" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout8" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel30" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout16" runat="server" LabelAlign="Left" LabelWidth="250">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PREPROCESSOR" runat="server" Width="400" FieldLabel="如果该器械经过再次处理后用户患者<br />请填写进行再处理的单位的名称和地址" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel31" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout9" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".3">
                                                                <ext:Panel ID="Panel32" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout17" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="USEDEXPIRY" runat="server" FieldLabel="<font color='red'>*</font>是否在有效期后使用"
                                                                                    AllowBlank="true" BlankText="请选择产品/批次信息中的是否在有效期后使用" MsgTarget="Side" Width="220">
                                                                                    <Items>
                                                                                        <ext:Radio ID="USEDEXPIRY_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                                        <ext:Radio ID="USEDEXPIRY_2" runat="server" BoxLabel="否" cvalue="2" />
                                                                                        <ext:Radio ID="USEDEXPIRY_4" runat="server" BoxLabel="不适用" cvalue="4" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel334" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout23" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".3">
                                                                <ext:Panel ID="Panel33" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout18" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor Horizontal="80%">
                                                                                <ext:RadioGroup ID="UPNEXPECTED" runat="server" FieldLabel="<font color='red'>*</font>产品能否退回"
                                                                                    AllowBlank="true" BlankText="请选择产品/批次信息中的产品能否被退回" MsgTarget="Side" AutoWidth="true"
                                                                                    Width="180">
                                                                                    <Items>
                                                                                        <ext:Radio ID="UPNEXPECTED_1" runat="server" BoxLabel="是" cvalue="1" AutoWidth="true">
                                                                                            <Listeners>
                                                                                                <Check Handler="isCanReturnCheck();" />
                                                                                            </Listeners>
                                                                                        </ext:Radio>
                                                                                        <ext:Radio ID="UPNEXPECTED_2" runat="server" BoxLabel="否" cvalue="2" AutoWidth="true">
                                                                                            <Listeners>
                                                                                                <Check Handler="isCanReturnCheck();" />
                                                                                            </Listeners>
                                                                                        </ext:Radio>
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".4">
                                                                <ext:Panel ID="Panel37" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout21" runat="server" LabelAlign="Left" LabelWidth="140">
                                                                            <ext:Anchor>
                                                                                <ext:NumberField ID="UPNQUANTITY" runat="server" Width="100" FieldLabel="<font color='red'>*</font>退回的数量"
                                                                                    AllowBlank="false" AllowDecimals="false" AllowNegative="false" BlankText="请填写退回的数量"
                                                                                    MsgTarget="Side" noedit="TRUE" Enabled="false" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel34" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout10" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".66">
                                                                <ext:Panel ID="Panel35" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout19" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor Horizontal="90%">
                                                                                <ext:CheckboxGroup ID="NORETURN" runat="server" FieldLabel="<font color='red'>*</font>不能寄回厂家的原因"
                                                                                    ColumnsNumber="6" AllowBlank="true" BlankText="请选择产品/批次信息中的不能寄回厂家的原因" MsgTarget="Side"
                                                                                    AutoWidth="true">
                                                                                    <Items>
                                                                                        <ext:Checkbox ID="NORETURN_10" runat="server" BoxLabel="已污染" cvalue="10" />
                                                                                        <ext:Checkbox ID="NORETURN_20" runat="server" BoxLabel="已丢弃" cvalue="20" />
                                                                                        <ext:Checkbox ID="NORETURN_30" runat="server" BoxLabel="已植入" cvalue="30" />
                                                                                        <ext:Checkbox ID="NORETURN_40" runat="server" BoxLabel="保留在医院" cvalue="40" />
                                                                                        <ext:Checkbox ID="NORETURN_50" runat="server" BoxLabel="不适用" cvalue="50" Enabled="false"
                                                                                            noedit="TRUE" />
                                                                                        <ext:Checkbox ID="NORETURN_99" runat="server" BoxLabel="其他 - 请说明" cvalue="99" />
                                                                                    </Items>
                                                                                </ext:CheckboxGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".34">
                                                                <ext:Panel ID="Panel36" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout20" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="NORETURNREASON" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                        </ext:RowLayout>
                                    </Body>
                                </ext:FieldSet>
                            </ext:LayoutRow>
                            <ext:LayoutRow>
                                <ext:FieldSet ID="FieldSet4" runat="server" Header="true" Frame="false" BodyBorder="true"
                                    AutoHeight="true" AutoWidth="true" Title="<%$ Resources: TabPanel.TabOperation.Title %>">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout4" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel40" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout11" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel41" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout22" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <%--<ext:Anchor>
                                                                                <ext:TextField ID="TBINITIALPDATE" runat="server" Width="200" FieldLabel="<font color='red'>*</font>首次手术日期"
                                                                                    AllowBlank="false" Enabled="false" noedit="TRUE" />
                                                                            </ext:Anchor>--%>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PNAME" runat="server" Width="200" FieldLabel="<font color='red'>*</font>手术名称"
                                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请填写手术名称" MsgTarget="Side" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="IMPLANTEDDATE" runat="server" Width="200" FieldLabel="植入日期（若有）" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel42" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout23" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="INDICATION" runat="server" Width="200" FieldLabel="<font color='red'>*</font>手术指征"
                                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请填写手术指征" MsgTarget="Side" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="EXPLANTEDDATE" runat="server" Width="200" FieldLabel="移出日期（若有）" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".34">
                                                                <ext:Panel ID="Panel43" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout24" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label5" runat="server" Text="&nbsp;" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label4" runat="server" Text="&nbsp;" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel46" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout13" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".66">
                                                                <ext:Panel ID="Panel47" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout26" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor Horizontal="100%">
                                                                                <ext:CheckboxGroup ID="POUTCOME" runat="server" FieldLabel="<font color='red'>*</font>手术结果"
                                                                                    ColumnsNumber="7" AllowBlank="true" BlankText="请选择手术信息中的手术结果" MsgTarget="Side"
                                                                                    AutoWidth="true">
                                                                                    <Items>
                                                                                        <ext:Checkbox ID="POUTCOME_1" runat="server" BoxLabel="使用此器械完成" cvalue="1" />
                                                                                        <ext:Checkbox ID="POUTCOME_2" runat="server" BoxLabel="使用另一件相同器械完成" cvalue="2" />
                                                                                        <ext:Checkbox ID="POUTCOME_3" runat="server" BoxLabel="使用其他器械完成" cvalue="3" />
                                                                                        <ext:Checkbox ID="POUTCOME_4" runat="server" BoxLabel="由于此事件而未能完成" cvalue="4" />
                                                                                        <ext:Checkbox ID="POUTCOME_5" runat="server" BoxLabel="由于缺乏相同器械而未能完成" cvalue="5" />
                                                                                        <ext:Checkbox ID="POUTCOME_6" runat="server" BoxLabel="由于其他原因而未能完成" cvalue="6" />
                                                                                        <ext:Checkbox ID="POUTCOME_99" runat="server" BoxLabel="不清楚" cvalue="99" />
                                                                                    </Items>
                                                                                </ext:CheckboxGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel38" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout18" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".34">
                                                                <ext:Panel ID="Panel49" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout28" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="IVUS" runat="server" FieldLabel="是否使用了IVUS" Width="100">
                                                                                    <Items>
                                                                                        <ext:Radio ID="IVUS_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                                        <ext:Radio ID="IVUS_2" runat="server" BoxLabel="否" cvalue="2" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel50" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout14" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel51" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout29" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="GENERATOR" runat="server" FieldLabel="是否使用了电刀" Width="100">
                                                                                    <Items>
                                                                                        <ext:Radio ID="GENERATOR_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                                        <ext:Radio ID="GENERATOR_2" runat="server" BoxLabel="否" cvalue="2" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel39" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout25" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="GENERATORTYPE" runat="server" Width="200" FieldLabel="电刀类型说明" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".34">
                                                                <ext:Panel ID="Panel52" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout30" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="GENERATORSET" runat="server" Width="200" FieldLabel="电刀设置" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel44" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout12" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".66">
                                                                <ext:Panel ID="Panel45" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout27" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor Horizontal="80%">
                                                                                <ext:RadioGroup ID="PCONDITION" runat="server" FieldLabel="<font color='red'>*</font>患者术后状况如何"
                                                                                    AllowBlank="true" BlankText="请选择手术信息中的患者手术后状况" MsgTarget="Side" AutoWidth="true">
                                                                                    <Items>
                                                                                        <ext:Radio ID="PCONDITION_1" runat="server" BoxLabel="稳定" cvalue="1" />
                                                                                        <ext:Radio ID="PCONDITION_2" runat="server" BoxLabel="接受手术治疗" cvalue="2" />
                                                                                        <ext:Radio ID="PCONDITION_3" runat="server" BoxLabel="死亡" cvalue="3" />
                                                                                        <ext:Radio ID="PCONDITION_99" runat="server" BoxLabel="其他" cvalue="99" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".34">
                                                                <ext:Panel ID="Panel48" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout31" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PCONDITIONOTHER" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                        </ext:RowLayout>
                                    </Body>
                                </ext:FieldSet>
                            </ext:LayoutRow>
                            <ext:LayoutRow>
                                <ext:FieldSet ID="FieldSet5" runat="server" Header="true" Frame="false" BodyBorder="true"
                                    AutoHeight="true" AutoWidth="true" Title="<%$ Resources: TabPanel.TabEffect.Title %>">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout5" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel54" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout15" runat="server">
                                                            <%--<ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel55" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout32" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="TBEDATE" runat="server" Width="200" FieldLabel="<font color='red'>*</font>事件日期"
                                                                                    AllowBlank="false" Enabled="false" noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>--%>
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel56" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout33" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor Horizontal="80%">
                                                                                <ext:CheckboxGroup ID="WHEREOCCUR" runat="server" FieldLabel="<font color='red'>*</font>问题发生在什么位置"
                                                                                    AllowBlank="true" BlankText="请选择事件信息中的问题发生在什么位置" MsgTarget="Side" AutoWidth="true">
                                                                                    <Items>
                                                                                        <ext:Checkbox ID="WHEREOCCUR_1" runat="server" BoxLabel="患者体内" cvalue="1" />
                                                                                        <ext:Checkbox ID="WHEREOCCUR_2" runat="server" BoxLabel="患者体外" cvalue="2" />
                                                                                        <ext:Checkbox ID="WHEREOCCUR_80" runat="server" BoxLabel="不适用" cvalue="80" />
                                                                                        <ext:Checkbox ID="WHEREOCCUR_99" runat="server" BoxLabel="不清楚" cvalue="99" />
                                                                                    </Items>
                                                                                </ext:CheckboxGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel58" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout16" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel59" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout35" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor Horizontal="90%">
                                                                                <ext:CheckboxGroup ID="WHENNOTICED" runat="server" FieldLabel="<font color='red'>*</font>发现问题的时间"
                                                                                    AllowBlank="true" BlankText="请选择事件信息中的发现问题的时间" MsgTarget="Side" AutoWidth="true">
                                                                                    <Items>
                                                                                        <ext:Checkbox ID="WHENNOTICED_1" runat="server" BoxLabel="打开包装时" cvalue="1" />
                                                                                        <ext:Checkbox ID="WHENNOTICED_2" runat="server" BoxLabel="准备手术时" cvalue="2" />
                                                                                        <ext:Checkbox ID="WHENNOTICED_3" runat="server" BoxLabel="插入时" cvalue="3" />
                                                                                        <ext:Checkbox ID="WHENNOTICED_4" runat="server" BoxLabel="手术过程中" cvalue="4" />
                                                                                        <ext:Checkbox ID="WHENNOTICED_5" runat="server" BoxLabel="退出时" cvalue="5" />
                                                                                        <ext:Checkbox ID="WHENNOTICED_6" runat="server" BoxLabel="手术结束时" cvalue="6" />
                                                                                        <ext:Checkbox ID="WHENNOTICED_7" runat="server" BoxLabel="术后" cvalue="7" />
                                                                                        <ext:Checkbox ID="WHENNOTICED_99" runat="server" BoxLabel="不清楚" cvalue="99" />
                                                                                    </Items>
                                                                                </ext:CheckboxGroup>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="EDESCRIPTION" runat="server" Width="900" MaxLength="400" FieldLabel="<font color='red'>*</font>事件描述"
                                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请填写时间描述" MsgTarget="Side" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel61" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout17" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".3">
                                                                <ext:Panel ID="Panel62" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout37" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="WITHLABELEDUSE" runat="server" FieldLabel="<font color='red'>*</font>是在按标示使用器械的<br />情况下发生该问题的吗"
                                                                                    AllowBlank="true" BlankText="请选择事件信息中的是在按标示使用器械的情况下发生该问题的吗" MsgTarget="Side"
                                                                                    AutoWidth="true">
                                                                                    <Items>
                                                                                        <ext:Radio ID="WITHLABELEDUSE_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                                        <ext:Radio ID="WITHLABELEDUSE_2" runat="server" BoxLabel="否" cvalue="2" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".7">
                                                                <ext:Panel ID="Panel63" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout38" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="NOLABELEDUSE" runat="server" Width="200" FieldLabel="如果不是，请解释" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel101" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout20" runat="server">
                                                            <ext:LayoutColumn>
                                                                <ext:Panel ID="Panel64" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout39" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="EVENTRESOLVED" runat="server" FieldLabel="<font color='red'>*</font>事情是否已解决"
                                                                                    AllowBlank="true" BlankText="请选择事件信息中的事情是否已解决" MsgTarget="Side" Width="180">
                                                                                    <Items>
                                                                                        <ext:Radio ID="EVENTRESOLVED_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                                        <ext:Radio ID="EVENTRESOLVED_2" runat="server" BoxLabel="否" cvalue="2" />
                                                                                        <ext:Radio ID="EVENTRESOLVED_5" runat="server" BoxLabel="不清楚" cvalue="5" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                        </ext:RowLayout>
                                    </Body>
                                </ext:FieldSet>
                            </ext:LayoutRow>
                            <ext:LayoutRow>
                                <ext:FieldSet ID="FSLog" runat="server" Header="true" Frame="false" BodyBorder="true"
                                    AutoHeight="true" AutoWidth="true" Title="审批记录">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout7" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel53" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout22" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel67" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FitLayout ID="FT2" runat="server">
                                                                            <ext:GridPanel ID="gpLog" runat="server" Title="审批记录" StoreID="OrderLogStore" AutoScroll="true"
                                                                                StripeRows="true" Collapsible="false" Border="true" Header="false" Icon="Lorry"
                                                                                AutoExpandColumn="OperNote" Height="200" AutoWidth="true">
                                                                                <ColumnModel ID="ColumnModel1" runat="server">
                                                                                    <Columns>
                                                                                        <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="操作人账号" Width="100">
                                                                                        </ext:Column>
                                                                                        <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="操作人姓名" Width="200">
                                                                                        </ext:Column>
                                                                                        <ext:Column ColumnID="OperTypeName" DataIndex="OperTypeName" Header="操作类型" Width="100">
                                                                                        </ext:Column>
                                                                                        <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="操作日期" Width="150">
                                                                                            <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                                                        </ext:Column>
                                                                                        <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="备注">
                                                                                        </ext:Column>
                                                                                    </Columns>
                                                                                </ColumnModel>
                                                                                <SelectionModel>
                                                                                    <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server"
                                                                                        MoveEditorOnEnter="true">
                                                                                    </ext:RowSelectionModel>
                                                                                </SelectionModel>
                                                                                <BottomBar>
                                                                                    <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="50" StoreID="OrderLogStore"
                                                                                        DisplayInfo="true" />
                                                                                </BottomBar>
                                                                                <SaveMask ShowMask="false" />
                                                                                <LoadMask ShowMask="true" />
                                                                            </ext:GridPanel>
                                                                        </ext:FitLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                        </ext:RowLayout>
                                    </Body>
                                </ext:FieldSet>
                            </ext:LayoutRow>
                        </ext:RowLayout>
                    </Body>
                </ext:Panel>
            </Center>
        </ext:BorderLayout>
    </Body>
    <Buttons>
        <ext:Button ID="SubmitButton" runat="server" Text="<%$ Resources: DetailWindow.SubmitButton.Text %>"
            Icon="LorryAdd">
            <Listeners>
                <Click Handler="CheckBSCSubmit();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="CancelButton" runat="server" Text="<%$ Resources: DetailWindow.CancelButton.Text %>"
            Icon="Delete">
            <Listeners>
                <Click Handler="CancelBSCSubmit();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="ConfirmButton" runat="server" Text="确认收货" Icon="LorryAdd">
            <Listeners>
                <Click Handler="ConfirmBSCSubmit();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="DeliverToBSCButton" runat="server" Text="快递单号" Icon="LorryAdd">
            <Listeners>
                <Click Handler="Coolite.AjaxMethods.DealerComplainBSCEdit.ShowCarrierWindow();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="DeleteButton" runat="server" Text="<%$ Resources: DetailWindow.DeleteButton.Text %>"
            Icon="Cancel">
            <Listeners>
                <Click Handler="CloseBSCWindow();" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
<ext:Window ID="windowCarrier" runat="server" Icon="Group" Title="填写快递单号" Resizable="false"
    Header="false" Width="390" Height="180" AutoShow="false" Modal="true" ShowOnLoad="false"
    BodyStyle="padding:5px;">
    <Body>
        <ext:FormLayout ID="FormLayout36" runat="server">
            <ext:Anchor>
                <ext:Panel ID="Panel65" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout21" runat="server">
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="Panel66" runat="server" Border="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout42" runat="server" LabelWidth="100">
                                            <ext:Anchor>
                                                <ext:TextField ID="tbRemark" runat="server" FieldLabel="快递单号" Width="200" />
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
        <ext:Button ID="btnCarrieSubmit" runat="server" Text="提交" Icon="Tick">
            <Listeners>
                <Click Handler="Coolite.AjaxMethods.DealerComplainBSCEdit.SubmitCarrier({success:function(){Ext.Msg.alert('Success', msgBSCList.msg4);RefreshMainPage();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnCarrierCancel" runat="server" Text="取消" Icon="Delete">
            <Listeners>
                <Click Handler="#{windowCarrier}.hide();" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
