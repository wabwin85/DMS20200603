<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DealerComplainCRMEdit.ascx.cs"
    Inherits="DMS.Website.Controls.DealerComplainCRMEdit" %>
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
    var msgCRMList = {
        msg1:"<%=GetLocalResourceObject("CheckSubmit.confirm").ToString()%>",
        msg2:"<%=GetLocalResourceObject("CheckSubmit.success").ToString()%>"
    }
    
    var CloseCRMWindow = function() {
        Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
        //RefreshMainPage();
    }
    
    var SetCRMSubmit = function(b) {
        if (b) {
            Ext.getCmp('<%=this.SubmitButton.ClientID%>').show();
        } else {
            Ext.getCmp('<%=this.SubmitButton.ClientID%>').hide();
        }
    }
    
    var SetCRMCancel = function(b) {
        if (b) {
            Ext.getCmp('<%=this.CancelButton.ClientID%>').show();
        } else {
            Ext.getCmp('<%=this.CancelButton.ClientID%>').hide();
        }
    }
    
    var SetCRMDelivered = function(b) {
        
        if (b) {
            Ext.getCmp('<%=this.DeliverToCRMButton.ClientID%>').show();
        } else {
            Ext.getCmp('<%=this.DeliverToCRMButton.ClientID%>').hide();
        }
    }
    
     var SetCRMConfirmed = function(b) {
        
        if (b) {
            Ext.getCmp('<%=this.ConfirmCRMButton.ClientID%>').show();
        } else {
            Ext.getCmp('<%=this.ConfirmCRMButton.ClientID%>').hide();
        }
    }
    
    var SetCRMConfirm = function(b) {
        if (b) {
            Ext.getCmp('<%=this.ConfirmCRMButton.ClientID%>').show();
        } else {
            Ext.getCmp('<%=this.ConfirmCRMButton.ClientID%>').hide();
        }
    }
    
    
    var isRemainsServiceChheck = function(isRemainsService) { 
      if (isRemainsService){
        Ext.getCmp('<%=this.RemovedService_1.ClientID%>').setValue(false);
        Ext.getCmp('<%=this.RemovedService_2.ClientID%>').setValue(false);
        Ext.getCmp('<%=this.RemovedService_3.ClientID%>').setValue(false);
        Ext.getCmp('<%=this.RemovedService_4.ClientID%>').setValue(false);
        
      } else {
        Ext.getCmp('<%=this.RemainsService_1.ClientID%>').setValue(false);
        Ext.getCmp('<%=this.RemainsService_2.ClientID%>').setValue(false);
        Ext.getCmp('<%=this.RemainsService_3.ClientID%>').setValue(false);
        Ext.getCmp('<%=this.RemainsService_4.ClientID%>').setValue(false);
        Ext.getCmp('<%=this.RemainsService_5.ClientID%>').setValue(false);
               
      }
    }
    
    var iCRMCheck = true;   
    function CheckCRMField(i) {        
        if (i.items!=null){
            i.items.each(
            function(item,index,length){                                
                if (item.xtype == 'textfield' || item.xtype == "numberfield" || item.xtype == 'datefield' || item.xtype == 'coolitetriggercombo') {
                    if (iCRMCheck && !item.isValid()) {
                        iCRMCheck = false;                        
                        item.focus();
                        return false;
                    }
                } 
                else if (item.xtype == 'checkboxgroup' || item.xtype == 'radiogroup') {
                    if (iCRMCheck) {
                         var checkboxgroupChk = false
                         for (var i = 0; i < item.items.length; i++)    
                         {    
                            if (item.items.itemAt(i).checked)    
                            {    
                               checkboxgroupChk = true;                                             
                            }                         
                         }                         
                         if (!checkboxgroupChk && item.id != Ext.getCmp('<%=this.Witnessed.ClientID%>').id && 
                                                  item.id != Ext.getCmp('<%=this.RelatedBSC.ClientID%>').id && 
                                                  item.id != Ext.getCmp('<%=this.Leads1Position.ClientID%>').id && 
                                                  item.id != Ext.getCmp('<%=this.Leads2Position.ClientID%>').id && 
                                                  item.id != Ext.getCmp('<%=this.Leads3Position.ClientID%>').id && 
                                                  item.id != Ext.getCmp('<%=this.RemainsService.ClientID%>').id && 
                                                  item.id != Ext.getCmp('<%=this.RemovedService.ClientID%>').id &&
                                                  item.id != Ext.getCmp('<%=this.Pulse.ClientID%>').id &&
                                                  item.id != Ext.getCmp('<%=this.Leads.ClientID%>').id &&
                                                  item.id != Ext.getCmp('<%=this.Clinical.ClientID%>').id){
                           item.focus();
                           alert(item.blankText);
                           iCRMCheck = false;
                           return false;
                         }   
                     }                 
                } 
                
                else {
                   
                    CheckCRMField(item);
                }
            });
        }        
    }
    
    
    function CheckCRMFieldSpecial() {        
       //病人信息要么填写，要么选择不能获取
       if ( (Ext.getCmp('<%=this.PatientSex.ClientID%>').getValue() == null || Ext.getCmp('<%=this.PatientSex.ClientID%>').getValue() == '') && !Ext.getCmp('<%=this.PatientSexInvalid.ClientID%>').checked ){
         alert("请填写患者性别或选择不能获取");
         Ext.getCmp('<%=this.PatientSex.ClientID%>').focus();
         iCRMCheck = false;
         return false;
       }
       
       if ( (Ext.getCmp('<%=this.PatientBirth.ClientID%>').getValue() == null || Ext.getCmp('<%=this.PatientBirth.ClientID%>').getValue() == '') && !Ext.getCmp('<%=this.PatientBirthInvalid.ClientID%>').checked ){
         alert("请填写患者出生年月日或选择不能获取");
         Ext.getCmp('<%=this.PatientBirth.ClientID%>').focus();
         iCRMCheck = false;
         return false;
       }
       
       if ( (Ext.getCmp('<%=this.PatientWeight.ClientID%>').getValue() == null || Ext.getCmp('<%=this.PatientWeight.ClientID%>').getValue() == '') && !Ext.getCmp('<%=this.PatientWeightInvalid.ClientID%>').checked ){
         alert("请填写患者体重或选择不能获取");
         Ext.getCmp('<%=this.PatientWeight.ClientID%>').focus();
         iCRMCheck = false;
         return false;
       }       
       
       //如果选择了死亡，则下面的内容是必填的
        if (Ext.getCmp('<%=this.PatientStatus_6.ClientID%>').checked){
          if(Ext.getCmp('<%=this.DeathDate.ClientID%>').getValue() == null || Ext.getCmp('<%=this.DeathDate.ClientID%>').getValue() == ''){
            alert("请选择死亡日期");
            Ext.getCmp('<%=this.DeathDate.ClientID%>').focus();
            iCRMCheck = false;
            return false;
          
          }
          
          if(Ext.getCmp('<%=this.DeathTime.ClientID%>').getValue() == null || Ext.getCmp('<%=this.DeathTime.ClientID%>').getValue() == ''){
            alert("请填写死亡时间");
            Ext.getCmp('<%=this.DeathTime.ClientID%>').focus();
            iCRMCheck = false;
            return false;
          
          }
          
          if(Ext.getCmp('<%=this.DeathCause.ClientID%>').getValue() == null || Ext.getCmp('<%=this.DeathCause.ClientID%>').getValue() == ''){
            alert("请填写死亡原因");
            Ext.getCmp('<%=this.DeathCause.ClientID%>').focus();
            iCRMCheck = false;
            return false;
          
          }
          
          if(!Ext.getCmp('<%=this.Witnessed_1.ClientID%>').checked  && !Ext.getCmp('<%=this.Witnessed_2.ClientID%>').checked){
            alert("请选择上报人是否在场");
            Ext.getCmp('<%=this.Witnessed_1.ClientID%>').focus();            
            iCRMCheck = false;
            return false;
          
          }
          
          if(!Ext.getCmp('<%=this.RelatedBSC_1.ClientID%>').checked  && !Ext.getCmp('<%=this.RelatedBSC_2.ClientID%>').checked && !Ext.getCmp('<%=this.RelatedBSC_3.ClientID%>').checked){
            alert("请选择是否怀疑该死亡与波科产品故障有关");
            Ext.getCmp('<%=this.RelatedBSC_1.ClientID%>').focus();            
            iCRMCheck = false;
            return false;          
          }
        }
       
       if (Ext.getCmp('<%=this.Returned_1.ClientID%>').checked){
          if(Ext.getCmp('<%=this.ReturnedDay.ClientID%>').getValue() == null || Ext.getCmp('<%=this.ReturnedDay.ClientID%>').getValue() == ''){
            alert("请填写需要多少天返回");
            Ext.getCmp('<%=this.ReturnedDay.ClientID%>').focus();
            iCRMCheck = false;
            return false;
          
          }
       }
       
       //校验
       if (Ext.getCmp('<%=this.Pulse_9.ClientID%>').checked){
          if(Ext.getCmp('<%=this.Pulsebeats.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Pulsebeats.ClientID%>').getValue() == ''){
            alert("请填写抑制起搏的跳数");
            Ext.getCmp('<%=this.Pulsebeats.ClientID%>').focus();
            iCRMCheck = false;
            return false;
          
          }
       }
       
       if (Ext.getCmp('<%=this.Leads_1.ClientID%>').checked){
          if(Ext.getCmp('<%=this.LeadsFracture.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsFracture.ClientID%>').getValue() == ''){
            alert("请填写电极导体断裂");
            Ext.getCmp('<%=this.LeadsFracture.ClientID%>').focus();
            iCRMCheck = false;
            return false;
          
          }
       }
       
       if (Ext.getCmp('<%=this.Leads_2.ClientID%>').checked){
          if(Ext.getCmp('<%=this.LeadsIssue.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsIssue.ClientID%>').getValue() == ''){
            alert("请填写绝缘层问题");
            Ext.getCmp('<%=this.LeadsIssue.ClientID%>').focus();
            iCRMCheck = false;
            return false;
          
          }
       }
       
        if (Ext.getCmp('<%=this.Leads_3.ClientID%>').checked){
          if(Ext.getCmp('<%=this.LeadsDislodgement.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsDislodgement.ClientID%>').getValue() == ''){
            alert("请填写电极脱位");
            Ext.getCmp('<%=this.LeadsDislodgement.ClientID%>').focus();
            iCRMCheck = false;
            return false;
          
          }
       }
       
       if (Ext.getCmp('<%=this.Leads_4.ClientID%>').checked){
          if(Ext.getCmp('<%=this.LeadsMeasurements.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsMeasurements.ClientID%>').getValue() == ''){
            alert("请填写阻抗测量值异常");
            Ext.getCmp('<%=this.LeadsMeasurements.ClientID%>').focus();
            iCRMCheck = false;
            return false;
          
          }
       }
       
       if (Ext.getCmp('<%=this.Leads_6.ClientID%>').checked){
          if(Ext.getCmp('<%=this.LeadsThresholds.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsThresholds.ClientID%>').getValue() == ''){
            alert("请填写起搏阈值过高");
            Ext.getCmp('<%=this.LeadsThresholds.ClientID%>').focus();
            iCRMCheck = false;
            return false;
          
          }
       }
       
       if (Ext.getCmp('<%=this.Leads_7.ClientID%>').checked){
          if(Ext.getCmp('<%=this.LeadsBeats.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsBeats.ClientID%>').getValue() == ''){
            alert("请填写抑制起搏的跳数");
            Ext.getCmp('<%=this.LeadsBeats.ClientID%>').focus();
            iCRMCheck = false;
            return false;
          
          }
       }
       if (Ext.getCmp('<%=this.Leads_8.ClientID%>').checked){
          if(Ext.getCmp('<%=this.LeadsNoise.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsNoise.ClientID%>').getValue() == ''){
            alert("请填写噪声");
            Ext.getCmp('<%=this.LeadsNoise.ClientID%>').focus();
            iCRMCheck = false;
            return false;
          
          }
       }
       
       if (Ext.getCmp('<%=this.Leads_9.ClientID%>').checked){
          if(Ext.getCmp('<%=this.LeadsLoss.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsLoss.ClientID%>').getValue() == ''){
            alert("请填写失夺获");
            Ext.getCmp('<%=this.LeadsLoss.ClientID%>').focus();
            iCRMCheck = false;
            return false;
          
          }
       }
       
        if (Ext.getCmp('<%=this.Clinical_1.ClientID%>').checked){
          if(Ext.getCmp('<%=this.ClinicalPerforation.ClientID%>').getValue() == null || Ext.getCmp('<%=this.ClinicalPerforation.ClientID%>').getValue() == ''){
            alert("请填写穿孔");
            Ext.getCmp('<%=this.ClinicalPerforation.ClientID%>').focus();
            iCRMCheck = false;
            return false;
          
          }
       }
       
        if (Ext.getCmp('<%=this.Clinical_3.ClientID%>').checked){
          if(Ext.getCmp('<%=this.ClinicalBeats.ClientID%>').getValue() == null || Ext.getCmp('<%=this.ClinicalBeats.ClientID%>').getValue() == ''){
            alert("请填写阻抗测量值异常");
            Ext.getCmp('<%=this.ClinicalBeats.ClientID%>').focus();
            iCRMCheck = false;
            return false;
          
          }
       }
       
       //校验临床观察中的3组多选框必须要选择一个       
       var clinicCheckboxgroupChk = false;
       for (var i = 0; i < Ext.getCmp('<%=this.Pulse.ClientID%>').items.length; i++)  {    
            if (Ext.getCmp('<%=this.Pulse.ClientID%>').items.itemAt(i).checked)    
            {    
               clinicCheckboxgroupChk = true;                                             
            }                         
       }   
       for (var i = 0; i < Ext.getCmp('<%=this.Leads.ClientID%>').items.length; i++)  {    
            if (Ext.getCmp('<%=this.Leads.ClientID%>').items.itemAt(i).checked)    
            {    
               clinicCheckboxgroupChk = true;                                             
            }                         
       }   
       for (var i = 0; i < Ext.getCmp('<%=this.Clinical.ClientID%>').items.length; i++)  {    
            if (Ext.getCmp('<%=this.Clinical.ClientID%>').items.itemAt(i).checked)    
            {    
               clinicCheckboxgroupChk = true;                                             
            }                         
       }                     
       if (!clinicCheckboxgroupChk ){
           Ext.getCmp('<%=this.Pulse_1.ClientID%>').focus();
           alert("【7. 临床观察】中的脉冲发生器/程控仪、电极/传送系统、临床3个选择项必须选择至少一项！");
           iCRMCheck = false;
           return false;
        }   
       
       
       //校验脉冲发生器、电极1、电极2、电极3、配件必须至少选择一个       
       if( (Ext.getCmp('<%=this.PulseModel.ClientID%>').getValue() == null || Ext.getCmp('<%=this.PulseModel.ClientID%>').getValue() == '')
        && (Ext.getCmp('<%=this.Leads1Model.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads1Model.ClientID%>').getValue() == '')
        && (Ext.getCmp('<%=this.Leads2Model.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads2Model.ClientID%>').getValue() == '')
        && (Ext.getCmp('<%=this.Leads3Model.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads3Model.ClientID%>').getValue() == '')
        && (Ext.getCmp('<%=this.AccessoryModel.ClientID%>').getValue() == null || Ext.getCmp('<%=this.AccessoryModel.ClientID%>').getValue() == '')){
         Ext.getCmp('<%=this.PulseModel.ClientID%>').focus();
         alert("校验脉冲发生器、电极1、电极2、电极3、配件必须至少填写一项");
         iCRMCheck = false;
         return false;
       }
       
       if (Ext.getCmp('<%=this.PulseModel.ClientID%>').getValue() != null && Ext.getCmp('<%=this.PulseModel.ClientID%>').getValue() != ''){         
         if ((Ext.getCmp('<%=this.PulseSerial.ClientID%>').getValue() == null || Ext.getCmp('<%=this.PulseSerial.ClientID%>').getValue() == '')
          || (Ext.getCmp('<%=this.PulseImplant.ClientID%>').getValue() == null || Ext.getCmp('<%=this.PulseImplant.ClientID%>').getValue() == '')){
            Ext.getCmp('<%=this.PulseModel.ClientID%>').focus();
            alert("脉冲发生器的Serial、植入时间也必须填写");
            iCRMCheck = false;
            return false;
            
         }
       }
       if (Ext.getCmp('<%=this.Leads1Model.ClientID%>').getValue() != null && Ext.getCmp('<%=this.Leads1Model.ClientID%>').getValue() != ''){        
         if ((Ext.getCmp('<%=this.Leads1Serial.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads1Serial.ClientID%>').getValue() == '')
          || (Ext.getCmp('<%=this.Leads1Implant.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads1Implant.ClientID%>').getValue() == '')){           
            Ext.getCmp('<%=this.Leads1Model.ClientID%>').focus();
            alert("电极1的Serial、植入时间也必须填写");
            iCRMCheck = false;
            return false;
            
         } else if (!Ext.getCmp('<%=this.Leads1Position_1.ClientID%>').checked && !Ext.getCmp('<%=this.Leads1Position_2.ClientID%>').checked && !Ext.getCmp('<%=this.Leads1Position_3.ClientID%>').checked && !Ext.getCmp('<%=this.Leads1Position_4.ClientID%>').checked  ) {
           
            Ext.getCmp('<%=this.Leads1Position_1.ClientID%>').focus();
            alert("电极1的电极位置必须选择");
            iCRMCheck = false;
            return false;
         }
       }
       if (Ext.getCmp('<%=this.Leads2Model.ClientID%>').getValue() != null && Ext.getCmp('<%=this.Leads2Model.ClientID%>').getValue() != ''){       
         if ((Ext.getCmp('<%=this.Leads2Serial.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads2Serial.ClientID%>').getValue() == '')
          || (Ext.getCmp('<%=this.Leads2Implant.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads2Implant.ClientID%>').getValue() == '')){
            Ext.getCmp('<%=this.Leads2Model.ClientID%>').focus();
            alert("电极2的Serial、植入时间也必须填写");
            iCRMCheck = false;
            return false;            
         } else if (!Ext.getCmp('<%=this.Leads2Position_1.ClientID%>').checked && !Ext.getCmp('<%=this.Leads2Position_2.ClientID%>').checked && !Ext.getCmp('<%=this.Leads2Position_3.ClientID%>').checked && !Ext.getCmp('<%=this.Leads2Position_4.ClientID%>').checked  ) {
           
            Ext.getCmp('<%=this.Leads2Position_1.ClientID%>').focus();
            alert("电极2的电极位置必须选择");
            iCRMCheck = false;
            return false;
         }
       }
       if (Ext.getCmp('<%=this.Leads3Model.ClientID%>').getValue() != null && Ext.getCmp('<%=this.Leads3Model.ClientID%>').getValue() != ''){        
         if ((Ext.getCmp('<%=this.Leads3Serial.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads3Serial.ClientID%>').getValue() == '')
          || (Ext.getCmp('<%=this.Leads3Implant.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads3Implant.ClientID%>').getValue() == '')){
            Ext.getCmp('<%=this.Leads3Model.ClientID%>').focus();
            alert("电极3的Serial、植入时间也必须填写");
            iCRMCheck = false;
            return false;
            
         } else if (!Ext.getCmp('<%=this.Leads3Position_1.ClientID%>').checked && !Ext.getCmp('<%=this.Leads3Position_2.ClientID%>').checked && !Ext.getCmp('<%=this.Leads3Position_3.ClientID%>').checked && !Ext.getCmp('<%=this.Leads3Position_4.ClientID%>').checked  ) {
           
            Ext.getCmp('<%=this.Leads3Position_1.ClientID%>').focus();
            alert("电极3的电极位置必须选择");
            iCRMCheck = false;
            return false;
         }
       }
       if (Ext.getCmp('<%=this.AccessoryModel.ClientID%>').getValue() != null && Ext.getCmp('<%=this.AccessoryModel.ClientID%>').getValue() != ''){       
         if ((Ext.getCmp('<%=this.AccessorySerial.ClientID%>').getValue() == null || Ext.getCmp('<%=this.AccessorySerial.ClientID%>').getValue() == '')
          || (Ext.getCmp('<%=this.AccessoryImplant.ClientID%>').getValue() == null || Ext.getCmp('<%=this.AccessoryImplant.ClientID%>').getValue() == '')){
            Ext.getCmp('<%=this.AccessoryModel.ClientID%>').focus();
            alert("配件的Serial、植入时间也必须填写");
            iCRMCheck = false;
            return false;
            
         }
       }
       
       //仍在服务中的选择项和产品已移除体内
       if (Ext.getCmp('<%=this.RemainsService_1.ClientID%>').checked 
        || Ext.getCmp('<%=this.RemainsService_2.ClientID%>').checked 
        || Ext.getCmp('<%=this.RemainsService_3.ClientID%>').checked 
        || Ext.getCmp('<%=this.RemainsService_4.ClientID%>').checked
        || Ext.getCmp('<%=this.RemainsService_5.ClientID%>').checked) {
          if (Ext.getCmp('<%=this.RemovedService_1.ClientID%>').checked ||
              Ext.getCmp('<%=this.RemovedService_2.ClientID%>').checked ||
              Ext.getCmp('<%=this.RemovedService_3.ClientID%>').checked ||
              Ext.getCmp('<%=this.RemovedService_4.ClientID%>').checked ) {
              
              Ext.getCmp('<%=this.RemainsService_1.ClientID%>').focus();
              alert("仍在服务中的选择项和产品已移除体内的选择项不能同时选择");
              iCRMCheck = false;
              return false;
          }   
       }
       
       //仍在服务中的选择项和产品已移除体内
       if (Ext.getCmp('<%=this.RemovedService_1.ClientID%>').checked ||
           Ext.getCmp('<%=this.RemovedService_2.ClientID%>').checked ||
           Ext.getCmp('<%=this.RemovedService_3.ClientID%>').checked ||
           Ext.getCmp('<%=this.RemovedService_4.ClientID%>').checked) {
          if ( Ext.getCmp('<%=this.RemainsService_1.ClientID%>').checked 
            || Ext.getCmp('<%=this.RemainsService_2.ClientID%>').checked 
            || Ext.getCmp('<%=this.RemainsService_3.ClientID%>').checked 
            || Ext.getCmp('<%=this.RemainsService_4.ClientID%>').checked
            || Ext.getCmp('<%=this.RemainsService_5.ClientID%>').checked) {
              
              Ext.getCmp('<%=this.RemainsService_1.ClientID%>').focus();
              alert("仍在服务中的选择项和产品已移除体内的选择项不能同时选择");
              iCRMCheck = false;
              return false;
          }   
       } 
       
       if (!Ext.getCmp('<%=this.RemovedService_1.ClientID%>').checked &&
           !Ext.getCmp('<%=this.RemovedService_2.ClientID%>').checked &&
           !Ext.getCmp('<%=this.RemovedService_3.ClientID%>').checked &&
           !Ext.getCmp('<%=this.RemovedService_4.ClientID%>').checked &&
           !Ext.getCmp('<%=this.RemainsService_1.ClientID%>').checked &&
           !Ext.getCmp('<%=this.RemainsService_2.ClientID%>').checked &&
           !Ext.getCmp('<%=this.RemainsService_3.ClientID%>').checked &&
           !Ext.getCmp('<%=this.RemainsService_4.ClientID%>').checked &&
           !Ext.getCmp('<%=this.RemainsService_5.ClientID%>').checked) {
              
              Ext.getCmp('<%=this.RemainsService_1.ClientID%>').focus();
              alert("仍在服务中的选择项和产品已移除体内的选择项至少要选择一项");
              iCRMCheck = false;
              return false;
       }   
       
       //表格第9部分需要填写
       if (Ext.getCmp('<%=this.ProductExpDetail.ClientID%>').getValue() == null || Ext.getCmp('<%=this.ProductExpDetail.ClientID%>').getValue() == ''){ 
          alert("请填写产品体验详细的时间描述或临床观察");
          Ext.getCmp('<%=this.ProductExpDetail.ClientID%>').focus();
          iCRMCheck = false;
          return false;
       }
               
    }
    
    var CancelCRMSubmit = function() {
        Ext.Msg.confirm('Message', msgCRMList.msg1,
            function(e) {
                if (e == 'yes') {
                    Coolite.AjaxMethods.DealerComplainCRMEdit.DoCancel(
                        {
                            success: function() {
                                Ext.Msg.alert('Message', msgCRMList.msg2);
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
    
    
     var ConfirmCRMSubmit = function() {
        Ext.Msg.confirm('Message', msgCRMList.msg1,
            function(e) {
                if (e == 'yes') {
                    Coolite.AjaxMethods.DealerComplainCRMEdit.DoConfirm(
                        {
                            success: function() {
                                Ext.Msg.alert('Message', msgCRMList.msg2);
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
    
    var CheckCRMSubmit = function() {
        iCRMCheck = true;
        CheckCRMField(<%=Panel1.ClientID%>);
        if (iCRMCheck) { 
          CheckCRMFieldSpecial();
        }  
        if (iCRMCheck) {
            var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
            Ext.Msg.confirm('Message', msgCRMList.msg1,
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.DealerComplainCRMEdit.DoSubmit(
                            {
                                success: function() {
                                    if (rtnVal.getValue() == "Success") {
                                        Ext.Msg.alert('Message', msgCRMList.msg2);
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
    
    var isDeathCheck = function() { 
      if (Ext.getCmp('<%=this.PatientStatus_6.ClientID%>').checked){
         Ext.getCmp('<%=this.DeathDate.ClientID%>').show();
         Ext.getCmp('<%=this.DeathTime.ClientID%>').show();
         Ext.getCmp('<%=this.DeathCause.ClientID%>').show();
         Ext.getCmp('<%=this.Witnessed.ClientID%>').show();
         Ext.getCmp('<%=this.RelatedBSC.ClientID%>').show();
         
        
      } else {
         Ext.getCmp('<%=this.DeathDate.ClientID%>').hide();
         Ext.getCmp('<%=this.DeathTime.ClientID%>').hide();
         Ext.getCmp('<%=this.DeathCause.ClientID%>').hide();
         Ext.getCmp('<%=this.Witnessed.ClientID%>').hide();
         Ext.getCmp('<%=this.RelatedBSC.ClientID%>').hide();
        
      }
    }
    
    var showTextBoxWhenChecked = function(checkType) { 
     
      if (checkType == 'Pulse_9'){
         if (Ext.getCmp('<%=this.Pulse_9.ClientID%>').checked){
           Ext.getCmp('<%=this.Pulsebeats.ClientID%>').show();
         } else {
           Ext.getCmp('<%=this.Pulsebeats.ClientID%>').hide();
         } 
      }
      else if (checkType == 'Leads_1'){
         if (Ext.getCmp('<%=this.Leads_1.ClientID%>').checked){
           Ext.getCmp('<%=this.LeadsFracture.ClientID%>').show();
         } else {
           Ext.getCmp('<%=this.LeadsFracture.ClientID%>').hide();
         } 
      }
      else if (checkType == 'Leads_2'){
         if (Ext.getCmp('<%=this.Leads_2.ClientID%>').checked){
           Ext.getCmp('<%=this.LeadsIssue.ClientID%>').show();
         } else {
           Ext.getCmp('<%=this.LeadsIssue.ClientID%>').hide();
         } 
      }
      else if (checkType == 'Leads_3'){
         if (Ext.getCmp('<%=this.Leads_3.ClientID%>').checked){
           Ext.getCmp('<%=this.LeadsDislodgement.ClientID%>').show();
         } else {
           Ext.getCmp('<%=this.LeadsDislodgement.ClientID%>').hide();
         } 
      }
      else if (checkType == 'Leads_4'){
         if (Ext.getCmp('<%=this.Leads_4.ClientID%>').checked){
           Ext.getCmp('<%=this.LeadsMeasurements.ClientID%>').show();
         } else {
           Ext.getCmp('<%=this.LeadsMeasurements.ClientID%>').hide();
         } 
      }
      else if (checkType == 'Leads_6'){
         if (Ext.getCmp('<%=this.Leads_6.ClientID%>').checked){
           Ext.getCmp('<%=this.LeadsThresholds.ClientID%>').show();
         } else {
           Ext.getCmp('<%=this.LeadsThresholds.ClientID%>').hide();
         } 
      }
      else if (checkType == 'Leads_7'){
         if (Ext.getCmp('<%=this.Leads_7.ClientID%>').checked){
           Ext.getCmp('<%=this.LeadsBeats.ClientID%>').show();
         } else {
           Ext.getCmp('<%=this.LeadsBeats.ClientID%>').hide();
         } 
      }
       else if (checkType == 'Leads_8'){
         if (Ext.getCmp('<%=this.Leads_8.ClientID%>').checked){
           Ext.getCmp('<%=this.LeadsNoise.ClientID%>').show();
         } else {
           Ext.getCmp('<%=this.LeadsNoise.ClientID%>').hide();
         } 
      }
       else if (checkType == 'Leads_9'){
         if (Ext.getCmp('<%=this.Leads_9.ClientID%>').checked){
           Ext.getCmp('<%=this.LeadsLoss.ClientID%>').show();
         } else {
           Ext.getCmp('<%=this.LeadsLoss.ClientID%>').hide();
         } 
      }
      else if (checkType == 'Clinical_1'){
         if (Ext.getCmp('<%=this.Clinical_1.ClientID%>').checked){
           Ext.getCmp('<%=this.ClinicalPerforation.ClientID%>').show();
         } else {
           Ext.getCmp('<%=this.ClinicalPerforation.ClientID%>').hide();
         } 
      }
      else if (checkType == 'Clinical_3'){
         if (Ext.getCmp('<%=this.Clinical_3.ClientID%>').checked){
           Ext.getCmp('<%=this.ClinicalBeats.ClientID%>').show();
         } else {
           Ext.getCmp('<%=this.ClinicalBeats.ClientID%>').hide();
         } 
      }
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

<ext:Hidden ID="hidInstanceId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnVal" runat="server">
</ext:Hidden>
<%--<ext:Store ID="StoreRETURNTYPE" runat="server" UseIdConfirmation="true">
    <Reader>
        <ext:JsonReader ReaderID="Key">
            <Fields>
                <ext:RecordField Name="Key" />
                <ext:RecordField Name="Value" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <SortInfo Field="Key" Direction="ASC" />
</ext:Store>--%>
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
        <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);" />
    </Listeners>
    <SortInfo Field="Name" Direction="ASC" />
</ext:Store>
<ext:Store ID="LotStore" runat="server" >
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
<ext:Store ID="UPNStore" runat="server" OnRefreshData="Store_AllUPNByLot" >
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
    Width="1360" Height="490" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false" CenterOnLoad="true" Y="5" AutoScroll="true">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:Panel ID="Panel6" runat="server" Header="false" Frame="false" BodyBorder="false"
                    AutoHeight="true">
                    <Body>
                        <div style="text-align: center; font-size: medium;">
                            <asp:Literal ID="Literal1" runat="server" Text="<%$ Resources: DetailWindow.Title%>" /></div>
                    </Body>
                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:Panel ID="Panel1" runat="server" Header="false" Frame="false" BodyBorder="false"
                    AutoHeight="true">
                    <Body>
                        <ext:RowLayout ID="RowLayout" runat="server">
                            <ext:LayoutRow>
                                <ext:FieldSet ID="FieldSet6" runat="server" Header="true" Frame="false" BodyBorder="false"
                                    AutoHeight="true" AutoWidth="true">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout18" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".33">
                                                <ext:Panel ID="Panel16" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout34" runat="server" LabelAlign="Left" LabelWidth="160">
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbLOT" runat="server" EmptyText="请选择产品批号" Width="200" Editable="true" Mode="Local"
                                                                    TypeAhead="false" StoreID="LotStore" ValueField="Id" DisplayField="Name" FieldLabel="<font color='red'>*</font>产品批号（SN）"
                                                                    ListWidth="300" Resizable="true" BlankText="请选择产品批号" AllowBlank="false" Cls="lightyellow-row"
                                                                    MsgTarget="Side">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="请选择产品批号" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                        <TriggerClick Handler="this.clearValue();#{UPNStore}.reload();#{cbUPN}.clearValue();" />
                                                                        <Select Handler="#{UPNStore}.reload();#{cbUPN}.clearValue();#{WarehouseStore}.reload();#{cbWarehouse}.clearValue();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="Model" runat="server" Width="180" FieldLabel="型号（Model#）"
                                                                    Cls="lightyellow-row" AllowBlank="false" BlankText="请填写产品型号" MsgTarget="Side" Enabled="false" noedit="TRUE"/>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="PI" runat="server" Width="180" FieldLabel="投诉号码(PI)" AllowBlank="true"
                                                                    BlankText="请填写产品投诉号码(PI)" MsgTarget="Side" Enabled="false" noedit="TRUE" />
                                                            </ext:Anchor>
                                                              <ext:Anchor>
                                                                <ext:TextField ID="txtQrCode" runat="server" Width="180" FieldLabel="二维码" AllowBlank="true"
                                                                    BlankText="二维码" MsgTarget="Side" Enabled="false" noedit="TRUE" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".33">
                                                <ext:Panel ID="Panel17" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout36" runat="server" LabelAlign="Left" LabelWidth="160">
                                                            <ext:Anchor>                                                              
                                                                <ext:ComboBox ID="cbUPN" runat="server" EmptyText="请选择产品型号" Width="200" Editable="true"
                                                                    TypeAhead="false" StoreID="UPNStore" ValueField="Id" DisplayField="Name" FieldLabel="<font color='red'>*</font>产品型号(UPN)"
                                                                    ListWidth="300" Resizable="true" BlankText="请选择产品型号" AllowBlank="false" Cls="lightyellow-row"
                                                                    MsgTarget="Side">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="请选择产品序列号" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                        <TriggerClick Handler="this.clearValue();#{WarehouseStore}.reload();#{cbWarehouse}.clearValue();" />
                                                                        <Select Handler="Coolite.AjaxMethods.DealerComplainCRMEdit.AuotCompleteUPNInfo();#{WarehouseStore}.reload();#{cbWarehouse}.clearValue();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="DESCRIPTION" runat="server" Width="180" FieldLabel="产品描述"
                                                                    AllowBlank="false" BlankText="" MsgTarget="Side" Enabled="false" noedit="TRUE" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="IAN" runat="server" Width="180" FieldLabel="退货号码(IAN)<br/><font color='red'>（仅在产品可退回时提供）</font>"
                                                                    AllowBlank="true" BlankText="请填写产品退货号码(IAN)" MsgTarget="Side" Enabled="false"
                                                                    noedit="TRUE" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtRegistration" runat="server" Width="200" FieldLabel="注册证" Enabled="false"
                                                                    noedit="TRUE" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".34">
                                                <ext:Panel ID="Panel38" runat="server" Border="false" Header="false">
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
                                                                        <TriggerClick Handler="this.clearValue();#{WarehouseStore}.reload();#{cbWarehouse}.clearValue();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="UPNExpDate" runat="server" Width="180" FieldLabel="产品有效期" AllowBlank="true"
                                                                    BlankText="" MsgTarget="Side" Enabled="false" noedit="TRUE"/>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="DNNo" runat="server" Width="180" FieldLabel="波科DN号码" AllowBlank="true"
                                                                    Enabled="false" noedit="TRUE" />
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
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:FieldSet>
                            </ext:LayoutRow>
                            <ext:LayoutRow>
                                <ext:FieldSet ID="FieldSet1" runat="server" Header="true" Frame="false" BodyBorder="true"
                                    AutoHeight="true" AutoWidth="true">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout1" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel11" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel12" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Panel ID="Panel13" runat="server" Header="false" Frame="false" BodyBorder="false"
                                                                                    AutoHeight="true">
                                                                                    <Body>
                                                                                        <b style="font-size: 14px;">1. 报告信息</b>
                                                                                    </Body>
                                                                                </ext:Panel>
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
                                                <ext:Panel ID="Panel2" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel14" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label1" runat="server" FieldLabel="<b>BSC销售联系人</b>" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="CompletedName" runat="server" Width="200" FieldLabel="<font color='red'>*</font>姓名"
                                                                                    Cls="lightyellow-row" AllowBlank="false" BlankText="请填写姓名" MsgTarget="Side" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="CompletedTitle" runat="server" Width="200" FieldLabel="<font color='red'>*</font>职位"
                                                                                    Cls="lightyellow-row" AllowBlank="false" BlankText="请填写职位" MsgTarget="Side" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label5" runat="server" FieldLabel="<b>如果非波科员工上报</b>" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="NonBostonName" runat="server" Width="200" FieldLabel="<font color='red'>*</font>姓名"
                                                                                    BlankText="请填写姓名" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="NonBostonCompany" runat="server" Width="200" FieldLabel="公司" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="NonBostonAddress" runat="server" Width="200" FieldLabel="地址" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="NonBostonCity" runat="server" Width="200" FieldLabel="城市" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="NonBostonCountry" runat="server" Width="200" FieldLabel="国家" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label6" runat="server" HideLabel="true" Text="备注：该表格要求的所有信息都要求填写。对于无法获取的信息，请提供书面说明" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label2" runat="server" FieldLabel="<b>事件信息</b>" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="DateEvent" runat="server" Width="200" FieldLabel="<font color='red'>*</font>事件发生日期"
                                                                                    Cls="lightyellow-row" AllowBlank="false" BlankText="请选择事件发生日期" MsgTarget="Side" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="DateBSC" runat="server" Width="200" FieldLabel="<font color='red'>*</font>表单提交日期"
                                                                                    Enabled="false" noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="DateDealer" runat="server" Width="200" FieldLabel="<font color='red'>*</font>代理商接报日期"
                                                                                    Cls="lightyellow-row" AllowBlank="false" BlankText="请选择代理商接报日期" MsgTarget="Side" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="EventCountry" runat="server" Width="200" FieldLabel="<font color='red'>*</font>事件发生的国家"
                                                                                    Enabled="false" noedit="TRUE" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="OtherCountry" runat="server" Width="200" FieldLabel="其他国家" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label7" runat="server" Text="&nbsp;" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor Horizontal="80%">
                                                                                <ext:RadioGroup ID="NeedSupport" runat="server" FieldLabel="<font color='red'>*</font>是否需要技术支持"
                                                                                    BlankText="请选择【1.报告信息】中的【是否需要技术支持】">
                                                                                    <Items>
                                                                                        <ext:Radio ID="NeedSupport_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                                        <ext:Radio ID="NeedSupport_2" runat="server" BoxLabel="否" cvalue="2" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label36" runat="server" HideLabel="true" Text="" />
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
                                <ext:FieldSet ID="FieldSet10" runat="server" Header="true" Frame="false" BodyBorder="true"
                                    AutoHeight="true" AutoWidth="true" Title="">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout9" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel137" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout40" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".1">
                                                                <ext:Panel ID="Panel138" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout88" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Panel ID="Panel139" runat="server" Header="false" Frame="false" BodyBorder="false"
                                                                                    AutoHeight="true">
                                                                                    <Body>
                                                                                        <b style="font-size: 14px;">销售情况</b>
                                                                                    </Body>
                                                                                </ext:Panel>
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
                                                <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout38" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="160">
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
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel10" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="160">
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
                                                <ext:Panel ID="Panel134" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout39" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel135" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout86" runat="server" LabelAlign="Left" LabelWidth="160">
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
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel136" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout87" runat="server" LabelAlign="Left" LabelWidth="160">
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
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel140" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout41" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel141" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout89" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor Horizontal="100%">
                                                                                <ext:RadioGroup ID="PRODUCTTYPE" runat="server" FieldLabel="<font color='red'>*</font>产品类型"
                                                                                    AllowBlank="true" AutoWidth="true" BlankText="请选择【销售情况】中的【产品类型】" ColumnsNumber="3">
                                                                                    <Items>
                                                                                        <ext:Radio ID="PRODUCTTYPE_8" runat="server" BoxLabel="市场部/销售部样品" cvalue="8" />
                                                                                        <ext:Radio ID="PRODUCTTYPE_9" runat="server" BoxLabel="临床试验用的样品" cvalue="9" />
                                                                                        <ext:Radio ID="PRODUCTTYPE_10" runat="server" BoxLabel="新技术应用的样品" cvalue="10" />
                                                                                        <ext:Radio ID="PRODUCTTYPE_11" runat="server" BoxLabel="销售员(SRAI)/工程师(FSEAI)	" cvalue="11" />
                                                                                        <ext:Radio ID="PRODUCTTYPE_12" runat="server" BoxLabel="机器/机器配件" cvalue="12" />
                                                                                        <ext:Radio ID="PRODUCTTYPE_13" runat="server" BoxLabel="综合: 平台物权、T1物权、T2物权、医院物权、波科物权" cvalue="13" />
                                                                                        <%--<ext:Checkbox ID="PRODUCTTYPE_1" runat="server" BoxLabel="现金订货" cvalue="1" />
                                                                                        <ext:Checkbox ID="PRODUCTTYPE_2" runat="server" BoxLabel="平台寄售" cvalue="2" />
                                                                                        <ext:Checkbox ID="PRODUCTTYPE_20" runat="server" BoxLabel="波科寄售" cvalue="20" />
                                                                                        <ext:Checkbox ID="PRODUCTTYPE_3" runat="server" BoxLabel="短期寄售" cvalue="3" />
                                                                                        <ext:Checkbox ID="PRODUCTTYPE_4" runat="server" BoxLabel="北京/广州_FSL借货" cvalue="4" />
                                                                                        <ext:Checkbox ID="PRODUCTTYPE_5" runat="server" BoxLabel="样品" cvalue="5" />
                                                                                        <ext:Checkbox ID="PRODUCTTYPE_6" runat="server" BoxLabel="销售分配库存" cvalue="6" />
                                                                                        <ext:Checkbox ID="PRODUCTTYPE_7" runat="server" BoxLabel="程控仪/分析仪" cvalue="7" />--%>
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel142" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout90" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:ComboBox ID="RETURNTYPE" runat="server" FieldLabel="<font color='red'>*</font>产品换货或退款"
                                                                                    Width="200" Editable="false" TypeAhead="true" BlankText="选择产品换货或退款" AllowBlank="false"
                                                                                    Cls="lightyellow-row" MsgTarget="Under">
                                                                                    <Items>
                                                                                        <ext:ListItem Text="换货" Value="1" />
                                                                                        <ext:ListItem Text="退款" Value="2" />
                                                                                        <ext:ListItem Text="只退不换" Value="5" />
                                                                                        <%--<ext:ListItem Text="仅投诉事件" Value="3" />--%>                                                                                        
                                                                                    </Items>
                                                                                    <Listeners>
                                                                                        <Select Handler="Coolite.AjaxMethods.DealerComplainCRMEdit.CheckReturnType({failure: function(err) { alert(err); Ext.Msg.alert('Failure', err);}});" />
                                                                                    </Listeners>
                                                                                </ext:ComboBox>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:ComboBox ID="CFMRETURNTYPE" runat="server" FieldLabel="波科确认产品换货或退款"
                                                                                    Width="200" Editable="false" TypeAhead="true" >
                                                                                    <Items>
                                                                                        <ext:ListItem Text="换货" Value="1" />
                                                                                        <ext:ListItem Text="退款" Value="2" />
                                                                                        <ext:ListItem Text="只退不换" Value="5" />
                                                                                        <%--<ext:ListItem Text="仅投诉事件" Value="3" />--%>                                                                                        
                                                                                    </Items>
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
                                    AutoHeight="true" AutoWidth="true">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout2" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel15" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel18" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Panel ID="Panel19" runat="server" Header="false" Frame="false" BodyBorder="false"
                                                                                    AutoHeight="true">
                                                                                    <Body>
                                                                                        <b style="font-size: 14px;">2. 病人信息</b>
                                                                                    </Body>
                                                                                </ext:Panel>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel23" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout11" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Panel ID="Panel24" runat="server" Header="false" Frame="false" BodyBorder="false"
                                                                                    AutoHeight="true">
                                                                                    <Body>
                                                                                        <b style="font-size: 14px;">3. 医生信息及信息来源</b>
                                                                                    </Body>
                                                                                </ext:Panel>
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
                                                <ext:Panel ID="Panel27" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel28" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout14" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PatientName" runat="server" Width="140" FieldLabel="<font color='red'>*</font>患者姓名或首字母"
                                                                                    BlankText="请填写患者姓名或首字母" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".25">
                                                                <ext:Panel ID="Panel29" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout15" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PhysicianName" runat="server" Width="140" FieldLabel="<font color='red'>*</font>医生姓名/信息来源者姓名"
                                                                                    BlankText="请填写医生姓名/信息来源者姓名" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".25">
                                                                <ext:Panel ID="Panel30" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout16" runat="server" LabelAlign="Left" LabelWidth="50">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PhysicianHospital" runat="server" Width="140" FieldLabel="<font color='red'>*</font>医院"
                                                                                    BlankText="请填写医院" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row" />
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
                                                        <ext:ColumnLayout ID="ColumnLayout8" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel32" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout17" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PatientNum" runat="server" Width="140" FieldLabel="<font color='red'>*</font>患者编号"
                                                                                    BlankText="请填写患者编号" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel33" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout18" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PhysicianTitle" runat="server" Width="140" FieldLabel="<font color='red'>*</font>职位"
                                                                                    BlankText="请填写职位" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row" />
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
                                                        <ext:ColumnLayout ID="ColumnLayout9" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".3">
                                                                <ext:Panel ID="Panel35" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout19" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PatientSex" runat="server" Width="140" FieldLabel="<font color='red'>*</font>患者性别"
                                                                                    BlankText="请填写患者性别" MsgTarget="Side" AllowBlank="true" Cls="lightyellow-row" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".2">
                                                                <ext:Panel ID="Panel36" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout20" runat="server" LabelAlign="Left" LabelWidth="30">
                                                                            <ext:Anchor>
                                                                                <ext:Checkbox ID="PatientSexInvalid" runat="server" Width="120" FieldLabel="或者" BoxLabel="不能获取"
                                                                                    LabelSeparator="" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel37" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout21" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PhysicianAddress" runat="server" Width="140" FieldLabel="<font color='red'>*</font>地址"
                                                                                    BlankText="请填写地址" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row" />
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
                                                <ext:Panel ID="Panel39" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout10" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".3">
                                                                <ext:Panel ID="Panel40" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout22" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="PatientBirth" runat="server" Width="140" FieldLabel="<font color='red'>*</font>患者出身年月日"
                                                                                    BlankText="请填写患者出身年月日" MsgTarget="Side" AllowBlank="true" Cls="lightyellow-row" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".2">
                                                                <ext:Panel ID="Panel41" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout23" runat="server" LabelAlign="Left" LabelWidth="30">
                                                                            <ext:Anchor>
                                                                                <ext:Checkbox ID="PatientBirthInvalid" runat="server" Width="120" FieldLabel="或者"
                                                                                    BoxLabel="不能获取" LabelSeparator="" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".25">
                                                                <ext:Panel ID="Panel42" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout24" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PhysicianCity" runat="server" Width="140" FieldLabel="<font color='red'>*</font>城市"
                                                                                    BlankText="请填写城市" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".25">
                                                                <ext:Panel ID="Panel43" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout25" runat="server" LabelAlign="Left" LabelWidth="50">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PhysicianZipcode" runat="server" Width="140" FieldLabel="邮编" />
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
                                                        <ext:ColumnLayout ID="ColumnLayout11" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".3">
                                                                <ext:Panel ID="Panel45" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout26" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PatientWeight" runat="server" Width="140" FieldLabel="<font color='red'>*</font>患者体重<br/>（事件当时，单位KG）"
                                                                                    BlankText="请填写患者体重（事件当时）" MsgTarget="Side" AllowBlank="true" Cls="lightyellow-row" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".2">
                                                                <ext:Panel ID="Panel46" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout27" runat="server" LabelAlign="Left" LabelWidth="30">
                                                                            <ext:Anchor>
                                                                                <ext:Checkbox ID="PatientWeightInvalid" runat="server" Width="120" FieldLabel="或者"
                                                                                    BoxLabel="不能获取" LabelSeparator="" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel47" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout28" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PhysicianCountry" runat="server" Width="140" FieldLabel="<font color='red'>*</font>国家"
                                                                                    BlankText="请填写国家" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row" />
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
                                    AutoHeight="true" AutoWidth="true">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout3" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel20" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout6" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel21" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Panel ID="Panel22" runat="server" Header="false" Frame="false" BodyBorder="false"
                                                                                    AutoHeight="true">
                                                                                    <Body>
                                                                                        <b style="font-size: 14px;">4. 患者状态</b>
                                                                                    </Body>
                                                                                </ext:Panel>
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
                                                <ext:Panel ID="Panel49" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout13" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel50" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout13" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:CheckboxGroup ID="PatientStatus" runat="server" FieldLabel="<font color='red'>*</font>患者状态"
                                                                                    BlankText="请选择【4.患者状态】中的【患者状态】" ColumnsNumber="4">
                                                                                    <Items>
                                                                                        <ext:Checkbox ID="PatientStatus_1" runat="server" BoxLabel="患者无任何不良反应" cvalue="1"
                                                                                            Checked="true" />
                                                                                        <ext:Checkbox ID="PatientStatus_2" runat="server" BoxLabel="患者出院在家，正常随访" cvalue="2" />
                                                                                        <ext:Checkbox ID="PatientStatus_3" runat="server" BoxLabel="患者有不良反应" cvalue="3" />
                                                                                        <ext:Checkbox ID="PatientStatus_4" runat="server" BoxLabel="患者入院" cvalue="4" />
                                                                                        <ext:Checkbox ID="PatientStatus_5" runat="server" BoxLabel="医学原因（病人自身情况有关/与产品无关）"
                                                                                            cvalue="5" />
                                                                                        <ext:Checkbox ID="PatientStatus_6" runat="server" BoxLabel="死亡" cvalue="6">
                                                                                            <Listeners>
                                                                                                <Check Handler="isDeathCheck();" />
                                                                                            </Listeners>
                                                                                        </ext:Checkbox>
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
                                                <ext:Panel ID="Panel25" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout12" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".33">
                                                                <ext:Panel ID="Panel26" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout10" runat="server" LabelAlign="Left" LabelWidth="120">
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="DeathDate" runat="server" Width="140" FieldLabel="死亡日期" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".67">
                                                                <ext:Panel ID="Panel48" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout12" runat="server" LabelAlign="Left" LabelWidth="120">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="DeathTime" runat="server" Width="140" FieldLabel="死亡时间" />
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
                                                <ext:Panel ID="Panel51" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout14" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel52" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout29" runat="server" LabelAlign="Left" LabelWidth="120">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="DeathCause" runat="server" Width="400" FieldLabel="原因" />
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
                                                <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel53" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout30" runat="server" LabelAlign="Left" LabelWidth="250">
                                                                            <ext:Anchor Horizontal="40%">
                                                                                <ext:RadioGroup ID="Witnessed" runat="server" FieldLabel="上报人是否在场" Width="200">
                                                                                    <Items>
                                                                                        <ext:Radio ID="Witnessed_1" runat="server" BoxLabel="上报人在场" cvalue="1" />
                                                                                        <ext:Radio ID="Witnessed_2" runat="server" BoxLabel="上报人未在场" cvalue="2" />
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
                                                <ext:Panel ID="Panel54" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout15" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel56" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout32" runat="server" LabelAlign="Left" LabelWidth="250">
                                                                            <ext:Anchor Horizontal="40%">
                                                                                <ext:RadioGroup ID="RelatedBSC" runat="server" FieldLabel="是否怀疑该死亡与波科产品故障有关" Width="300">
                                                                                    <Items>
                                                                                        <ext:Radio ID="RelatedBSC_1" runat="server" BoxLabel="不知道" cvalue="1" />
                                                                                        <ext:Radio ID="RelatedBSC_2" runat="server" BoxLabel="是" cvalue="2" />
                                                                                        <ext:Radio ID="RelatedBSC_3" runat="server" BoxLabel="否" cvalue="3" />
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
                                <ext:FieldSet ID="FieldSet4" runat="server" Header="true" Frame="false" BodyBorder="true"
                                    AutoHeight="true" AutoWidth="true">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout4" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel55" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout16" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel57" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout31" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Panel ID="Panel58" runat="server" Header="false" Frame="false" BodyBorder="false"
                                                                                    AutoHeight="true">
                                                                                    <Body>
                                                                                        <b style="font-size: 14px;">5. 上报产品体验报告的原因</b>
                                                                                    </Body>
                                                                                </ext:Panel>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel59" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout33" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Panel ID="Panel60" runat="server" Header="false" Frame="false" BodyBorder="false"
                                                                                    AutoHeight="true">
                                                                                    <Body>
                                                                                        <b style="font-size: 14px;">6. 返回信息</b>
                                                                                    </Body>
                                                                                </ext:Panel>
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
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel62" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout35" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="IsForBSCProduct" runat="server" FieldLabel="<font color='red'>*</font>是否与波科产品有关"
                                                                                    AllowBlank="true" BlankText="请选择【5.上报产品体验报告的原因】中的【是否与波科产品有关】" Width="140">
                                                                                    <Items>
                                                                                        <ext:Radio ID="ISFORBSCPRODUCT_01" runat="server" BoxLabel="是" cvalue="1" />
                                                                                        <ext:Radio ID="ISFORBSCPRODUCT_02" runat="server" BoxLabel="否" cvalue="2" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor Horizontal="90%">
                                                                                <ext:CheckboxGroup ID="ReasonsForProduct" runat="server" FieldLabel="<font color='red'>*</font>上报原因"
                                                                                    BlankText="请选择【5.上报产品体验报告的原因】中的【上报原因】" ColumnsNumber="2">
                                                                                    <Items>
                                                                                        <ext:Checkbox ID="ReasonsForProduct_1" runat="server" BoxLabel="发生在植入前测试中" cvalue="1" />
                                                                                        <ext:Checkbox ID="ReasonsForProduct_2" runat="server" BoxLabel="发生在植入中创口缝合前" cvalue="2" />
                                                                                        <ext:Checkbox ID="ReasonsForProduct_3" runat="server" BoxLabel="发生在囊袋闭合后" cvalue="3" />
                                                                                        <ext:Checkbox ID="ReasonsForProduct_4" runat="server" BoxLabel="发生在取出时/取出后" cvalue="4" />
                                                                                        <ext:Checkbox ID="ReasonsForProduct_5" runat="server" BoxLabel="发生在随访中" cvalue="5" />
                                                                                        <ext:Checkbox ID="ReasonsForProduct_6" runat="server" BoxLabel="发布声明/召回<br/>（只是为了预防而建议取出产品）"
                                                                                            cvalue="6" Height="30" />
                                                                                        <ext:Checkbox ID="ReasonsForProduct_7" runat="server" BoxLabel="其他（请在第九部分解释）" cvalue="7" />
                                                                                    </Items>
                                                                                </ext:CheckboxGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                <ext:Panel ID="Panel64" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout38" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor Horizontal="60%">
                                                                                <ext:CheckboxGroup ID="Returned" runat="server" FieldLabel="<font color='red'>*</font>产品是否可返回"
                                                                                    BlankText="请选择【6.返回信息】中的【产品是否可返回】">
                                                                                    <Items>
                                                                                        <ext:Checkbox ID="Returned_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                                        <ext:Checkbox ID="Returned_2" runat="server" BoxLabel="无法返回" cvalue="2" />
                                                                                    </Items>
                                                                                </ext:CheckboxGroup>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="ReturnedDay" runat="server" Width="200" FieldLabel="如果是，需要多少天返回" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor Horizontal="60%">
                                                                                <ext:CheckboxGroup ID="AnalysisReport" runat="server" FieldLabel="<font color='red'>*</font>是否要求提供分析报告"
                                                                                    BlankText="请选择【6.返回信息】中的【是否要求提供分析报告】">
                                                                                    <Items>
                                                                                        <ext:Checkbox ID="AnalysisReport_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                                        <ext:Checkbox ID="AnalysisReport_2" runat="server" BoxLabel="否" cvalue="2" />
                                                                                    </Items>
                                                                                </ext:CheckboxGroup>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="RequestPhysicianName" runat="server" Width="200" FieldLabel="<font color='red'>*</font>要求提供报告的医生姓名"
                                                                                    AllowBlank="false" BlankText="请填写要求提供报告的医生姓名" Cls="lightyellow-row" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor Horizontal="60%">
                                                                                <ext:CheckboxGroup ID="Warranty" runat="server" FieldLabel="是否有保修单" BlankText="请选择【6.返回信息】中的【是否有保修单】">
                                                                                    <Items>
                                                                                        <ext:Checkbox ID="Warranty_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                                        <ext:Checkbox ID="Warranty_2" runat="server" BoxLabel="否" cvalue="2" />
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
                                        </ext:RowLayout>
                                    </Body>
                                </ext:FieldSet>
                            </ext:LayoutRow>
                            <ext:LayoutRow>
                                <ext:FieldSet ID="FieldSet5" runat="server" Header="true" Frame="false" BodyBorder="true"
                                    AutoHeight="true" AutoWidth="true">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout5" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel63" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout19" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel65" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout37" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Panel ID="Panel66" runat="server" Header="false" Frame="false" BodyBorder="false"
                                                                                    AutoHeight="true">
                                                                                    <Body>
                                                                                        <b style="font-size: 14px;">7. 临床观察</b>
                                                                                    </Body>
                                                                                </ext:Panel>
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
                                                <ext:Panel ID="Panel69" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout21" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel70" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout41" runat="server" LabelAlign="Left" LabelWidth="100">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label10" runat="server" Html="<b>脉冲发生器/程控仪</b><br/>&nbsp;" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor Horizontal="60%">
                                                                                <ext:CheckboxGroup ID="Pulse" runat="server" HideLabel="true" BlankText="请选择【7.临床观察】中的【脉冲发生器/程控仪】">
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".99">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Pulse_1" runat="server" BoxLabel="Fault codes/error messages 故障码/错误信息（将故障码/错误信息写在第九部分）"
                                                                                                    cvalue="1" />
                                                                                                <ext:Checkbox ID="Pulse_2" runat="server" BoxLabel="Beeping tones 蜂鸣声" cvalue="2" />
                                                                                                <ext:Checkbox ID="Pulse_3" runat="server" BoxLabel="Telemetry Problem 遥测技术问题" cvalue="3" />
                                                                                                <ext:Checkbox ID="Pulse_4" runat="server" BoxLabel="Unable to establish telemetry 不能建立遥测技术"
                                                                                                    cvalue="4" />
                                                                                                <ext:Checkbox ID="Pulse_5" runat="server" BoxLabel="Normal ERI, no allegation ERI ERI正常，未宣称"
                                                                                                    cvalue="5" />
                                                                                                <ext:Checkbox ID="Pulse_6" runat="server" BoxLabel="Allegation of premature battery depletion 宣称电池提前耗竭"
                                                                                                    cvalue="6" />
                                                                                                <ext:Checkbox ID="Pulse_7" runat="server" BoxLabel="Undersensing 感知不良" cvalue="7" />
                                                                                                <ext:Checkbox ID="Pulse_8" runat="server" BoxLabel="Oversensing 过度感知" cvalue="8" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                    </Items>
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".55">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Pulse_9" runat="server" BoxLabel="Pacing inhibition(Number of beats inhibited) 起搏抑制（抑制起搏的跳数）"
                                                                                                    cvalue="9">
                                                                                                    <Listeners>
                                                                                                        <Check Handler="showTextBoxWhenChecked('Pulse_9');" />
                                                                                                    </Listeners>
                                                                                                </ext:Checkbox>
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                        <ext:CheckboxColumn ColumnWidth=".45">
                                                                                            <Items>
                                                                                                <ext:TextField ID="Pulsebeats" runat="server" Width="200" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                    </Items>
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".99">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Pulse_10" runat="server" BoxLabel="Unable to interrogate无法询问" cvalue="10" />
                                                                                                <ext:Checkbox ID="Pulse_11" runat="server" BoxLabel="Safety Mode 安全模式" cvalue="11" />
                                                                                                <ext:Checkbox ID="Pulse_12" runat="server" BoxLabel="High defibrillation thresholds 高除颤阈值"
                                                                                                    cvalue="12" />
                                                                                                <ext:Checkbox ID="Pulse_13" runat="server" BoxLabel="Brady pacing not delivered 未发起心动过缓起搏"
                                                                                                    cvalue="13" />
                                                                                                <ext:Checkbox ID="Pulse_14" runat="server" BoxLabel="Tachy pacing not delivered 未发起心动过速起搏"
                                                                                                    cvalue="14" />
                                                                                                <ext:Checkbox ID="Pulse_15" runat="server" BoxLabel="Other (Please explain in section 9) 其他（请在第九部分解释）"
                                                                                                    cvalue="15" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
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
                                                <ext:Panel ID="Panel679" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout43" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel67" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout39" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label4" runat="server" Html="<b>电极/传送系统</b><br/>请指明电极位置，例如右心房，右心室，左心室等"
                                                                                    HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor Horizontal="60%">
                                                                                <ext:CheckboxGroup ID="Leads" runat="server" HideLabel="true" ColumnsNumber="1" BlankText="请选择【7.临床观察】中的【电极/传送系统】">
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".55">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Leads_1" runat="server" BoxLabel="Lead conductor fracture 电极导体断裂"
                                                                                                    cvalue="1">
                                                                                                    <Listeners>
                                                                                                        <Check Handler="showTextBoxWhenChecked('Leads_1');" />
                                                                                                    </Listeners>
                                                                                                </ext:Checkbox>
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                        <ext:CheckboxColumn ColumnWidth=".45">
                                                                                            <Items>
                                                                                                <ext:TextField ID="LeadsFracture" runat="server" Width="200" HideLabel="true" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                    </Items>
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".55">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Leads_2" runat="server" BoxLabel="Insulation issue 绝缘层问题" cvalue="2">
                                                                                                    <Listeners>
                                                                                                        <Check Handler="showTextBoxWhenChecked('Leads_2');" />
                                                                                                    </Listeners>
                                                                                                </ext:Checkbox>
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                        <ext:CheckboxColumn ColumnWidth=".45">
                                                                                            <Items>
                                                                                                <ext:TextField ID="LeadsIssue" runat="server" Width="200" HideLabel="true" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                    </Items>
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".55">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Leads_3" runat="server" BoxLabel="Lead dislodgement 电极脱位" cvalue="3">
                                                                                                    <Listeners>
                                                                                                        <Check Handler="showTextBoxWhenChecked('Leads_3');" />
                                                                                                    </Listeners>
                                                                                                </ext:Checkbox>
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                        <ext:CheckboxColumn ColumnWidth=".45">
                                                                                            <Items>
                                                                                                <ext:TextField ID="LeadsDislodgement" runat="server" Width="200" HideLabel="true" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                    </Items>
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".55">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Leads_4" runat="server" BoxLabel="Abnormal impedance measurements 阻抗测量值异常(Ohms)"
                                                                                                    cvalue="4">
                                                                                                    <Listeners>
                                                                                                        <Check Handler="showTextBoxWhenChecked('Leads_4');" />
                                                                                                    </Listeners>
                                                                                                </ext:Checkbox>
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                        <ext:CheckboxColumn ColumnWidth=".45">
                                                                                            <Items>
                                                                                                <ext:TextField ID="LeadsMeasurements" runat="server" Width="200" HideLabel="true" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                    </Items>
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".99">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Leads_5" runat="server" BoxLabel="Inappropriate shock 不恰当电击" cvalue="5" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                    </Items>
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".55">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Leads_6" runat="server" BoxLabel="High pacing thresholds 起搏阈值过高"
                                                                                                    cvalue="6">
                                                                                                    <Listeners>
                                                                                                        <Check Handler="showTextBoxWhenChecked('Leads_6');" />
                                                                                                    </Listeners>
                                                                                                </ext:Checkbox>
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                        <ext:CheckboxColumn ColumnWidth=".45">
                                                                                            <Items>
                                                                                                <ext:TextField ID="LeadsThresholds" runat="server" Width="200" HideLabel="true" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                    </Items>
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".55">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Leads_7" runat="server" BoxLabel="Pacing inhibition(Number of beats inhibited) 起搏抑制（抑制起搏的跳数）"
                                                                                                    cvalue="7">
                                                                                                    <Listeners>
                                                                                                        <Check Handler="showTextBoxWhenChecked('Leads_7');" />
                                                                                                    </Listeners>
                                                                                                </ext:Checkbox>
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                        <ext:CheckboxColumn ColumnWidth=".45">
                                                                                            <Items>
                                                                                                <ext:TextField ID="LeadsBeats" runat="server" Width="200" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                    </Items>
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".55">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Leads_8" runat="server" BoxLabel="Noise 噪声" cvalue="8">
                                                                                                    <Listeners>
                                                                                                        <Check Handler="showTextBoxWhenChecked('Leads_8');" />
                                                                                                    </Listeners>
                                                                                                </ext:Checkbox>
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                        <ext:CheckboxColumn ColumnWidth=".45">
                                                                                            <Items>
                                                                                                <ext:TextField ID="LeadsNoise" runat="server" Width="200" HideLabel="true" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                    </Items>
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".55">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Leads_9" runat="server" BoxLabel="Loss of capture 失夺获" cvalue="9">
                                                                                                    <Listeners>
                                                                                                        <Check Handler="showTextBoxWhenChecked('Leads_9');" />
                                                                                                    </Listeners>
                                                                                                </ext:Checkbox>
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                        <ext:CheckboxColumn ColumnWidth=".45">
                                                                                            <Items>
                                                                                                <ext:TextField ID="LeadsLoss" runat="server" Width="200" HideLabel="true" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                    </Items>
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".99">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Leads_10" runat="server" BoxLabel="未转复为室速或室颤" cvalue="10" />
                                                                                                <ext:Checkbox ID="Leads_11" runat="server" BoxLabel="Other (Please explain in section 9) 其他（请在第九部分解释）"
                                                                                                    cvalue="11" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
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
                                                <ext:Panel ID="Panel669" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout42" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel71" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout42" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label3" runat="server" Html="<b>临床</b><br/>请指明电极位置，例如右心房，右心室，左心室等"
                                                                                    HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor Horizontal="60%">
                                                                                <ext:CheckboxGroup ID="Clinical" runat="server" HideLabel="true" ColumnsNumber="1"
                                                                                    BlankText="请选择【7.临床观察】中的【临床】">
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".55">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Clinical_1" runat="server" BoxLabel="Perforation 穿孔" cvalue="1">
                                                                                                    <Listeners>
                                                                                                        <Check Handler="showTextBoxWhenChecked('Clinical_1');" />
                                                                                                    </Listeners>
                                                                                                </ext:Checkbox>
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                        <ext:CheckboxColumn ColumnWidth=".45">
                                                                                            <Items>
                                                                                                <ext:TextField ID="ClinicalPerforation" runat="server" Width="200" HideLabel="true" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                    </Items>
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".99">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Clinical_2" runat="server" BoxLabel="Dissection 夹层" cvalue="2" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                    </Items>
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".55">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Clinical_3" runat="server" BoxLabel="Abnormal impedance measurements 阻抗测量值异常（Ohms）"
                                                                                                    cvalue="3">
                                                                                                    <Listeners>
                                                                                                        <Check Handler="showTextBoxWhenChecked('Clinical_3');" />
                                                                                                    </Listeners>
                                                                                                </ext:Checkbox>
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                        <ext:CheckboxColumn ColumnWidth=".45">
                                                                                            <Items>
                                                                                                <ext:TextField ID="ClinicalBeats" runat="server" Width="200" HideLabel="true" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
                                                                                    </Items>
                                                                                    <Items>
                                                                                        <ext:CheckboxColumn ColumnWidth=".99">
                                                                                            <Items>
                                                                                                <ext:Checkbox ID="Clinical_4" runat="server" BoxLabel="Diaphragmatic stimulation 隔肌刺激"
                                                                                                    cvalue="4" />
                                                                                                <ext:Checkbox ID="Clinical_5" runat="server" BoxLabel="Resolved with reprogramming 再程控"
                                                                                                    cvalue="5" />
                                                                                                <ext:Checkbox ID="Clinical_6" runat="server" BoxLabel="Muscle/pocket stimulation 肌肉/囊袋刺激"
                                                                                                    cvalue="6" />
                                                                                                <ext:Checkbox ID="Clinical_7" runat="server" BoxLabel="Infection 感染" cvalue="7" />
                                                                                                <ext:Checkbox ID="Clinical_8" runat="server" BoxLabel="Syncope, loss of consciousness 晕厥，意识丧失（请在第九部分解释）"
                                                                                                    cvalue="8" />
                                                                                                <ext:Checkbox ID="Clinical_9" runat="server" BoxLabel="Migration/Erosion 设备移位/糜烂"
                                                                                                    cvalue="9" />
                                                                                                <ext:Checkbox ID="Clinical_10" runat="server" BoxLabel="Rhythm acceleration 心律加速"
                                                                                                    cvalue="10" />
                                                                                                <ext:Checkbox ID="Clinical_11" runat="server" BoxLabel="Other (Please explain in section 9) 其他（请在第九部分解释）"
                                                                                                    cvalue="11" />
                                                                                            </Items>
                                                                                        </ext:CheckboxColumn>
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
                                        </ext:RowLayout>
                                    </Body>
                                </ext:FieldSet>
                            </ext:LayoutRow>
                            <ext:LayoutRow>
                                <ext:FieldSet ID="FieldSet7" runat="server" Header="true" Frame="false" BodyBorder="true"
                                    AutoHeight="true" AutoWidth="true">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout6" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel68" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout20" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel72" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout43" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Panel ID="Panel73" runat="server" Header="false" Frame="false" BodyBorder="false"
                                                                                    AutoHeight="true">
                                                                                    <Body>
                                                                                        <b style="font-size: 14px;">8. 设备/电极状态</b>
                                                                                    </Body>
                                                                                </ext:Panel>
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
                                                <ext:Panel ID="Panel76" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout22" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel78" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout46" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label14" runat="server" HideLabel="true" Html="&nbsp;" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label15" runat="server" HideLabel="true" Html="脉冲发生器" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel74" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout44" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label20" runat="server" HideLabel="true" Html="Model" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PulseModel" runat="server" Width="100" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel75" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout45" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label16" runat="server" HideLabel="true" Html="Serial #" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="PulseSerial" runat="server" Width="100" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".56">
                                                                <ext:Panel ID="Panel77" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout47" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label17" runat="server" HideLabel="true" Html="植入时间" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="PulseImplant" runat="server" Width="100" HideLabel="true" />
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
                                                <ext:Panel ID="Panel86" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout24" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel87" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout54" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label25" runat="server" HideLabel="true" Html="电极1" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel88" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout55" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Leads1Model" runat="server" Width="100" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel89" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout56" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Leads1Serial" runat="server" Width="100" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel90" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout57" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="Leads1Implant" runat="server" Width="100" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel91" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout58" runat="server" LabelAlign="Left" LabelWidth="100">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label28" runat="server" HideLabel="true" Html="电极位置" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".45">
                                                                <ext:Panel ID="Panel92" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout59" runat="server" LabelAlign="Left" HideLabel="true">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="Leads1Position" runat="server" HideLabel="true" ColumnsNumber="4"
                                                                                    Width="350">
                                                                                    <Items>
                                                                                        <ext:Radio ID="Leads1Position_1" runat="server" BoxLabel="右心房" cvalue="1" />
                                                                                        <ext:Radio ID="Leads1Position_2" runat="server" BoxLabel="右心室" cvalue="2" />
                                                                                        <ext:Radio ID="Leads1Position_3" runat="server" BoxLabel="左心室" cvalue="3" />
                                                                                        <ext:Radio ID="Leads1Position_4" runat="server" BoxLabel="不知道" cvalue="4" />
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
                                                <ext:Panel ID="Panel93" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout25" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel94" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout60" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label26" runat="server" HideLabel="true" Html="电极2" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel95" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout61" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Leads2Model" runat="server" Width="100" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel96" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout62" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Leads2Serial" runat="server" Width="100" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel97" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout63" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="Leads2Implant" runat="server" Width="100" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel98" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout64" runat="server" LabelAlign="Left" LabelWidth="100">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label27" runat="server" HideLabel="true" Html="电极位置" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".45">
                                                                <ext:Panel ID="Panel99" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout65" runat="server" LabelAlign="Left" HideLabel="true">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="Leads2Position" runat="server" HideLabel="true" ColumnsNumber="4"
                                                                                    Width="350">
                                                                                    <Items>
                                                                                        <ext:Radio ID="Leads2Position_1" runat="server" BoxLabel="右心房" cvalue="1" />
                                                                                        <ext:Radio ID="Leads2Position_2" runat="server" BoxLabel="右心室" cvalue="2" />
                                                                                        <ext:Radio ID="Leads2Position_3" runat="server" BoxLabel="左心室" cvalue="3" />
                                                                                        <ext:Radio ID="Leads2Position_4" runat="server" BoxLabel="不知道" cvalue="4" />
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
                                                <ext:Panel ID="Panel79" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout23" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel80" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout48" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label18" runat="server" HideLabel="true" Html="电极3" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel81" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout49" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Leads3Model" runat="server" Width="100" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel82" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout50" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Leads3Serial" runat="server" Width="100" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel83" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout51" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="Leads3Implant" runat="server" Width="100" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel84" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout52" runat="server" LabelAlign="Left" LabelWidth="100">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label19" runat="server" HideLabel="true" Html="电极位置" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".45">
                                                                <ext:Panel ID="Panel85" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout53" runat="server" LabelAlign="Left" HideLabel="true">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="Leads3Position" runat="server" HideLabel="true" ColumnsNumber="4"
                                                                                    Width="350">
                                                                                    <Items>
                                                                                        <ext:Radio ID="Leads3Position_1" runat="server" BoxLabel="右心房" cvalue="1" />
                                                                                        <ext:Radio ID="Leads3Position_2" runat="server" BoxLabel="右心室" cvalue="2" />
                                                                                        <ext:Radio ID="Leads3Position_3" runat="server" BoxLabel="左心室" cvalue="3" />
                                                                                        <ext:Radio ID="Leads3Position_4" runat="server" BoxLabel="不知道" cvalue="4" />
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
                                                <ext:Panel ID="Panel100" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout26" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel101" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout66" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label21" runat="server" HideLabel="true" Html="配件" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel102" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout67" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="AccessoryModel" runat="server" Width="100" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel103" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout68" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="AccessorySerial" runat="server" Width="100" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel104" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout69" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="AccessoryImplant" runat="server" Width="100" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".11">
                                                                <ext:Panel ID="Panel105" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout70" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label22" runat="server" HideLabel="true" Html="Lot#</b>" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".45">
                                                                <ext:Panel ID="Panel106" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout71" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="AccessoryLot" runat="server" Width="100" HideLabel="true" />
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
                                                <ext:Panel ID="Panel107" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout27" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel108" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout72" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label23" runat="server" HideLabel="true" Html="" />
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
                                                <ext:Panel ID="Panel109" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout28" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".99">
                                                                <ext:Panel ID="Panel110" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout73" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="ExplantDate" runat="server" Width="200" FieldLabel="移除时间" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>
                                            <%--<ext:LayoutRow>
                                                <ext:Panel ID="Panel111" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout29" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="">
                                                                <ext:Panel ID="Panel112" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout74" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label24" runat="server" HideLabel="true" Html="" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutRow>--%>
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel113" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout30" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".99">
                                                                <ext:Panel ID="Panel114" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout75" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <%--<ext:Anchor>
                                                                                <ext:Label ID="Label29" runat="server" HideLabel="true" Html="仍在服务中" />
                                                                            </ext:Anchor>--%>
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="RemainsService" runat="server" FieldLabel="仍在服务中" ColumnsNumber="5"
                                                                                    Width="600">
                                                                                    <Items>
                                                                                        <ext:Radio ID="RemainsService_1" runat="server" BoxLabel="未改变" cvalue="1">
                                                                                            <Listeners>
                                                                                                <Check Handler="isRemainsServiceChheck(true);" />
                                                                                            </Listeners>
                                                                                        </ext:Radio>
                                                                                        <ext:Radio ID="RemainsService_2" runat="server" BoxLabel="重新程控" cvalue="2">
                                                                                            <Listeners>
                                                                                                <Check Handler="isRemainsServiceChheck(true);" />
                                                                                            </Listeners>
                                                                                        </ext:Radio>
                                                                                        <ext:Radio ID="RemainsService_3" runat="server" BoxLabel="重新定位" cvalue="3">
                                                                                            <Listeners>
                                                                                                <Check Handler="isRemainsServiceChheck(true);" />
                                                                                            </Listeners>
                                                                                        </ext:Radio>
                                                                                        <ext:Radio ID="RemainsService_4" runat="server" BoxLabel="修理" cvalue="4">
                                                                                            <Listeners>
                                                                                                <Check Handler="isRemainsServiceChheck(true);" />
                                                                                            </Listeners>
                                                                                        </ext:Radio>
                                                                                        <ext:Radio ID="RemainsService_5" runat="server" BoxLabel="失效" cvalue="5">
                                                                                            <Listeners>
                                                                                                <Check Handler="isRemainsServiceChheck(true);" />
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
                                                <ext:Panel ID="Panel243" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout44" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".99">
                                                                <ext:Panel ID="Panel115" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout76" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <%-- <ext:Anchor>
                                                                                <ext:Label ID="Label30" runat="server" HideLabel="true" Html="产品已移除体内" />
                                                                            </ext:Anchor>--%>
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="RemovedService" runat="server" FieldLabel="产品已移除体内" ColumnsNumber="4"
                                                                                    Width="700">
                                                                                    <Items>
                                                                                        <ext:Radio ID="RemovedService_1" runat="server" BoxLabel="丢弃" cvalue="1">
                                                                                            <Listeners>
                                                                                                <Check Handler="isRemainsServiceChheck(false);" />
                                                                                            </Listeners>
                                                                                        </ext:Radio>
                                                                                        <ext:Radio ID="RemovedService_2" runat="server" BoxLabel="返回波科" cvalue="2">
                                                                                            <Listeners>
                                                                                                <Check Handler="isRemainsServiceChheck(false);" />
                                                                                            </Listeners>
                                                                                        </ext:Radio>
                                                                                        <ext:Radio ID="RemovedService_3" runat="server" BoxLabel="STAT analysis requested"
                                                                                            cvalue="3">
                                                                                            <Listeners>
                                                                                                <Check Handler="isRemainsServiceChheck(false);" />
                                                                                            </Listeners>
                                                                                        </ext:Radio>
                                                                                        <ext:Radio ID="RemovedService_4" runat="server" BoxLabel="设备或电极不能退回" cvalue="4">
                                                                                            <Listeners>
                                                                                                <Check Handler="isRemainsServiceChheck(false);" />
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
                                                <ext:Panel ID="Panel116" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout31" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel117" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout77" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label31" runat="server" HideLabel="true" Html="" />
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
                                                <ext:Panel ID="Panel118" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout32" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel119" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout78" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label32" runat="server" HideLabel="true" Html="更换的产品信息" />
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
                                                <ext:Panel ID="Panel120" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout33" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".2">
                                                                <ext:Panel ID="Panel121" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout79" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label33" runat="server" HideLabel="true" Html="型号" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Replace1Model" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Replace2Model" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Replace3Model" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Replace4Model" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Replace5Model" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".2">
                                                                <ext:Panel ID="Panel122" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout80" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label34" runat="server" HideLabel="true" Html="序列号" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Replace1Serial" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Replace2Serial" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Replace3Serial" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Replace4Serial" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="Replace5Serial" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".6">
                                                                <ext:Panel ID="Panel123" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout81" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="Label35" runat="server" HideLabel="true" Html="植入时间" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="Replace1Implant" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="Replace2Implant" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="Replace3Implant" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="Replace4Implant" runat="server" Width="200" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:DateField ID="Replace5Implant" runat="server" Width="200" HideLabel="true" />
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
                                <ext:FieldSet ID="FieldSet8" runat="server" Header="true" Frame="false" BodyBorder="true"
                                    AutoHeight="true" AutoWidth="true">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout7" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel124" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout34" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel125" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout82" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Panel ID="Panel126" runat="server" Header="false" Frame="false" BodyBorder="false"
                                                                                    AutoHeight="true">
                                                                                    <Body>
                                                                                        <b style="font-size: 14px;">9. 产品体验详细的事件描述或临床观察（事件描述尽量详细，包括上报的临床观察，发生事件的时间和地点，故障排除的结果，设备或者电极的参数，病人的影响以及最后的手术结果）</b>
                                                                                    </Body>
                                                                                </ext:Panel>
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
                                                <ext:Panel ID="Panel127" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout35" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel128" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout83" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextArea ID="ProductExpDetail" runat="server" HideLabel="true" Width="1000"
                                                                                    AllowBlank="false" BlankText="请填写【9.产品体验详细的事件描述或临床观察】" Cls="lightyellow-row" />
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
                                <ext:FieldSet ID="FieldSet9" runat="server" Header="true" Frame="false" BodyBorder="true"
                                    AutoHeight="true" AutoWidth="true">
                                    <Body>
                                        <ext:RowLayout ID="RowLayout8" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel129" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout36" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel130" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout84" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:Panel ID="Panel131" runat="server" Header="false" Frame="false" BodyBorder="false"
                                                                                    AutoHeight="true">
                                                                                    <Body>
                                                                                        <b style="font-size: 14px;">10. 客户意见/扩展需求</b>
                                                                                    </Body>
                                                                                </ext:Panel>
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
                                                <ext:Panel ID="Panel132" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout37" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel133" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout85" runat="server" LabelAlign="Left" LabelWidth="160">
                                                                            <ext:Anchor>
                                                                                <ext:TextArea ID="CustomerComment" runat="server" HideLabel="true" Width="1000" />
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
                                        <ext:RowLayout ID="RowLayout10" runat="server">
                                            <ext:LayoutRow>
                                                <ext:Panel ID="Panel111" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout29" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel112" runat="server" Border="false" Header="false">
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
                <Click Handler="CheckCRMSubmit();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="CancelButton" runat="server" Text="<%$ Resources: DetailWindow.CancelButton.Text %>"
            Icon="Delete">
            <Listeners>
                <Click Handler="CancelCRMSubmit();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="ConfirmCRMButton" runat="server" Text="确认收货" Icon="LorryAdd">
            <Listeners>
                <Click Handler="ConfirmCRMSubmit();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="DeliverToCRMButton" runat="server" Text="快递单号" Icon="LorryAdd">
            <Listeners>
                <Click Handler="Coolite.AjaxMethods.DealerComplainCRMEdit.ShowCRMCarrierWindow();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="DeleteButton" runat="server" Text="<%$ Resources: DetailWindow.DeleteButton.Text %>"
            Icon="Cancel">
            <Listeners>
                <Click Handler="CloseCRMWindow();" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
<ext:Window ID="windowCRMCarrier" runat="server" Icon="Group" Title="填写快递单号" Resizable="false"
    Header="false" Width="390" Height="180" AutoShow="false" Modal="true" ShowOnLoad="false"
    BodyStyle="padding:5px;">
    <Body>
        <ext:FormLayout ID="FormLayout2" runat="server">
            <ext:Anchor>
                <ext:Panel ID="Panel5" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="Panel7" runat="server" Border="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout3" runat="server" LabelWidth="100">
                                            <ext:Anchor>
                                                <ext:TextField ID="tbCRMRemark" runat="server" FieldLabel="快递单号" Width="200" />
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
                <Click Handler="Coolite.AjaxMethods.DealerComplainCRMEdit.SubmitCRMCarrier({success:function(){Ext.Msg.alert('Success', msgBSCList.msg4);RefreshMainPage();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnCRMCarrierCancel" runat="server" Text="取消" Icon="Delete">
            <Listeners>
                <Click Handler="#{windowCRMCarrier}.hide();" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
