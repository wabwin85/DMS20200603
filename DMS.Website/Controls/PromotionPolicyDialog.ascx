<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PromotionPolicyDialog.ascx.cs"
    Inherits="DMS.Website.Controls.PromotionPolicyDialog" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>

<script type="text/javascript" language="javascript">
  var odwMsgList = {
        msg1:"确定要执行此操作？",
        msg2:"复制成功",
        msg3:"政策已撤销",
        msg4:"已设置无效状态",
        msg5:"关闭后该政策将设为无效<br/>确定要执行关闭操作？"
    }
    
    var instanceid=function() {
        var aa= Ext.getCmp('<%=this.hidInstanceId.ClientID%>');
        return aa.getValue();
    }
    var policystyle=function() {
        var aa= Ext.getCmp('<%=this.hidPolicyStyle.ClientID%>');
        return aa.getValue();
    }
    var policystylesub=function() {
        var aa= Ext.getCmp('<%=this.hidPolicyStyleSub.ClientID%>');
        return aa.getValue();
    }
    var productlineid=function() {
        var aa= Ext.getCmp('<%=this.cbWdProductLine.ClientID%>');
        return aa.getValue();
    }
    var subbu=function() {
        var aa= Ext.getCmp('<%=this.cbWdSubBU.ClientID%>');
        return aa.getValue();
    }
    var pagetype=function() {
        var aa= Ext.getCmp('<%=this.hidPageType.ClientID%>');
        return aa.getValue();
    }
   var promotionstate=function() {
        var aa= Ext.getCmp('<%=this.hidPromotionState.ClientID%>');
        return aa.getValue();
    }
 
  function RefreshFactorRuleWindow() {
      Ext.getCmp('<%=this.GridFactorRule.ClientID%>').reload();
     }
    
  function RefreshDetailWindow() {
        Ext.getCmp('<%=this.cbWdProductLine.ClientID%>').store.reload();
        Ext.getCmp('<%=this.GridFactorRule.ClientID%>').reload();
        Ext.getCmp('<%=this.GpWdAttachment.ClientID%>').reload();
    }
    
    function RefreshSubBUWindow() {
        Ext.getCmp('<%=this.cbWdSubBU.ClientID%>').store.reload();
       
    }
    
    
   var selectedFactorRule = function(grid,row, record)
       {
          Ext.getCmp('<%=this.hidPolicyFactor.ClientID%>').setValue(record.data["Id"]);  
          
          Ext.getCmp("GridFactorRule").reload();
       }
       
    function ValidateForm() {
        var errMsg = "";
        var isForm1Valid = Ext.getCmp('<%=this.FormPanelHard1.ClientID%>').getForm().isValid();
        var tabPanel = Ext.getCmp('<%=this.TabPanel1.ClientID%>')
      
        if (!isForm1Valid) {
            errMsg = "信息填写不完整" ;
        }
        
        if (errMsg != "") {
            tabPanel.setActiveTab(0);
            Ext.Msg.alert('Message', errMsg);
        } else {
            Ext.Msg.confirm('Message', odwMsgList.msg1,
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.PromotionPolicyDialog.Submit(
                            {
                                success: function(result) { if(result=='') {
                                        Ext.Msg.alert('Message', '提交成功');
                                        Ext.getCmp('<%=this.PolicyDetailWindow.ClientID%>').hide();
                                        RefreshMainPage();
                                    }
                                    else{
                                        Ext.Msg.alert('Error', result);
                                    }
                                    
                                },
                                failure: function(err) {
                                    Ext.Msg.alert('Error', err);
                                }
                            }
                        );      
                    }
                })
        }
    
    }    

   
     var NeedSave = function() {
        var isModified = Ext.getCmp('<%=this.hidIsModified.ClientID%>').getValue() == "True" ? true : false;
        var isPageNew = Ext.getCmp('<%=this.hidIsPageNew.ClientID%>').getValue() == "True" ? true : false;
        var isSaved = Ext.getCmp('<%=this.hidIsSaved.ClientID%>').getValue() == "True" ? true : false;  
       
        if (!isSaved) {
            if (isModified) {
                Ext.Msg.confirm('Warning', '数据已被修改，是否保存？',
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.PromotionPolicyDialog.SaveDraft(
                        {
                            success: function(result) {
                                if(result=='')
                                {
                                    Ext.getCmp('<%=this.PolicyDetailWindow.ClientID%>').hide();
                                    RefreshMainPage();
                                }else{
                                    Ext.Msg.alert('Error', result);
                                }
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                        );
                    } else {
                        if (isPageNew) {
                            Coolite.AjaxMethods.PromotionPolicyDialog.DeleteDraft(
                            {
                                success: function() {
                                    Ext.getCmp('<%=this.PolicyDetailWindow.ClientID%>').hide();
                                    RefreshMainPage();
                                },
                                failure: function(err) {
                                    Ext.Msg.alert('Error', err);
                                }
                            }
                            );
                        } else {
                            Ext.getCmp('<%=this.hidIsSaved.ClientID%>').setValue("True");
                            Ext.getCmp('<%=this.PolicyDetailWindow.ClientID%>').hide();
                        }
                    }
                });
                return true;
            } else if (isPageNew) {
                Coolite.AjaxMethods.PromotionPolicyDialog.DeleteDraft(
                {
                    success: function() {
                        Ext.getCmp('<%=this.PolicyDetailWindow.ClientID%>').hide();
                        RefreshMainPage();
                    },
                    failure: function(err) {
                        Ext.Msg.alert('Error', err);
                    }
                }
                );
                return true;
            }
        }
    }
    
    var SetModified = function(isModified) {
        Ext.getCmp('<%=this.hidIsModified.ClientID%>').setValue(isModified ? "True" : "False");
    }
    
   function RefreshTopValuesWindow() {
        Ext.getCmp('<%=this.GridWd6RuleDetail.ClientID%>').store.reload();
    }
   
   function getIsErrRowClass(record, index) {
        if (record.data.ISErr==1)
        {
           return 'yellow-row';
        }
    }
    
    var reloadFlag = false;
    var lastQuery = '';
    var reloadFlag2 = false;
        
    function  SetPageActivateUrl(){
        var taburl=Ext.getCmp('<%=this.Tab1.ClientID%>');
        var instanceId=Ext.getCmp('<%=this.hidInstanceId.ClientID%>');
        var pageType=Ext.getCmp('<%=this.hidPageType.ClientID%>');
        var promotionState=Ext.getCmp('<%=this.hidPromotionState.ClientID%>');
       
        taburl.autoLoad.url = '/Pages/Promotion/PolicyFactorInfo.aspx?InstanceId=' + instanceId.getValue() +'&PageType='+pageType.getValue()+'&PromotionState='+promotionState.getValue();
        var currentQuery = instanceId.getValue();
        reloadFlag = (lastQuery != currentQuery);
        lastQuery = currentQuery;
    }
    
   function SetRulePageActivate() {
        var hidPageType = Ext.getCmp('<%=this.hidPageType.ClientID%>');
        var hidPromotionType = Ext.getCmp('<%=this.hidPromotionState.ClientID%>');
        var btnAddFactorRule = Ext.getCmp('<%=this.btnAddFactorRule.ClientID%>');
        var GridFactorRule = Ext.getCmp('<%=this.GridFactorRule.ClientID%>');
        
        if (hidPageType.getValue()=='View')
        {
            GridFactorRule.getColumnModel().setHidden(2, true);
            btnAddFactorRule.disable();
        }
        else if (hidPageType.getValue()=='Modify' && (hidPromotionType.getValue()=='审批中' || hidPromotionType.getValue()=='有效'|| hidPromotionType.getValue()=='无效'|| hidPromotionType.getValue()=='审批拒绝'))
        {
            GridFactorRule.getColumnModel().setHidden(2, true);
            btnAddFactorRule.disable();
        }else{
            GridFactorRule.getColumnModel().setHidden(2, false);
            btnAddFactorRule.enable();
        }
    }
    
   function SetAttachmentPageActivate() {
        var hidPageType = Ext.getCmp('<%=this.hidPageType.ClientID%>');
        var hidPromotionType = Ext.getCmp('<%=this.hidPromotionState.ClientID%>');
        var btnPolicyAttachmentAdd = Ext.getCmp('<%=this.btnPolicyAttachmentAdd.ClientID%>');
        var GpWdAttachment = Ext.getCmp('<%=this.GpWdAttachment.ClientID%>');
   
        
        if (hidPageType.getValue()=='View')
        {
            GpWdAttachment.getColumnModel().setHidden(4, true);
            btnPolicyAttachmentAdd.disable();
         
        }
        else if (hidPageType.getValue()=='Modify' && (hidPromotionType.getValue()=='审批中' || hidPromotionType.getValue()=='有效'|| hidPromotionType.getValue()=='无效'|| hidPromotionType.getValue()=='审批拒绝'))
        {
            GpWdAttachment.getColumnModel().setHidden(4, true);
            btnPolicyAttachmentAdd.disable();
        }else{
            GpWdAttachment.getColumnModel().setHidden(4, false);
            btnPolicyAttachmentAdd.enable();
        }
    } 
</script>

<ext:Hidden ID="hidPageType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidIsPageNew" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidIsModified" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidIsSaved" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidInstanceId" runat="server">
</ext:Hidden>
<%--Add in  20160525 --%>
<ext:Hidden ID="hidPolicyStyle" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidPolicyStyleSub" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidPromotionState" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidProductLine" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidSubBU" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidPeriod" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidConvert" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidProTO" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidMinusLastGift" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidIncrement" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidAddLastLeft" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidCarryType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidProToType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidTopType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidPolicyClass" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidAcquisition" runat="server">
</ext:Hidden>
<%--促销因素ID--%>
<ext:Hidden ID="hidPolicyFactor" runat="server">
</ext:Hidden>
<ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLine"
    AutoLoad="false">
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
    <Listeners>
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbWdProductLine}.setValue(#{cbWdProductLine}.store.getTotalCount()>0?#{cbWdProductLine}.store.getAt(0).get('Id'):'');#{hidProductLine}.setValue(#{cbWdProductLine}.getValue()); #{SubBUStore}.reload();}else{#{cbWdProductLine}.setValue(#{hidProductLine}.getValue());if(#{hidProductLine}.getValue()!=''){#{SubBUStore}.reload();};}" />
    </Listeners>
    <SortInfo Field="Id" Direction="ASC" />
</ext:Store>
<ext:Store ID="SubBUStore" runat="server" UseIdConfirmation="true" OnRefreshData="SubBUStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="SubBUCode">
            <Fields>
                <ext:RecordField Name="SubBUCode" />
                <ext:RecordField Name="SubBUName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="#{cbWdSubBU}.setValue(#{hidSubBU}.getValue());" />
    </Listeners>
    <SortInfo Field="SubBUCode" Direction="ASC" />
</ext:Store>
<ext:Store ID="TypeStore" runat="server" OnRefreshData="TypeStore_RefreshData" AutoLoad="false">
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
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbWdPolicyType}.setValue(#{cbWdPolicyType}.store.getTotalCount()>0?#{cbWdPolicyType}.store.getAt(0).get('Key'):'');#{hidType}.setValue(#{cbWdPolicyType}.getValue()); #{cbWdProTO}.enable();}else{#{cbWdPolicyType}.setValue(#{hidType}.getValue()); if(#{hidType}.getValue()=='采购赠'){#{cbWdProTO}.disable();} else{#{cbWdProTO}.enable();}  }" />
    </Listeners>
</ext:Store>
<ext:Store ID="PeriodStore" runat="server" OnRefreshData="PeriodStore_RefreshData"
    AutoLoad="false">
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
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbWdPeriod}.setValue(#{cbWdPeriod}.store.getTotalCount()>0?#{cbWdPeriod}.store.getAt(0).get('Key'):'');#{hidPeriod}.setValue(#{cbWdPeriod}.getValue());}else{#{cbWdPeriod}.setValue(#{hidPeriod}.getValue());}" />
    </Listeners>
</ext:Store>
<ext:Store ID="ConvertStore" runat="server" OnRefreshData="ConvertStore_RefreshData"
    AutoLoad="false">
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
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbWdIfConvert}.setValue(#{cbWdIfConvert}.store.getTotalCount()>0?#{cbWdIfConvert}.store.getAt(0).get('Key'):'');#{hidConvert}.setValue(#{cbWdIfConvert}.getValue());}else{#{cbWdIfConvert}.setValue(#{hidConvert}.getValue());}" />
    </Listeners>
</ext:Store>
<ext:Store ID="ProTOStore" runat="server" OnRefreshData="ProTOStore_RefreshData"
    AutoLoad="false">
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
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbWdProTO}.setValue(#{cbWdProTO}.store.getTotalCount()>0?#{cbWdProTO}.store.getAt(0).get('Key'):'');#{hidProTO}.setValue(#{cbWdProTO}.getValue());}else{#{cbWdProTO}.setValue(#{hidProTO}.getValue());}" />
    </Listeners>
</ext:Store>
<ext:Store ID="ProToTypeStore" runat="server" OnRefreshData="ProToTypeStore_RefreshData"
    AutoLoad="false">
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
        <Load Handler="#{cbWdProToType}.setValue(#{hidProToType}.getValue());" />
    </Listeners>
</ext:Store>
<ext:Store ID="TopTypeStore" runat="server" OnRefreshData="TopTypeStore_RefreshData"
    AutoLoad="false">
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
        <Load Handler="#{cbWdTopType}.setValue(#{hidTopType}.getValue());" />
    </Listeners>
</ext:Store>
<ext:Store ID="MinusLastGiftStore" runat="server" OnRefreshData="MinusLastGiftStore_RefreshData"
    AutoLoad="false">
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
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbWdMinusLastGift}.setValue(#{cbWdMinusLastGift}.store.getTotalCount()>0?#{cbWdMinusLastGift}.store.getAt(0).get('Key'):'');#{hidMinusLastGift}.setValue(#{cbWdMinusLastGift}.getValue());}else{#{cbWdMinusLastGift}.setValue(#{hidMinusLastGift}.getValue());}" />
    </Listeners>
    <SortInfo Field="Key" Direction="DESC" />
</ext:Store>
<ext:Store ID="IncrementStore" runat="server" OnRefreshData="IncrementStore_RefreshData"
    AutoLoad="false">
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
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbWdIncrement}.setValue(#{cbWdIncrement}.store.getTotalCount()>0?#{cbWdIncrement}.store.getAt(0).get('Key'):'');#{hidIncrement}.setValue(#{cbWdIncrement}.getValue());}else{#{cbWdIncrement}.setValue(#{hidIncrement}.getValue());}" />
    </Listeners>
</ext:Store>
<ext:Store ID="AddLastLeftStore" runat="server" OnRefreshData="AddLastLeftStore_RefreshData"
    AutoLoad="false">
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
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbWdAddLastLeft}.setValue(#{cbWdAddLastLeft}.store.getTotalCount()>0?#{cbWdAddLastLeft}.store.getAt(0).get('Key'):'');#{hidAddLastLeft}.setValue(#{cbWdAddLastLeft}.getValue());}else{#{cbWdAddLastLeft}.setValue(#{hidAddLastLeft}.getValue());}" />
    </Listeners>
</ext:Store>
<ext:Store ID="CarryTypeStore" runat="server" OnRefreshData="CarryTypeStore_RefreshData"
    AutoLoad="false">
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
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbWdCarryType}.setValue(#{cbWdCarryType}.store.getTotalCount()>0?#{cbWdCarryType}.store.getAt(0).get('Key'):'');#{hidCarryType}.setValue(#{cbWdCarryType}.getValue());}else{#{cbWdCarryType}.setValue(#{hidCarryType}.getValue());}" />
    </Listeners>
</ext:Store>
<ext:Store ID="PolicyClassStore" runat="server" OnRefreshData="PolicyClassStore_RefreshData"
    AutoLoad="false">
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
        <Load Handler="#{cbWdPolicyClass}.setValue(#{hidPolicyClass}.getValue());" />
    </Listeners>
</ext:Store>
<ext:Store ID="BusinessAcquisitionStore" runat="server" OnRefreshData="AcquisitionStore_RefreshData"
    AutoLoad="false">
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
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbWdAcquisition}.setValue(#{cbWdAcquisition}.store.getTotalCount()>0?#{cbWdAcquisition}.store.getAt(0).get('Key'):'');#{hidAcquisition}.setValue(#{cbWdAcquisition}.getValue());}else{#{cbWdAcquisition}.setValue(#{hidAcquisition}.getValue());}" />
    </Listeners>
</ext:Store>
<%--政策因素--%>
<%--<ext:Store ID="FolicyFactorStore" runat="server" OnRefreshData="FolicyFactorStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="PolicyFactorId">
            <Fields>
                <ext:RecordField Name="PolicyFactorId" />
                <ext:RecordField Name="PolicyId" />
                <ext:RecordField Name="FactId" />
                <ext:RecordField Name="FactName" />
                <ext:RecordField Name="FactDesc" />
                <ext:RecordField Name="IsGift" />
                <ext:RecordField Name="IsGiftName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>--%>
<%--因素规则--%>
<ext:Store ID="FactorRuleStore" runat="server" OnRefreshData="FactorRuleStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="RuleId" />
                <ext:RecordField Name="PolicyId" />
                <ext:RecordField Name="RuleDesc" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<%--政策附件--%>
<ext:Store ID="AttachmentStore" runat="server" OnRefreshData="AttachmentStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Attachment" />
                <ext:RecordField Name="Name" />
                <ext:RecordField Name="Url" />
                <ext:RecordField Name="Type" />
                <ext:RecordField Name="UploadUser" />
                <ext:RecordField Name="Identity_Name" />
                <ext:RecordField Name="UploadDate" />
                <ext:RecordField Name="TypeName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Window ID="PolicyDetailWindow" runat="server" Icon="Group" Title="促销政策维护" Width="1020"
    Height="550" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false" Maximizable="true">
    <Body>
        <ext:FitLayout ID="FitLayout1" runat="server">
            <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true">
                <Tabs>
                    <ext:Tab ID="TabHeader" runat="server" Title="政策概要" BodyStyle="padding: 6px;" AutoScroll="true">
                        <%--表头信息 --%>
                        <Body>
                            <ext:FitLayout ID="FTHeader" runat="server">
                                <ext:FormPanel ID="FormPanelHard" runat="server" Header="false" Border="false">
                                    <Body>
                                        <ext:FormPanel ID="FormPanelHard1" runat="server" Border="false" FormGroup="true">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout3" runat="server" Split="false">
                                                    <ext:LayoutColumn ColumnWidth="0.4">
                                                        <ext:Panel ID="Panel4" runat="server" Border="false" FormGroup="true">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtWdPolicyNo" runat="server" FieldLabel="政策编号" ReadOnly="true"
                                                                            AllowBlank="true" Enabled="false" Width="160">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdProductLine" runat="server" EmptyText="选择产品线..." Width="160"
                                                                            Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                                            BlankText="选择产品线" AllowBlank="false" Mode="Local" DisplayField="AttributeName"
                                                                            FieldLabel="<font color='red'><b>产品线</b></font>" ListWidth="200" Resizable="true">
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                                                                            </Triggers>
                                                                            <Listeners>
                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                                <Select Handler=" #{hidProductLine}.setValue(#{cbWdProductLine}.getValue()); #{hidSubBU}.setValue(''); #{SubBUStore}.reload(); " />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtWdPolicyName" runat="server" FieldLabel="<font color='red'><b>政策名称</b></font>"
                                                                            Width="160" AllowBlank="false" BlankText="政策名称">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:DateField ID="dfWdBeginDate" runat="server" Width="160" FieldLabel="<font color='red'><b>开始时间</b></font>"
                                                                            EmptyText="促销开始时间" BlankText="开始时间" AllowBlank="false" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdProTO" runat="server" EmptyText="选择结算对象..." Width="160" Editable="false"
                                                                            TypeAhead="true" BlankText="选择结算对象" AllowBlank="false" Mode="Local" FieldLabel="<font color='red'><b>结算对象</b></font>"
                                                                            Resizable="true">
                                                                            <Items>
                                                                                <ext:ListItem Value="ByDealer" Text="经销商" />
                                                                                <ext:ListItem Value="ByHospital" Text="医院" />
                                                                            </Items>
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                                                                            </Triggers>
                                                                            <Listeners>
                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                                <Select Handler="if(#{cbWdProTO}.getValue()=='ByDealer') { #{cbWdProToType}.clearValue(); #{cbWdProToType}.enable();#{cbWdObjectAdd}.setVisible(true)} else { #{cbWdProToType}.clearValue(); #{cbWdProToType}.disable();#{cbWdObjectAdd}.setVisible(false)}" />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdPeriod" runat="server" EmptyText="选择经销商结算周期..." Width="160"
                                                                            Editable="false" TypeAhead="true" BlankText="选择经销商结算周期" AllowBlank="false" Mode="Local"
                                                                            FieldLabel="<font color='red'><b>经销商结算周期</b></font>" Resizable="true">
                                                                            <Items>
                                                                                <ext:ListItem Value="季度" Text="季度" />
                                                                                <ext:ListItem Value="年度" Text="年度" />
                                                                                <ext:ListItem Value="月度" Text="月度" />
                                                                            </Items>
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
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
                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                        <ext:Panel ID="Panel5" runat="server" Border="false" FormGroup="true">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdPolicyType" runat="server" EmptyText="请选择促销计算基数..." Width="160"
                                                                            Editable="false" Disabled="false" TypeAhead="true" BlankText="选择促销计算基数" Resizable="true"
                                                                            AllowBlank="false" Mode="Local" FieldLabel="<font color='red'><b>促销计算基数</b></font>">
                                                                            <Items>
                                                                                <ext:ListItem Value="植入赠" Text="植入" />
                                                                                <ext:ListItem Value="采购赠" Text="采购" />
                                                                            </Items>
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                                                                            </Triggers>
                                                                            <Listeners>
                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                                <Select Handler="  Coolite.AjaxMethods.PromotionPolicyDialog.ChangePolicyType(#{cbWdPolicyType}.getValue(),{success:function(){  if(#{hidIsPageNew}.getValue()=='True'){ reloadFlag2=true;}},failure:function(err){Ext.Msg.alert('Error', err);}}); if(#{cbWdPolicyType}.getValue()=='采购赠') {#{cbWdProTO}.setValue('ByDealer');#{cbWdProToType}.clearValue(); #{cbWdProToType}.enable();#{cbWdObjectAdd}.setVisible(true);#{cbWdProTO}.disable()} else {  #{cbWdProTO}.enable();} " />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdSubBU" runat="server" EmptyText="请选择SubBU..." Width="160" Editable="false"
                                                                            Disabled="false" TypeAhead="true" StoreID="SubBUStore" ValueField="SubBUCode"
                                                                            Resizable="true" AllowBlank="true" Mode="Local" DisplayField="SubBUName" FieldLabel="SubBU">
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                            </Triggers>
                                                                            <Listeners>
                                                                                <TriggerClick Handler="this.clearValue(); #{hidSubBU}.setValue('');" />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtWdPolicyGroupName" runat="server" FieldLabel="分组名称" Width="160"
                                                                            AllowBlank="true">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:DateField ID="dfWdEndDate" runat="server" Width="160" FieldLabel="<font color='red'><b>终止时间</b></font>"
                                                                            EmptyText="促销终止时间" BlankText="终止时间" AllowBlank="false" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdIfConvert" runat="server" EmptyText="选择是否转换..." Width="160"
                                                                            Hidden="true" Editable="false" TypeAhead="true" BlankText="选择赠品是否转换" AllowBlank="false"
                                                                            Mode="Local" FieldLabel="<font color='red'><b>赠品是否转换</b></font>" Resizable="true">
                                                                            <Items>
                                                                                <ext:ListItem Value="N" Text="不转换" />
                                                                                <ext:ListItem Value="Y" Text="转积分" />
                                                                                <ext:ListItem Value="CA" Text="转金额" />
                                                                            </Items>
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                                                                            </Triggers>
                                                                            <Listeners>
                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:Panel ID="pPolicyContent" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:ColumnLayout ID="ColumnLayout1" runat="server" Split="false">
                                                                                    <ext:LayoutColumn ColumnWidth="0.5">
                                                                                        <ext:Panel ID="Panel1" runat="server" Border="true" FormGroup="true">
                                                                                            <Body>
                                                                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                                                    <ext:Anchor>
                                                                                                        <ext:ComboBox ID="cbWdProToType" runat="server" Width="160" Editable="false" TypeAhead="true"
                                                                                                            BlankText="选择指定类型" AllowBlank="true" Mode="Local" FieldLabel="指定类型" Resizable="true">
                                                                                                            <Items>
                                                                                                                <ext:ListItem Value="ByDealer" Text="指定经销商" />
                                                                                                                <ext:ListItem Value="ByAuth" Text="所有代理商" />
                                                                                                            </Items>
                                                                                                            <Triggers>
                                                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
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
                                                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                                                        <ext:Panel ID="Panel2" runat="server" Border="true" FormGroup="true">
                                                                                            <Body>
                                                                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left">
                                                                                                    <ext:Anchor>
                                                                                                        <ext:Button ID="cbWdObjectAdd" runat="server" Text="维护" Icon="PackageAdd">
                                                                                                            <Listeners>
                                                                                                                <Click Handler="if(#{cbWdProToType}.getValue()=='') {Ext.Msg.alert('Error', '请选择指定类型');} else {Coolite.AjaxMethods.PromotionPolicyDealers.Show(#{hidInstanceId}.getValue(''),#{cbWdProductLine}.getValue(),#{cbWdSubBU}.getValue(),#{hidPageType}.getValue(),#{hidPromotionState}.getValue(),{success:function(){RefreshDetailWindow7();},failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                                                                                                            </Listeners>
                                                                                                        </ext:Button>
                                                                                                    </ext:Anchor>
                                                                                                </ext:FormLayout>
                                                                                            </Body>
                                                                                        </ext:Panel>
                                                                                    </ext:LayoutColumn>
                                                                                </ext:ColumnLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:Button ID="btnWdPointRatio" runat="server" Text="维护二级到平台的加价率" Icon="PackageAdd">
                                                                            <Listeners>
                                                                                <Click Handler="Coolite.AjaxMethods.PromotionPolicyDialog.PolicyPointRatio({success:function(){ #{GridPanelPointRatio}.reload()},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                                            </Listeners>
                                                                        </ext:Button>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:FormPanel>
                                        <ext:FormPanel ID="FormPanel1" runat="server" Border="false" FormGroup="true">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout7" runat="server" Split="false">
                                                    <ext:LayoutColumn ColumnWidth="0.4">
                                                        <ext:Panel ID="Panel15" runat="server" Border="false" FormGroup="true">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout14" runat="server" LabelAlign="Left">
                                                                    <ext:Anchor>
                                                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:ColumnLayout ID="ColumnLayout2" runat="server" Split="false">
                                                                                    <ext:LayoutColumn ColumnWidth="0.8">
                                                                                        <ext:Panel ID="Panel6" runat="server" Border="true" FormGroup="true">
                                                                                            <Body>
                                                                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left">
                                                                                                    <ext:Anchor>
                                                                                                        <ext:ComboBox ID="cbWdTopType" runat="server" EmptyText="选择封顶类型..." Width="160" Editable="false"
                                                                                                            TypeAhead="true" BlankText="选择封顶类型" AllowBlank="true" Mode="Local" FieldLabel="封顶类型"
                                                                                                            Resizable="true">
                                                                                                            <Items>
                                                                                                                <ext:ListItem Value="Policy" Text="政策统一值" />
                                                                                                                <ext:ListItem Value="Dealer" Text="经销商" />
                                                                                                                <ext:ListItem Value="Hospital" Text="医院" />
                                                                                                            </Items>
                                                                                                            <Triggers>
                                                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                                                            </Triggers>
                                                                                                            <Listeners>
                                                                                                                <TriggerClick Handler="this.clearValue(); #{txtWdTopValue}.setValue(''); #{txtWdTopValue}.disable();#{btnWdTopType}.setVisible(false);" />
                                                                                                                <%--<Select Handler=" if(#{cbWdTopType}.getValue()=='Policy') {#{btnWdTopType}.setVisible(false); #{txtWdTopValue}.enable();} else { #{btnWdTopType}.setVisible(true);#{txtWdTopValue}.setValue(''); #{txtWdTopValue}.disable();}" />--%>
                                                                                                                <Select Handler="Coolite.AjaxMethods.PromotionPolicyDialog.TopValuesClaer({success:function(){if(#{cbWdTopType}.getValue()=='Policy') {#{btnWdTopType}.setVisible(false); #{txtWdTopValue}.enable();} else { #{btnWdTopType}.setVisible(true);#{txtWdTopValue}.setValue(''); #{txtWdTopValue}.disable();}},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                                                                            </Listeners>
                                                                                                        </ext:ComboBox>
                                                                                                    </ext:Anchor>
                                                                                                </ext:FormLayout>
                                                                                            </Body>
                                                                                        </ext:Panel>
                                                                                    </ext:LayoutColumn>
                                                                                    <ext:LayoutColumn ColumnWidth="0.2">
                                                                                        <ext:Panel ID="Panel7" runat="server" Border="true" FormGroup="true">
                                                                                            <Body>
                                                                                                <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left">
                                                                                                    <ext:Anchor>
                                                                                                        <ext:Button ID="btnWdTopType" runat="server" Text="维护" Icon="PackageAdd" Hidden="true">
                                                                                                            <Listeners>
                                                                                                                <Click Handler="Coolite.AjaxMethods.PromotionPolicyDialog.TopValuesShow(#{hidInstanceId}.getValue(),{success:function(){RefreshTopValuesWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                                                                            </Listeners>
                                                                                                        </ext:Button>
                                                                                                    </ext:Anchor>
                                                                                                </ext:FormLayout>
                                                                                            </Body>
                                                                                        </ext:Panel>
                                                                                    </ext:LayoutColumn>
                                                                                </ext:ColumnLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdMinusLastGift" runat="server" EmptyText="选择是否扣除上期赠品..." Width="160"
                                                                            Editable="false" TypeAhead="true" BlankText="选择是否扣除上期赠品" AllowBlank="false" Mode="Local"
                                                                            FieldLabel="<font color='red'><b>扣除上期赠品</b></font>" Resizable="true">
                                                                            <Items>
                                                                                <ext:ListItem Value="Y" Text="是" />
                                                                                <ext:ListItem Value="N" Text="否" />
                                                                            </Items>
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                                                                            </Triggers>
                                                                            <Listeners>
                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:Label ID="lbWdRemarkMinusLastGift" runat="server" FieldLabel="" LabelSeparator=""
                                                                            Text="注释：本期计算基数中是否要扣除上期赠品数量">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdIncrement" runat="server" EmptyText="选择是否增量计算..." Width="160"
                                                                            Editable="false" TypeAhead="true" BlankText="选择是否增量计算" AllowBlank="false" Mode="Local"
                                                                            FieldLabel="<font color='red'><b>增量计算</b></font>" Resizable="true">
                                                                            <Items>
                                                                                <ext:ListItem Value="N" Text="否" />
                                                                                <ext:ListItem Value="Y" Text="是" />
                                                                            </Items>
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                                                                            </Triggers>
                                                                            <Listeners>
                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:Label ID="lbWdRemarkIncrement" runat="server" FieldLabel="" LabelSeparator=""
                                                                            Text="注释：达成指标以外的部分作为计算基数计算赠品">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdAcquisition" runat="server" EmptyText="选择计入达成与返利..." Width="160"
                                                                            Editable="false" TypeAhead="true" BlankText="选择是否计入达成与返利" AllowBlank="false"
                                                                            Mode="Local" FieldLabel="<font color='red'><b>计入返利与达成</b></font>" Resizable="true">
                                                                            <Items>
                                                                                <ext:ListItem Value="N" Text="否" />
                                                                                <ext:ListItem Value="Y" Text="是" />
                                                                            </Items>
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                                                                            </Triggers>
                                                                            <Listeners>
                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:Label ID="lbWdAcquisition" runat="server" FieldLabel="" LabelSeparator="" Text="注释：赠送是否计入商业采购达成与返利计算">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                        <ext:Panel ID="Panel16" runat="server" Border="false" FormGroup="true">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout15" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                    <ext:Anchor>
                                                                        <ext:Panel ID="Panel8" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:ColumnLayout ID="ColumnLayout4" runat="server" Split="false">
                                                                                    <ext:LayoutColumn ColumnWidth="0.5">
                                                                                        <ext:Panel ID="Panel11" runat="server" Border="true" FormGroup="true">
                                                                                            <Body>
                                                                                                <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                                                    <ext:Anchor>
                                                                                                        <ext:NumberField ID="txtWdTopValue" runat="server" FieldLabel="封顶值" Width="160" Enabled="false">
                                                                                                        </ext:NumberField>
                                                                                                    </ext:Anchor>
                                                                                                </ext:FormLayout>
                                                                                            </Body>
                                                                                        </ext:Panel>
                                                                                    </ext:LayoutColumn>
                                                                                    <ext:LayoutColumn ColumnWidth="0.5">
                                                                                        <ext:Panel ID="Panel12" runat="server" Border="true" FormGroup="true">
                                                                                            <Body>
                                                                                                <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left">
                                                                                                    <ext:Anchor>
                                                                                                        <ext:Label ID="txtlabTop" runat="server" HideLabel="true" Text="Unit/RMB(含税)">
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
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdCarryType" runat="server" EmptyText="选择进位方式..." Width="160"
                                                                            Editable="false" TypeAhead="true" BlankText="选择进位方式" AllowBlank="false" Mode="Local"
                                                                            FieldLabel="<font color='red'><b>进位方式</b></font>" Resizable="true">
                                                                            <Items>
                                                                                <ext:ListItem Value="KeepValue" Text="保留原值" />
                                                                                <ext:ListItem Value="Floor" Text="往下取整" />
                                                                                <ext:ListItem Value="Ceiling" Text="往上取整" />
                                                                                <ext:ListItem Value="Round" Text="四舍五入" />
                                                                            </Items>
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                                                                            </Triggers>
                                                                            <Listeners>
                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:Label ID="lbWdCarryType" runat="server" FieldLabel="" LabelSeparator="" Text="注释：赠品计算结果中的小数处理方式">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdAddLastLeft" runat="server" EmptyText="选择是否累计上期余量..." Width="160"
                                                                            Editable="false" TypeAhead="true" BlankText="选择是否累计上期余量" AllowBlank="false" Mode="Local"
                                                                            FieldLabel="<font color='red'><b>累计上期余量</b></font>" Resizable="true">
                                                                            <Items>
                                                                                <ext:ListItem Value="N" Text="否" />
                                                                                <ext:ListItem Value="Y" Text="是" />
                                                                            </Items>
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                                                                            </Triggers>
                                                                            <Listeners>
                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:Label ID="lvWdRemarkAddLastLeft" runat="server" FieldLabel="" LabelSeparator=""
                                                                            Text="注释：本期计算基数中是否要累计上期未使用余量">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdPolicyClass" runat="server" EmptyText="选择政策类型..." Width="160"
                                                                            AllowBlank="true" Editable="false" TypeAhead="true" BlankText="选择政策类型" Mode="Local"
                                                                            Hidden="true" FieldLabel="政策类型" Resizable="true">
                                                                            <Items>
                                                                                <ext:ListItem Value="价格补偿" Text="价格补偿" />
                                                                                <ext:ListItem Value="产品促销" Text="产品促销" />
                                                                            </Items>
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                            </Triggers>
                                                                            <Listeners>
                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:NumberField ID="numbMJRatio" runat="server" Width="160" FieldLabel="买减折价率" Hidden="true">
                                                                        </ext:NumberField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <%--   <ext:Checkbox ID="CheckboxYTDOption" runat="server" FieldLabel="" LabelSeparator=""
                                                                            BoxLabel="YTD奖励追溯">
                                                                        </ext:Checkbox>--%>
                                                                        <ext:ComboBox ID="cbYTDOption" runat="server" EmptyText="选择YTD奖励追溯..." Width="160"
                                                                            Editable="false" TypeAhead="true" BlankText="选择YTD奖励追溯" Mode="Local" FieldLabel="YTD奖励追溯"
                                                                            Resizable="true">
                                                                            <Items>
                                                                                <ext:ListItem Value="N" Text="无" />
                                                                                <ext:ListItem Value="YTD" Text="满足年度指标开始奖励(年度指标设置在第一帐期)" />
                                                                                <ext:ListItem Value="YTDRTN" Text="满足当前帐期指标即奖励，满足YTD指标补历史奖励" />
                                                                            </Items>
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                                                                            </Triggers>
                                                                            <Listeners>
                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:Checkbox ID="CheckboxUseProductForLP" runat="server" FieldLabel="" LabelSeparator=""
                                                                            HideLabel="true" BoxLabel="平台积分可用于全产品">
                                                                        </ext:Checkbox>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:FormPanel>
                                        <ext:FormPanel ID="FormPanelHard2" runat="server" Border="false" FormGroup="true">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout5" runat="server" Split="false">
                                                    <ext:LayoutColumn ColumnWidth="0.4">
                                                        <ext:Panel ID="Panel9" runat="server" Border="false" FormGroup="true">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout10" runat="server" LabelAlign="Left">
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdPointValidDateTypeForLP" runat="server" EmptyText="选择平台积分有效期类型..."
                                                                            Width="160" Editable="false" TypeAhead="true" BlankText="选择平台积分有效期类型" AllowBlank="false"
                                                                            Mode="Local" FieldLabel="<font color='red'><b>平台积分效期</b></font>" Resizable="true">
                                                                            <Items>
                                                                                <ext:ListItem Value="Always" Text="始终有效" />
                                                                                <ext:ListItem Value="AccountMonth" Text="账期延展" />
                                                                                <ext:ListItem Value="AbsoluteDate" Text="固定日期" />
                                                                            </Items>
                                                                            <Listeners>
                                                                                <Select Handler="#{cbWdPointValidDateDurationForLP}.clearValue(); #{dfWdPointValidDateAbsoluteForLP}.setValue(''); 
                                                                                if(#{cbWdPointValidDateTypeForLP}.getValue()=='AbsoluteDate') 
                                                                                {  #{cbWdPointValidDateDurationForLP}.setVisible(false); #{dfWdPointValidDateAbsoluteForLP}.setVisible(true);}
                                                                                else if(#{cbWdPointValidDateTypeForLP}.getValue()=='AccountMonth') 
                                                                                {  #{cbWdPointValidDateDurationForLP}.setVisible(true);#{dfWdPointValidDateAbsoluteForLP}.setVisible(false);} 
                                                                                else {   #{cbWdPointValidDateDurationForLP}.setVisible(false);#{dfWdPointValidDateAbsoluteForLP}.setVisible(false);}" />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                        <ext:Panel ID="Panel10" runat="server" Border="false" FormGroup="true">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout11" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdPointValidDateDurationForLP" runat="server" EmptyText="选择积分有效期基准时间跨度-平台..."
                                                                            Width="160" Editable="false" TypeAhead="true" BlankText="选择积分有效期基准时间跨度-平台" Mode="Local"
                                                                            FieldLabel="<font color='red'><b>跨度-平台</b></font>" Resizable="true">
                                                                            <Items>
                                                                                <ext:ListItem Value="1" Text="1个月" />
                                                                                <ext:ListItem Value="2" Text="2个月" />
                                                                                <ext:ListItem Value="3" Text="3个月" />
                                                                                <ext:ListItem Value="4" Text="4个月" />
                                                                                <ext:ListItem Value="5" Text="5个月" />
                                                                                <ext:ListItem Value="6" Text="6个月" />
                                                                                <ext:ListItem Value="7" Text="7个月" />
                                                                                <ext:ListItem Value="8" Text="8个月" />
                                                                                <ext:ListItem Value="9" Text="9个月" />
                                                                                <ext:ListItem Value="10" Text="10个月" />
                                                                                <ext:ListItem Value="11" Text="11个月" />
                                                                                <ext:ListItem Value="12" Text="12个月" />
                                                                            </Items>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:DateField ID="dfWdPointValidDateAbsoluteForLP" runat="server" Width="160" FieldLabel="<font color='red'><b>日期-平台</b></font>"
                                                                            EmptyText="积分有效期统一日期-平台" BlankText="积分有效期统一日期-平台" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:FormPanel>
                                        <ext:FormPanel ID="FormPanelHard3" runat="server" Border="false" FormGroup="true">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout6" runat="server" Split="false">
                                                    <ext:LayoutColumn ColumnWidth="0.4">
                                                        <ext:Panel ID="Panel13" runat="server" Border="false" FormGroup="true">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout12" runat="server" LabelAlign="Left">
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdPointValidDateType" runat="server" EmptyText="选择非平台积分有效期类型..."
                                                                            Width="160" Editable="false" TypeAhead="true" BlankText="选择非平台积分有效期类型" AllowBlank="false"
                                                                            Mode="Local" FieldLabel="<font color='red'><b>一/二级积分效期</b></font>" Resizable="true">
                                                                            <Items>
                                                                                <ext:ListItem Value="Always" Text="始终有效" />
                                                                                <ext:ListItem Value="AccountMonth" Text="账期延展" />
                                                                                <ext:ListItem Value="AbsoluteDate" Text="固定日期" />
                                                                            </Items>
                                                                            <Listeners>
                                                                                <Select Handler="#{cbWdPointValidDateDuration}.clearValue(); #{dfWdPointValidDateAbsolute}.setValue(''); 
                                                                                if(#{cbWdPointValidDateType}.getValue()=='AbsoluteDate') 
                                                                                {  #{cbWdPointValidDateDuration}.setVisible(false); #{dfWdPointValidDateAbsolute}.setVisible(true);}
                                                                                else if(#{cbWdPointValidDateType}.getValue()=='AccountMonth') 
                                                                                {  #{cbWdPointValidDateDuration}.setVisible(true);#{dfWdPointValidDateAbsolute}.setVisible(false);} 
                                                                                else {   #{cbWdPointValidDateDuration}.setVisible(false);#{dfWdPointValidDateAbsolute}.setVisible(false);}" />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                        <ext:Panel ID="Panel14" runat="server" Border="false" FormGroup="true">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout13" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWdPointValidDateDuration" runat="server" EmptyText="选择积分有效期基准时间跨度..."
                                                                            Width="160" Editable="false" TypeAhead="true" BlankText="选择积分有效期基准时间跨度" Mode="Local"
                                                                            FieldLabel="<font color='red'><b>跨度</b></font>" Resizable="true">
                                                                            <Items>
                                                                                <ext:ListItem Value="1" Text="1个月" />
                                                                                <ext:ListItem Value="2" Text="2个月" />
                                                                                <ext:ListItem Value="3" Text="3个月" />
                                                                                <ext:ListItem Value="4" Text="4个月" />
                                                                                <ext:ListItem Value="5" Text="5个月" />
                                                                                <ext:ListItem Value="6" Text="6个月" />
                                                                                <ext:ListItem Value="7" Text="7个月" />
                                                                                <ext:ListItem Value="8" Text="8个月" />
                                                                                <ext:ListItem Value="9" Text="9个月" />
                                                                                <ext:ListItem Value="10" Text="10个月" />
                                                                                <ext:ListItem Value="11" Text="11个月" />
                                                                                <ext:ListItem Value="12" Text="12个月" />
                                                                            </Items>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:DateField ID="dfWdPointValidDateAbsolute" runat="server" Width="160" FieldLabel="<font color='red'><b>日期</b></font>"
                                                                            EmptyText="积分有效期统一日期" BlankText="积分有效期统一日期" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:FormPanel>
                                    </Body>
                                </ext:FormPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Tab>
                    <ext:Tab ID="Tab1" runat="server" Title="政策因素" AutoScroll="true">
                        <%-- 政策因素--%>
                        <AutoLoad Mode="IFrame" MaskMsg="加载中……" ShowMask="true" Scripts="true" Url="~/Pages/Promotion/PolicyFactorInfo.aspx" />
                        <Listeners>
                            <Activate Handler="SetPageActivateUrl(); if (reloadFlag||reloadFlag2) {reloadFlag = false;reloadFlag2=false; this.reload();}" />
                        </Listeners>
                    </ext:Tab>
                    <ext:Tab ID="Tab2" runat="server" Title="促销规则" AutoScroll="true">
                        <%-- 促销规则设置--%>
                        <Body>
                            <ext:FitLayout ID="FitLayout6" runat="server">
                                <ext:GridPanel ID="GridFactorRule" runat="server" StoreID="FactorRuleStore" Border="false"
                                    Icon="Lorry" StripeRows="true">
                                    <TopBar>
                                        <ext:Toolbar ID="Toolbar2" runat="server">
                                            <Items>
                                                <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                                <ext:Button ID="btnAddFactorRule" runat="server" Text="新增规则" Icon="Add">
                                                    <Listeners>
                                                        <Click Handler="Coolite.AjaxMethods.PromotionPolicyRuleSet.Show(#{hidInstanceId}.getValue(''),'',#{hidPageType}.getValue(''),#{hidPromotionState}.getValue(''),#{hidPolicyStyle}.getValue(''),#{hidPolicyStyleSub}.getValue(''),{success:function(){RefreshDetailWindow4();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Items>
                                        </ext:Toolbar>
                                    </TopBar>
                                    <ColumnModel ID="ColumnModel2" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="RuleDesc" DataIndex="RuleDesc" Align="Left" Header="描述" Width="500">
                                            </ext:Column>
                                            <ext:CommandColumn Width="50" Header="编辑" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="编辑" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                            <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                        <ToolTip Text="删除" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <Listeners>
                                        <Command Handler="if (command == 'Edit'){
                                                              Coolite.AjaxMethods.PromotionPolicyRuleSet.Show(#{hidInstanceId}.getValue(''),record.data.RuleId,#{hidPageType}.getValue(''),#{hidPromotionState}.getValue(''),#{hidPolicyStyle}.getValue(''),#{hidPolicyStyleSub}.getValue(''),{success:function(){RefreshDetailWindow4();},failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                                  } 
                                                                                  if (command == 'Delete'){
                                                                 Ext.Msg.confirm('警告', '是否要删除该规则?',function(e) { 
                                                                                    if (e == 'yes') {
                                                                                         Coolite.AjaxMethods.PromotionPolicyDialog.DeletePolicyRule(record.data.RuleId,{success: function() {  #{GridFactorRule}.reload(); },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                        }
                                                                                     });                     
                                                                                  } 
                                                                                                      
                                                                                                         " />
                                    </Listeners>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBarFactorRule" runat="server" PageSize="10" StoreID="FactorRuleStore"
                                            DisplayInfo="true" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                        <Listeners>
                            <Activate Handler="SetRulePageActivate();" />
                        </Listeners>
                    </ext:Tab>
                    <ext:Tab ID="Tab3" runat="server" Title="附件" AutoScroll="true">
                        <%-- 附件管理--%>
                        <Body>
                            <ext:FitLayout ID="FitLayout5" runat="server">
                                <ext:GridPanel ID="GpWdAttachment" runat="server" StoreID="AttachmentStore" Border="false"
                                    Icon="Lorry">
                                    <TopBar>
                                        <ext:Toolbar ID="Toolbar4" runat="server">
                                            <Items>
                                                <ext:ToolbarFill ID="ToolbarFill4" runat="server" />
                                                <ext:Button ID="btnPolicyAttachmentAdd" runat="server" Text="新增附件" Icon="Add">
                                                    <Listeners>
                                                        <Click Handler="Coolite.AjaxMethods.PromotionPolicyDialog.AttachmentShow();" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Items>
                                        </ext:Toolbar>
                                    </TopBar>
                                    <ColumnModel ID="ColumnModel5" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="Name" DataIndex="Name" Width="200" Header="附件名称">
                                            </ext:Column>
                                            <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Width="90" Header="上传人">
                                            </ext:Column>
                                            <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Width="90" Header="上传时间">
                                            </ext:Column>
                                            <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                        <ToolTip Text="下载" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                            <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                        <ToolTip Text="删除" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel5" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <Listeners>
                                        <Command Handler="if (command == 'Delete'){
                                                                        Ext.Msg.confirm('警告', '是否要删除该文件?',
                                                                            function(e) {
                                                                                if (e == 'yes') {
                                                                                    Coolite.AjaxMethods.PromotionPolicyDialog.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                        success: function() {
                                                                                            #{GpWdAttachment}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                }
                                                                            });
                                                                         }if (command == 'DownLoad'){
                                                                                    var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=Promotion';
                                                                                    open(url, 'Download');
                                                                                  }  " />
                                    </Listeners>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBarAttachment" runat="server" PageSize="15" StoreID="AttachmentStore"
                                            DisplayInfo="true" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                        <Listeners>
                            <Activate Handler="SetAttachmentPageActivate();" />
                        </Listeners>
                    </ext:Tab>
                </Tabs>
            </ext:TabPanel>
        </ext:FitLayout>
    </Body>
    <Buttons>
        <ext:Button ID="btnSaveDraft" runat="server" Text="保存草稿" Icon="Add">
            <Listeners>
                <Click Handler="Coolite.AjaxMethods.PromotionPolicyDialog.SaveDraft({success:function(result){ if(result=='') { #{PolicyDetailWindow}.hide();RefreshMainPage();} else{ Ext.Msg.alert('Error', result);} },failure:function(err){Ext.Msg.alert('Error', err);}});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnDeleteDraft" runat="server" Text="删除草稿" Icon="Delete">
            <Listeners>
                <Click Handler="
                    Ext.Msg.confirm('Message', '确定要执行此操作？',
                                function(e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.PromotionPolicyDialog.DeleteDraft({success:function(){#{PolicyDetailWindow}.hide();RefreshMainPage();},failure:function(err){Ext.Msg.alert('Error', err);}});
                                        }});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnSubmit" runat="server" Text="提交" Icon="LorryAdd">
            <Listeners>
                <Click Handler="ValidateForm();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnCopy" runat="server" Text="拷贝" Icon="PageCopy">
            <Listeners>
                <Click Handler="Ext.Msg.confirm('Message', odwMsgList.msg1,
                                function(e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.PromotionPolicyDialog.Copy({success:function(){#{PolicyDetailWindow}.hide();RefreshMainPage();Ext.Msg.alert('Message',odwMsgList.msg2);},failure:function(err){Ext.Msg.alert('Error', err);}});
                                        }});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnRevoke" runat="server" Text="撤销" Icon="Decline">
        </ext:Button>
        <ext:Button ID="btnClose" runat="server" Text="关闭" Icon="LorryAdd">
            <Listeners>
                <Click Handler="Ext.Msg.confirm('Message', odwMsgList.msg5,
                                function(e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.PromotionPolicyDialog.Close({success:function(){#{PolicyDetailWindow}.hide();RefreshMainPage();Ext.Msg.alert('Message',odwMsgList.msg4);},failure:function(err){Ext.Msg.alert('Error', err);}});
                                        }});" />
            </Listeners>
        </ext:Button>
    </Buttons>
    <Listeners>
        <BeforeHide Handler="return NeedSave();" />
    </Listeners>
</ext:Window>
<ext:Hidden ID="hidWd6PolicyId" runat="server">
</ext:Hidden>
<ext:Store ID="PolicyTopValueStore" runat="server" OnRefreshData="PolicyTopValueStoreStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="SAPCode" />
                <ext:RecordField Name="DealerName" />
                <ext:RecordField Name="HospitalCode" />
                <ext:RecordField Name="HospitalName" />
                <ext:RecordField Name="Period" />
                <ext:RecordField Name="TopValue" />
                <ext:RecordField Name="ErrMsg" />
                <ext:RecordField Name="ISErr" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Window ID="wd6PolicyTopValue" runat="server" Icon="Group" Title="政策赠送封顶值导入"
    Hidden="true" Resizable="false" Header="false" Width="700" AutoHeight="true"
    AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:FormLayout ID="FormLayout20" runat="server">
            <ext:Anchor>
                <ext:FormPanel ID="BasicForm" runat="server" Frame="true" Header="false" AutoHeight="true"
                    MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                    <Defaults>
                        <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                    </Defaults>
                    <Body>
                        <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="50">
                            <ext:Anchor>
                                <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="选择封顶值" FieldLabel="文件"
                                    Width="500" ButtonText="" Icon="ImageAdd">
                                </ext:FileUploadField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Listeners>
                        <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
                    </Listeners>
                    <Buttons>
                        <ext:Button ID="SaveButton" runat="server" Text="上传封顶值">
                            <AjaxEvents>
                                <Click OnEvent="UploadClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传封顶值...', '封顶值上传');" Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });" Success="#{PagingToolBar3}.changePage(1);#{FileUploadField1}.setValue(''); Ext.Msg.show({ 
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
                                <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="ButtonTopValueDownLoad" runat="server" Text="下载模板">
                            <Listeners>
                                <Click Handler="window.open('../../Upload/ExcelTemplate/Template_PromotionTopValueInit.xls')" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Panel ID="PanelWd6AddTopValue" runat="server" BodyBorder="false" Header="false"
                    FormGroup="true">
                    <Body>
                        <ext:FitLayout ID="FitLayout4" runat="server">
                            <ext:GridPanel ID="GridWd6RuleDetail" runat="server" StoreID="PolicyTopValueStore"
                                Border="false" Title="封顶值" Icon="Lorry" StripeRows="true" Height="300" AutoScroll="true">
                                <ColumnModel ID="ColumnModel3" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="SAPCode" DataIndex="SAPCode" Align="Left" Header="经销商Code"
                                            Width="80">
                                        </ext:Column>
                                        <ext:Column ColumnID="DealerName" DataIndex="DealerName" Align="Left" Header="经销商名称"
                                            Width="150">
                                        </ext:Column>
                                        <ext:Column ColumnID="HospitalCode" DataIndex="HospitalCode" Align="Left" Header="医院Code"
                                            Width="80">
                                        </ext:Column>
                                        <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Align="Left" Header="医院名称"
                                            Width="150">
                                        </ext:Column>
                                        <ext:Column ColumnID="Period" DataIndex="Period" Align="Left" Header="期间" Width="80">
                                        </ext:Column>
                                        <ext:Column ColumnID="TopValue" DataIndex="TopValue" Align="Left" Header="封顶值" Width="80">
                                        </ext:Column>
                                        <ext:Column ColumnID="ErrMsg" DataIndex="ErrMsg" Align="Left" Header="错误信息" Width="200">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <View>
                                    <ext:GridView ID="GridView1" runat="server">
                                        <GetRowClass Fn="getIsErrRowClass" />
                                    </ext:GridView>
                                </View>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                    </ext:RowSelectionModel>
                                </SelectionModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="10" StoreID="PolicyTopValueStore"
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
        <ext:Button ID="btnPolicyTopValueCancel" runat="server" Text="关闭" Icon="LorryAdd">
            <Listeners>
                <Click Handler="#{wd6PolicyTopValue}.hide(null);" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
<ext:Window ID="wdAttachment" runat="server" Icon="Group" Title="上传附件" Resizable="false"
    Header="false" Width="500" Height="150" AutoShow="false" Modal="true" ShowOnLoad="false"
    BodyStyle="padding:5px;">
    <Body>
        <ext:FormPanel ID="AttachmentForm" runat="server" Width="500" Frame="true" Header="false"
            AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
            <Defaults>
                <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
            </Defaults>
            <Body>
                <ext:FormLayout ID="FormLayout24" runat="server" LabelWidth="120">
                    <ext:Anchor>
                        <ext:FileUploadField ID="ufUploadAttachment" runat="server" EmptyText="选择上传附件" FieldLabel="文件"
                            ButtonText="" Icon="ImageAdd">
                        </ext:FileUploadField>
                    </ext:Anchor>
                </ext:FormLayout>
            </Body>
            <Listeners>
                <ClientValidation Handler="#{btnWinAttachmentSubmit}.setDisabled(!valid);" />
            </Listeners>
            <Buttons>
                <ext:Button ID="btnWinAttachmentSubmit" runat="server" Text="上传附件">
                    <AjaxEvents>
                        <Click OnEvent="UploadAttachmentClick" Before="if(!#{AttachmentForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传附件...', '附件上传');" Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });" Success="#{GpWdAttachment}.reload();#{ufUploadAttachment}.setValue('')">
                        </Click>
                    </AjaxEvents>
                </ext:Button>
                <ext:Button ID="Button1" runat="server" Text="清除">
                    <Listeners>
                        <Click Handler="#{AttachmentForm}.getForm().reset();#{btnWinAttachmentSubmit}.setDisabled(true);" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:FormPanel>
    </Body>
    <Listeners>
        <BeforeShow Handler="#{ufUploadAttachment}.setValue('');" />
    </Listeners>
</ext:Window>
<ext:Store ID="PointRatioStore" runat="server" OnRefreshData="PointRatioStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="SAPCode" />
                <ext:RecordField Name="DealerName" />
                <ext:RecordField Name="DealerType" />
                <ext:RecordField Name="AccountMonth" />
                <ext:RecordField Name="Ratio" />
                <ext:RecordField Name="ErrMsg" />
                <ext:RecordField Name="ISErr" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Window ID="wdPolicyPointRatio" runat="server" Icon="Group" Title="本政策二级到平台积分加价率维护"
    Hidden="true" Resizable="false" Header="false" Width="700" AutoHeight="true"
    AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:FormLayout ID="FormLayout16" runat="server">
            <ext:Anchor>
                <ext:FormPanel ID="FormPanelPointRatio" runat="server" Frame="true" Header="false"
                    AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                    <Defaults>
                        <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                    </Defaults>
                    <Body>
                        <ext:FormLayout ID="FormLayout17" runat="server" LabelWidth="50">
                            <ext:Anchor>
                                <ext:FileUploadField ID="FileUploadFieldPointRatio" runat="server" EmptyText="选择加价率文件"
                                    FieldLabel="文件" Width="500" ButtonText="" Icon="ImageAdd">
                                </ext:FileUploadField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Listeners>
                        <ClientValidation Handler="#{SaveButtonPointRatio}.setDisabled(!valid);" />
                    </Listeners>
                    <Buttons>
                        <ext:Button ID="SaveButtonPointRatio" runat="server" Text="上传加价率">
                            <AjaxEvents>
                                <Click OnEvent="PointRatioUploadClick" Before="if(!#{FormPanelPointRatio}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传加价率...', '加价率上传');" Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });" Success="#{PagingToolBar1}.changePage(1);#{FileUploadFieldPointRatio}.setValue(''); Ext.Msg.show({ 
                                        title   : '成功', 
                                        msg     : '上传成功', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        buttons : Ext.Msg.OK 
                                    })">
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                        <ext:Button ID="Button3" runat="server" Text="清除">
                            <Listeners>
                                <Click Handler="#{FormPanelPointRatio}.getForm().reset();#{SaveButtonPointRatio}.setDisabled(true);" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="Button4" runat="server" Text="下载模板">
                            <Listeners>
                                <Click Handler="window.open('../../Upload/ExcelTemplate/Template_PromotionPointRatio.xls')" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Panel ID="Panel17" runat="server" BodyBorder="false" Header="false" FormGroup="true">
                    <Body>
                        <ext:FitLayout ID="FitLayout2" runat="server">
                            <ext:GridPanel ID="GridPanelPointRatio" runat="server" StoreID="PointRatioStore"
                                Border="false" Title="加价率" Icon="Lorry" StripeRows="true" Height="300" AutoScroll="true">
                                <ColumnModel ID="ColumnModel1" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="SAPCode" DataIndex="SAPCode" Align="Left" Header="经销商Code"
                                            Width="80">
                                        </ext:Column>
                                        <ext:Column ColumnID="DealerName" DataIndex="DealerName" Align="Left" Header="经销商名称"
                                            Width="150">
                                        </ext:Column>
                                        <ext:Column ColumnID="DealerType" DataIndex="DealerType" Align="Left" Header="经销商类型"
                                            Width="80">
                                        </ext:Column>
                                        <ext:Column ColumnID="AccountMonth" DataIndex="AccountMonth" Align="Left" Header="账期"
                                            Width="80">
                                        </ext:Column>
                                        <ext:Column ColumnID="Ratio" DataIndex="Ratio" Align="Left" Header="加价率" Width="80">
                                        </ext:Column>
                                        <ext:Column ColumnID="ErrMsg" DataIndex="ErrMsg" Align="Left" Header="错误信息" Width="200">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <View>
                                    <ext:GridView ID="GridView2" runat="server">
                                        <GetRowClass Fn="getIsErrRowClass" />
                                    </ext:GridView>
                                </View>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server">
                                    </ext:RowSelectionModel>
                                </SelectionModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="10" StoreID="PointRatioStore"
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
        <ext:Button ID="Button5" runat="server" Text="关闭" Icon="LorryAdd">
            <Listeners>
                <Click Handler="#{wdPolicyPointRatio}.hide(null);" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
