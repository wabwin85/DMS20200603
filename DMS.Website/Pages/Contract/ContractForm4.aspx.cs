using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using DMS.Business;
using Coolite.Ext.Web;
using DMS.Model.Data;
using System.Collections;
using DMS.Model;
using DMS.Common;

namespace DMS.Website.Pages.Contract
{
    using iTextSharp.text.pdf;
    using iTextSharp.text;
    using System.IO;
    using System.Reflection;
    using Lafite.RoleModel.Security;
    using Microsoft.Practices.Unity;
    using DMS.Model.Data;
    using DMS.Business;
    using System.Text.RegularExpressions;
    using DMS.Business.Contract;

    public partial class ContractForm4 : BasePage
    {
        #region Definition
        IRoleModelContext _context = RoleModelContext.Current;
        private IContractMaster _contract = new DMS.Business.ContractMaster();
        private ContractMasterDM conMast = null;
        private IContractAppointmentService _appointment = new ContractAppointmentService();
        private IContractRenewalService _Renewal = new DMS.Business.ContractRenewalService();
        private Regex regChinese = new Regex("[\u4e00-\u9fa5]");
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (Request.QueryString["CmId"] != null && Request.QueryString["CmStatus"] != null && Request.QueryString["DealerId"] != null && Request.QueryString["DealerCnName"] != null && Request.QueryString["ContStatus"] != null)
                {
                    this.hdCmId.Value = Request.QueryString["CmId"];
                    this.hdCmStatus.Value = Request.QueryString["CmStatus"];
                    this.hdDealerId.Value = Request.QueryString["DealerId"];
                    this.hdDealerCnName.Value = Request.QueryString["DealerCnName"];
                    this.hdContStatus.Value = Request.QueryString["ContStatus"];
                    this.hdContId.Value = Request.QueryString["ContId"];

                    if (Session["conMast"] != null)
                    {
                        conMast = Session["conMast"] as ContractMasterDM;
                    }
                    BindMainData();
                    PagePermissions();
                }
                if (!RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                {
                    btnCreatePdf.Enabled = false;
                }
            }
        }

        [AjaxMethod]
        public void SaveDraft()
        {
            try
            {
                string massage = "";
                if (!PageCheck(ref  massage))
                {
                    Ext.Msg.Alert("Error", massage).Show();
                }
                else
                {
                    SaveDate(ContractMastreStatus.Draft.ToString());
                    Ext.Msg.Alert("Success", "保存草稿成功").Show();
                }
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }

        [AjaxMethod]
        public void SaveSubmit()
        {
            try
            {
                 string massage="";
                 if (!PageCheck(ref  massage))
                 {
                     Ext.Msg.Alert("Error", massage).Show();
                 }
                 else
                 {

                     SaveDate(ContractMastreStatus.Submit.ToString());
                     Ext.Msg.Alert("Success", "提交成功").Show();
                 }
            }
            catch (Exception ex) 
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }

        private void BindMainData()
        {
            IDealerMasters bll = new DealerMasters();
            DealerMaster dm = new DealerMaster();
            dm.Id = new Guid(this.hdDealerId.Value.ToString());
            IList<DealerMaster> listDm = bll.QueryForDealerMaster(dm);

            if (conMast != null)
            {
                //if (String.IsNullOrEmpty(conMast.CmDealerEnName))
                //{
                //    tfFrom4DealerName.Text = this.hdDealerCnName.Value.ToString();
                //}
                //else
                //{
                //    tfFrom4DealerName.Text = conMast.CmDealerEnName;
                //}
                
                tfFrom4Assesser.Text = conMast.CmForm4AssessName;
                if (conMast.CmForm4AssessDate != null)
                {
                    tfFrom4AssessDate.Value = Convert.ToDateTime(conMast.CmForm4AssessDate).ToShortDateString();
                }
                tfFrom4Country.Text = conMast.CmForm4Country;
                BindRadioChoice(conMast.CmQualityStoreProperty1, this.radioQualityStore1No, this.radioQualityStore1Yes, this.radioQualityStore1NA, this.tfQualityStore1);
                this.tfQualityStore1.Text = conMast.CmQualityStoreDesc1;
                BindRadioChoice(conMast.CmQualityStoreProperty2, this.radioQualityStore2No, this.radioQualityStore2Yes, this.radioQualityStore2NA, this.tfQualityStore2);
                this.tfQualityStore2.Text = conMast.CmQualityStoreDesc2;
                BindRadioChoice(conMast.CmQualityStoreProperty3, this.radioQualityStore3No, this.radioQualityStore3Yes, this.radioQualityStore3NA, this.tfQualityStore3);
                this.tfQualityStore3.Text = conMast.CmQualityStoreDesc3;
                BindRadioChoice(conMast.CmQualityStoreProperty4, this.radioQualityStore4No, this.radioQualityStore4Yes, this.radioQualityStore4NA, this.tfQualityStore4);
                this.tfQualityStore4.Text = conMast.CmQualityStoreDesc4;
                BindRadioChoice(conMast.CmQualityStoreProperty5, this.radioQualityStore5No, this.radioQualityStore5Yes, this.radioQualityStore5NA, this.tfQualityStore5);
                this.tfQualityStore5.Text = conMast.CmQualityStoreDesc5;

                BindRadioChoice(conMast.CmQualityTraceabilityProperty1, this.radioQualityTraceability1No, this.radioQualityTraceability1Yes, this.radioQualityTraceability1NA, this.tfQualityTraceability1);
                this.tfQualityTraceability1.Text = conMast.CmQualityTraceabilityDesc1;
                BindRadioChoice(conMast.CmQualityTraceabilityProperty2, this.radioQualityTraceability2No, this.radioQualityTraceability2Yes, this.radioQualityTraceability2NA, this.tfQualityTraceability2);
                this.tfQualityTraceability2.Text = conMast.CmQualityTraceabilityDesc2;
                BindRadioChoice(conMast.CmQualityTraceabilityProperty3, this.radioQualityTraceability3No, this.radioQualityTraceability3Yes, this.radioQualityTraceability3NA, this.tfQualityTraceability3);
                this.tfQualityTraceability3.Text = conMast.CmQualityTraceabilityDesc3;
                BindRadioChoice(conMast.CmQualityTraceabilityProperty4, this.radioQualityTraceability4No, this.radioQualityTraceability4Yes, this.radioQualityTraceability4NA, this.tfQualityTraceability4);
                this.tfQualityTraceability4.Text = conMast.CmQualityTraceabilityDesc4;

                BindRadioChoice(conMast.CmQualityImplantedProperty1, this.radioQualityImplanted1No, this.radioQualityImplanted1Yes, this.radioQualityImplanted1NA, this.tfQualityImplanted1);
                this.tfQualityImplanted1.Text = conMast.CmQualityImplantedDesc1;

                BindRadioChoice(conMast.CmQualityMaintainProperty1, this.radioQualityMaintain1No, this.radioQualityMaintain1Yes, this.radioQualityMaintain1NA, this.tfQualityMaintain1);
                this.tfQualityMaintain1.Text = conMast.CmQualityMaintainDesc1;
                BindRadioChoice(conMast.CmQualityMaintainProperty2, this.radioQualityMaintain2No, this.radioQualityMaintain2Yes, this.radioQualityMaintain2NA, this.tfQualityMaintain2);
                this.tfQualityMaintain2.Text = conMast.CmQualityMaintainDesc2;

                BindRadioChoice(conMast.CmQualityComplainProperty1, this.radioQualityComplain1No, this.radioQualityComplain1Yes, this.radioQualityComplain1NA, this.tfQualityComplain1);
                this.tfQualityComplain1.Text = conMast.CmQualityComplainDesc1;
                BindRadioChoice(conMast.CmQualityComplainProperty2, this.radioQualityComplain2No, this.radioQualityComplain2Yes, this.radioQualityComplain2NA, this.tfQualityComplain2);
                this.tfQualityComplain2.Text = conMast.CmQualityComplainDesc2;
                BindRadioChoice(conMast.CmQualityComplainProperty3, this.radioQualityComplain3No, this.radioQualityComplain3Yes, this.radioQualityComplain3NA, this.tfQualityComplain3);
                this.tfQualityComplain3.Text = conMast.CmQualityComplainDesc3;
                BindRadioChoice(conMast.CmQualityComplainProperty4, this.radioQualityComplain4No, this.radioQualityComplain4Yes, this.radioQualityComplain4NA, this.tfQualityComplain4);
                this.tfQualityComplain4.Text = conMast.CmQualityComplainDesc4;

                BindRadioChoice(conMast.CmQualityDisposeProperty1, this.radioQualityDispose1No, this.radioQualityDispose1Yes, this.radioQualityDispose1NA, this.tfQualityDispose1);
                this.tfQualityDispose1.Text = conMast.CmQualityDisposeDesc1;
                BindRadioChoice(conMast.CmQualityDisposeProperty2, this.radioQualityDispose2No, this.radioQualityDispose2Yes, this.radioQualityDispose2NA, this.tfQualityDispose2);
                this.tfQualityDispose2.Text = conMast.CmQualityDisposeDesc2;
                BindRadioChoice(conMast.CmQualityDisposeProperty3, this.radioQualityDispose3No, this.radioQualityDispose3Yes, this.radioQualityDispose3NA, this.tfQualityDispose3);
                this.tfQualityDispose3.Text = conMast.CmQualityDisposeDesc3;

                BindRadioChoice(conMast.CmQualityGuardProperty1, this.radioQualityGuard1No, this.radioQualityGuard1Yes, this.radioQualityGuard1NA, this.tfQualityGuard1);
                this.tfQualityGuard1.Text = conMast.CmQualityGuardDesc1;
                BindRadioChoice(conMast.CmQualityGuardProperty2, this.radioQualityGuard2No, this.radioQualityGuard2Yes, this.radioQualityGuard2NA, this.tfQualityGuard2);
                this.tfQualityGuard2.Text = conMast.CmQualityGuardDesc2;

                BindRadioChoice(conMast.CmQualityRecallProperty1, this.radioQualityRecall1No, this.radioQualityRecall1Yes, this.radioQualityRecall1NA, this.tfQualityRecall1);
                this.tfQualityRecall1.Text = conMast.CmQualityRecallDesc1;
                BindRadioChoice(conMast.CmQualityRecallProperty2, this.radioQualityRecall2No, this.radioQualityRecall2Yes, this.radioQualityRecall2NA, this.tfQualityRecall2);
                this.tfQualityRecall2.Text = conMast.CmQualityRecallDesc2;
                BindRadioChoice(conMast.CmQualityRecallProperty3, this.radioQualityRecall3No, this.radioQualityRecall3Yes, this.radioQualityRecall3NA, this.tfQualityRecall3);
                this.tfQualityRecall3.Text = conMast.CmQualityRecallDesc3;
                BindRadioChoice(conMast.CmQualityRecallProperty4, this.radioQualityRecall4No, this.radioQualityRecall4Yes, this.radioQualityRecall4NA, this.tfQualityRecall4);
                this.tfQualityRecall4.Text = conMast.CmQualityRecallDesc4;
                BindRadioChoice(conMast.CmQualityRecallProperty5, this.radioQualityRecall5No, this.radioQualityRecall5Yes, this.radioQualityRecall5NA, this.tfQualityRecall5);
                this.tfQualityRecall5.Text = conMast.CmQualityRecallDesc5;
                BindRadioChoice(conMast.CmQualityRecallProperty6, this.radioQualityRecall6No, this.radioQualityRecall6Yes, this.radioQualityRecall6NA, this.tfQualityRecall6);
                this.tfQualityRecall6.Text = conMast.CmQualityRecallDesc6;

                BindRadioChoice(conMast.CmQualityExampleProperty1, this.radioQualityExample1No, this.radioQualityExample1Yes, this.radioQualityExample1NA, this.tfQualityExample1);
                this.tfQualityExample1.Text = conMast.CmQualityExampleDesc1;

                BindRadioChoice(conMast.CmQualityLableProperty1, this.radioQualityLable1No, this.radioQualityLable1Yes, this.radioQualityLable1NA, this.tfQualityLable1);
                this.tfQualityLable1.Text = conMast.CmQualityLableDesc1;

                BindRadioChoice(conMast.CmQualityTrainProperty1, this.radioQualityTrain1No, this.radioQualityTrain1Yes, this.radioQualityTrain1NA, this.tfQualityTrain1);
                this.tfQualityTrain1.Text = conMast.CmQualityTrainDesc1;

                BindRadioChoice(conMast.CmQualityRecordProperty1, this.radioQualityRecord1No, this.radioQualityRecord1Yes, this.radioQualityRecord1NA, this.tfQualityRecord1);
                this.tfQualityRecord1.Text = conMast.CmQualityRecordDesc1;
            }

            if (listDm.Count > 0)
            {
                DealerMaster getDealerMaster = listDm[0];
                this.tfFrom4DealerName.Text = getDealerMaster.EnglishName;
            }
        }

        private void SaveDate(string cmStatus) 
        {
            try
            {
                ContractMasterDM contract = new ContractMasterDM();
                contract.CmId = new Guid(this.hdCmId.Value.ToString());
                contract.CmDealerEnName = tfFrom4DealerName.Text;
                contract.CmForm4AssessName = tfFrom4Assesser.Text;
                if (tfFrom4AssessDate != null)
                {
                    contract.CmForm4AssessDate = Convert.ToDateTime(tfFrom4AssessDate.Value);
                }
                else { contract.CmForm4AssessDate = null; }
                contract.CmForm4Country = tfFrom4Country.Text;
                contract.CmDmaId =new Guid(this.hdDealerId.Value.ToString());//new Guid(RoleModelContext.Current.User.CorpId.Value.ToString());

                #region From4RadioChoice
                contract.CmQualityStoreProperty1 = GetRadioChoice(this.radioQualityStore1No, this.radioQualityStore1Yes, this.radioQualityStore1NA).ToString();
                contract.CmQualityStoreProperty2 = GetRadioChoice(this.radioQualityStore2No, this.radioQualityStore2Yes, this.radioQualityStore2NA).ToString();
                contract.CmQualityStoreProperty3 = GetRadioChoice(this.radioQualityStore3No, this.radioQualityStore3Yes, this.radioQualityStore3NA).ToString();
                contract.CmQualityStoreProperty4 = GetRadioChoice(this.radioQualityStore4No, this.radioQualityStore4Yes, this.radioQualityStore4NA).ToString();
                contract.CmQualityStoreProperty5 = GetRadioChoice(this.radioQualityStore5No, this.radioQualityStore5Yes, this.radioQualityStore5NA).ToString();
                contract.CmQualityStoreDesc1 = this.tfQualityStore1.Text;
                contract.CmQualityStoreDesc2 = this.tfQualityStore2.Text;
                contract.CmQualityStoreDesc3 = this.tfQualityStore3.Text;
                contract.CmQualityStoreDesc4 = this.tfQualityStore4.Text;
                contract.CmQualityStoreDesc5 = this.tfQualityStore5.Text;

                contract.CmQualityTraceabilityProperty1 = GetRadioChoice(this.radioQualityTraceability1No, this.radioQualityTraceability1Yes, this.radioQualityTraceability1NA).ToString();
                contract.CmQualityTraceabilityProperty2 = GetRadioChoice(this.radioQualityTraceability2No, this.radioQualityTraceability2Yes, this.radioQualityTraceability2NA).ToString();
                contract.CmQualityTraceabilityProperty3 = GetRadioChoice(this.radioQualityTraceability3No, this.radioQualityTraceability3Yes, this.radioQualityTraceability3NA).ToString();
                contract.CmQualityTraceabilityProperty4 = GetRadioChoice(this.radioQualityTraceability4No, this.radioQualityTraceability4Yes, this.radioQualityTraceability4NA).ToString();
                contract.CmQualityTraceabilityDesc1 = this.tfQualityTraceability1.Text;
                contract.CmQualityTraceabilityDesc2 = this.tfQualityTraceability2.Text;
                contract.CmQualityTraceabilityDesc3 = this.tfQualityTraceability3.Text;
                contract.CmQualityTraceabilityDesc4 = this.tfQualityTraceability4.Text;

                contract.CmQualityImplantedProperty1 = GetRadioChoice(this.radioQualityImplanted1No, this.radioQualityImplanted1Yes, this.radioQualityImplanted1NA).ToString();
                contract.CmQualityImplantedDesc1 = this.tfQualityImplanted1.Text;

                contract.CmQualityMaintainProperty1 = GetRadioChoice(this.radioQualityMaintain1No, this.radioQualityMaintain1Yes, this.radioQualityMaintain1NA).ToString();
                contract.CmQualityMaintainProperty2 = GetRadioChoice(this.radioQualityMaintain2No, this.radioQualityMaintain2Yes, this.radioQualityMaintain2NA).ToString();
                contract.CmQualityMaintainDesc1 = this.tfQualityMaintain1.Text;
                contract.CmQualityMaintainDesc2 = this.tfQualityMaintain2.Text;

                contract.CmQualityComplainProperty1 = GetRadioChoice(this.radioQualityComplain1No, this.radioQualityComplain1Yes, this.radioQualityComplain1NA).ToString();
                contract.CmQualityComplainProperty2 = GetRadioChoice(this.radioQualityComplain2No, this.radioQualityComplain2Yes, this.radioQualityComplain2NA).ToString();
                contract.CmQualityComplainProperty3 = GetRadioChoice(this.radioQualityComplain3No, this.radioQualityComplain3Yes, this.radioQualityComplain3NA).ToString();
                contract.CmQualityComplainProperty4 = GetRadioChoice(this.radioQualityComplain4No, this.radioQualityComplain4Yes, this.radioQualityComplain4NA).ToString();
                contract.CmQualityComplainDesc1 = this.tfQualityComplain1.Text;
                contract.CmQualityComplainDesc2 = this.tfQualityComplain2.Text;
                contract.CmQualityComplainDesc3 = this.tfQualityComplain3.Text;
                contract.CmQualityComplainDesc4 = this.tfQualityComplain4.Text;

                contract.CmQualityDisposeProperty1 = GetRadioChoice(this.radioQualityDispose1No, this.radioQualityDispose1Yes, this.radioQualityDispose1NA).ToString();
                contract.CmQualityDisposeProperty2 = GetRadioChoice(this.radioQualityDispose2No, this.radioQualityDispose2Yes, this.radioQualityDispose2NA).ToString();
                contract.CmQualityDisposeProperty3 = GetRadioChoice(this.radioQualityDispose3No, this.radioQualityDispose3Yes, this.radioQualityDispose3NA).ToString();
                contract.CmQualityDisposeDesc1 = this.tfQualityDispose1.Text;
                contract.CmQualityDisposeDesc2 = this.tfQualityDispose2.Text;
                contract.CmQualityDisposeDesc3 = this.tfQualityDispose3.Text;

                contract.CmQualityGuardProperty1 = GetRadioChoice(this.radioQualityGuard1No, this.radioQualityGuard1Yes, this.radioQualityGuard1NA).ToString();
                contract.CmQualityGuardProperty2 = GetRadioChoice(this.radioQualityGuard2No, this.radioQualityGuard2Yes, this.radioQualityGuard2NA).ToString();
                contract.CmQualityGuardDesc1 = this.tfQualityGuard1.Text;
                contract.CmQualityGuardDesc2 = this.tfQualityGuard2.Text;

                contract.CmQualityRecallProperty1 = GetRadioChoice(this.radioQualityRecall1No, this.radioQualityRecall1Yes, this.radioQualityRecall1NA).ToString();
                contract.CmQualityRecallProperty2 = GetRadioChoice(this.radioQualityRecall2No, this.radioQualityRecall2Yes, this.radioQualityRecall2NA).ToString();
                contract.CmQualityRecallProperty3 = GetRadioChoice(this.radioQualityRecall3No, this.radioQualityRecall3Yes, this.radioQualityRecall3NA).ToString();
                contract.CmQualityRecallProperty4 = GetRadioChoice(this.radioQualityRecall4No, this.radioQualityRecall4Yes, this.radioQualityRecall4NA).ToString();
                contract.CmQualityRecallProperty5 = GetRadioChoice(this.radioQualityRecall5No, this.radioQualityRecall5Yes, this.radioQualityRecall5NA).ToString();
                contract.CmQualityRecallProperty6 = GetRadioChoice(this.radioQualityRecall6No, this.radioQualityRecall6Yes, this.radioQualityRecall6NA).ToString();
                contract.CmQualityRecallDesc1 = this.tfQualityRecall1.Text;
                contract.CmQualityRecallDesc2 = this.tfQualityRecall2.Text;
                contract.CmQualityRecallDesc3 = this.tfQualityRecall3.Text;
                contract.CmQualityRecallDesc4 = this.tfQualityRecall4.Text;
                contract.CmQualityRecallDesc5 = this.tfQualityRecall5.Text;
                contract.CmQualityRecallDesc6 = this.tfQualityRecall6.Text;

                contract.CmQualityExampleProperty1 = GetRadioChoice(this.radioQualityExample1No, this.radioQualityExample1Yes, this.radioQualityExample1NA).ToString();
                contract.CmQualityExampleDesc1 = this.tfQualityExample1.Text;

                contract.CmQualityLableProperty1 = GetRadioChoice(this.radioQualityLable1No, this.radioQualityLable1Yes, this.radioQualityLable1NA).ToString();
                contract.CmQualityLableDesc1 = this.tfQualityLable1.Text;

                contract.CmQualityTrainProperty1 = GetRadioChoice(this.radioQualityTrain1No, this.radioQualityTrain1Yes, this.radioQualityTrain1NA).ToString();
                contract.CmQualityTrainDesc1 = this.tfQualityTrain1.Text;

                contract.CmQualityRecordProperty1 = GetRadioChoice(this.radioQualityRecord1No, this.radioQualityRecord1Yes, this.radioQualityRecord1NA).ToString();
                contract.CmQualityRecordDesc1 = this.tfQualityRecord1.Text;
                #endregion

                contract.CmStatus = cmStatus;
                if (Session["PageOperationType"] != null && (string)Session["PageOperationType"] == PageOperationType.EDIT.ToString())
                {
                    _contract.UpdateContractFrom4(contract);
                }
                else if (Session["PageOperationType"] != null && (string)Session["PageOperationType"] == PageOperationType.INSERT.ToString())
                {
                    _contract.InsertContractFrom4(contract);
                    Session["PageOperationType"] = PageOperationType.EDIT.ToString();
                }

                Hashtable htCon = new Hashtable();
                htCon.Add("CapId", this.hdContId.Value);
                htCon.Add("CapCmId", this.hdCmId.Value);
                _appointment.UpdateAppointmentCmidByConid(htCon);

                htCon.Add("CreId", this.hdContId.Value);
                htCon.Add("CreCmId", this.hdCmId.Value);
                _Renewal.UpdateRenewalCmidByConid(htCon);

                Session["From4"] = true;
            }
            catch (Exception ex) 
            {
                throw ex;
            }

        }

        private void PagePermissions()
        {
            if (Session["PageOperationType"] == null)
            {
                //合同主表数据未维护，并且登录人并不是“一级经销商”或者“设备经销商”，只能查看空页面
                this.btnSaveDraft.Hidden = true;
            }

            if (this.hdCmStatus.Value.ToString().Equals(ContractMastreStatus.Submit.ToString()))
            {
                this.btnSaveDraft.Hidden = true;
                if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation) 
                    && !this.hdContStatus.Value.Equals(ContractStatus.Completed.ToString())
                    && !this.hdContStatus.Value.Equals(ContractStatus.COSubmitPDF.ToString())
                    && !this.hdContStatus.Value.Equals(ContractStatus.Reject.ToString())
                    )
                {
                    this.btnSubmit.Hidden = false;
                }
            }
            else 
            {
                if (!IsDealer)
                {
                    this.btnSaveDraft.Hidden = true;
                }
            }
        }

        private void BindRadioChoice(object value, Radio radioNo, Radio radioYes, Radio radioNa,Coolite.Ext.Web.TextField text) 
        {
            try
            {
                if (value != null)
                {
                    switch (value.ToString())
                    {
                        case "0":
                            radioNo.Checked = true;
                            break;
                        case "1":
                            radioYes.Checked = true;
                            //text.Enabled = false;
                            break;
                        case "2":
                            radioNa.Checked = true;
                            break;
                    }
                }
            }
            catch (Exception ex) 
            {
                throw ex;
            }
        }

        private object GetRadioChoice(Radio radioNo, Radio radioYes, Radio radioNa)
        {
            try
            {
                if (radioNo.Checked)
                {
                    return "0";
                }
                if (radioYes.Checked)
                {
                    return "1";
                }
                if (radioNa.Checked)
                {
                    return "2";
                }
                else
                {
                    return "";
                }
            }
            catch (Exception ex) 
            {
                throw ex;
            }
        }

        private bool PageCheck(ref string massage)
        {
            //if (this.tfFrom4DealerName.Text.Equals(""))
            //{
            //    massage += "请填写第三方名称<br/>";
            //}
            //else if (regChinese.IsMatch(this.tfFrom4DealerName.Text))
            //{
            //    massage = "请使用英文填写第三方名称<br/>";
            //}
            if (!this.tfFrom4Assesser.Text.Equals("") && regChinese.IsMatch(this.tfFrom4Assesser.Text)) 
            {
                massage += "请使用英文填写评估人姓名<br/>";
            }
            if (!this.tfFrom4Country.Text.Equals("") && regChinese.IsMatch(this.tfFrom4Country.Text))
            {
                massage += "请使用英文填写国家<br/>";
            }

            if (((radioQualityStore1No.Checked || radioQualityStore1NA.Checked) && tfQualityStore1.Text.Equals("")) ||
                ((radioQualityStore2No.Checked || radioQualityStore2NA.Checked) && tfQualityStore2.Text.Equals("")) || 
                ((radioQualityStore3No.Checked || radioQualityStore3NA.Checked) && tfQualityStore3.Text.Equals("")) || 
                ((radioQualityStore4No.Checked || radioQualityStore4NA.Checked) && tfQualityStore4.Text.Equals("")) || 
                ((radioQualityStore5No.Checked || radioQualityStore5NA.Checked) && tfQualityStore5.Text.Equals("")) || 
                ((radioQualityTraceability1No.Checked || radioQualityTraceability1NA.Checked) && tfQualityTraceability1.Text.Equals("")) || 
                ((radioQualityTraceability2No.Checked || radioQualityTraceability2NA.Checked) && tfQualityTraceability2.Text.Equals("")) || 
                ((radioQualityTraceability3No.Checked || radioQualityTraceability3NA.Checked) && tfQualityTraceability3.Text.Equals("")) || 
                ((radioQualityTraceability4No.Checked || radioQualityTraceability4NA.Checked) && tfQualityTraceability4.Text.Equals("")) || 
                ((radioQualityImplanted1No.Checked || radioQualityImplanted1NA.Checked) && tfQualityImplanted1.Text.Equals("")) || 
                ((radioQualityMaintain1No.Checked || radioQualityMaintain1NA.Checked) && tfQualityMaintain1.Text.Equals("")) || 
                ((radioQualityMaintain2No.Checked || radioQualityMaintain2NA.Checked) && tfQualityMaintain2.Text.Equals("")) || 
                ((radioQualityComplain1No.Checked || radioQualityComplain1NA.Checked) && tfQualityComplain1.Text.Equals("")) || 
                ((radioQualityComplain2No.Checked || radioQualityComplain2NA.Checked) && tfQualityComplain2.Text.Equals("")) || 
                ((radioQualityComplain3No.Checked || radioQualityComplain3NA.Checked) && tfQualityComplain3.Text.Equals("")) || 
                ((radioQualityComplain4No.Checked || radioQualityComplain4NA.Checked) && tfQualityComplain4.Text.Equals("")) || 
                ((radioQualityDispose1No.Checked || radioQualityDispose1NA.Checked) && tfQualityDispose1.Text.Equals("")) || 
                ((radioQualityDispose2No.Checked || radioQualityDispose2NA.Checked) && tfQualityDispose2.Text.Equals("")) || 
                ((radioQualityDispose3No.Checked || radioQualityDispose3NA.Checked) && tfQualityDispose3.Text.Equals("")) || 
                ((radioQualityGuard1No.Checked || radioQualityGuard1NA.Checked) && tfQualityGuard1.Text.Equals("")) || 
                ((radioQualityGuard2No.Checked || radioQualityGuard2NA.Checked) && tfQualityGuard2.Text.Equals("")) || 
                ((radioQualityRecall1No.Checked || radioQualityRecall1NA.Checked) && tfQualityRecall1.Text.Equals("")) || 
                ((radioQualityRecall2No.Checked || radioQualityRecall2NA.Checked) && tfQualityRecall2.Text.Equals("")) || 
                ((radioQualityRecall3No.Checked || radioQualityRecall3NA.Checked) && tfQualityRecall3.Text.Equals("")) || 
                ((radioQualityRecall4No.Checked || radioQualityRecall4NA.Checked) && tfQualityRecall4.Text.Equals("")) || 
                ((radioQualityRecall5No.Checked || radioQualityRecall5NA.Checked) && tfQualityRecall5.Text.Equals("")) || 
                ((radioQualityRecall6No.Checked || radioQualityRecall6NA.Checked) && tfQualityRecall6.Text.Equals("")) || 
                ((radioQualityExample1No.Checked || radioQualityExample1NA.Checked) && tfQualityExample1.Text.Equals("")) || 
                ((radioQualityLable1No.Checked || radioQualityLable1NA.Checked) && tfQualityLable1.Text.Equals("")) || 
                ((radioQualityTrain1No.Checked || radioQualityTrain1NA.Checked) && tfQualityTrain1.Text.Equals("")) || 
                ((radioQualityRecord1No.Checked || radioQualityRecord1NA.Checked) && tfQualityRecord1.Text.Equals("")) )

            {
                massage += "选择'否'或'不适用',必须填写备注信息<br/>";
            }

            if ((!this.tfQualityStore1.Text.Equals("") && regChinese.IsMatch(this.tfQualityStore1.Text)) ||
                (!this.tfQualityStore2.Text.Equals("") && regChinese.IsMatch(this.tfQualityStore2.Text)) ||
                (!this.tfQualityStore3.Text.Equals("") && regChinese.IsMatch(this.tfQualityStore3.Text)) ||
                (!this.tfQualityStore4.Text.Equals("") && regChinese.IsMatch(this.tfQualityStore4.Text)) ||
                (!this.tfQualityStore5.Text.Equals("") && regChinese.IsMatch(this.tfQualityStore5.Text)) ||
                (!this.tfQualityTraceability1.Text.Equals("") && regChinese.IsMatch(this.tfQualityTraceability1.Text)) ||
                (!this.tfQualityTraceability2.Text.Equals("") && regChinese.IsMatch(this.tfQualityTraceability2.Text)) ||
                (!this.tfQualityTraceability3.Text.Equals("") && regChinese.IsMatch(this.tfQualityTraceability3.Text)) ||
                (!this.tfQualityTraceability4.Text.Equals("") && regChinese.IsMatch(this.tfQualityTraceability4.Text)) ||
                (!this.tfQualityImplanted1.Text.Equals("") && regChinese.IsMatch(this.tfQualityImplanted1.Text)) ||
                (!this.tfQualityMaintain1.Text.Equals("") && regChinese.IsMatch(this.tfQualityMaintain1.Text)) ||
                (!this.tfQualityMaintain2.Text.Equals("") && regChinese.IsMatch(this.tfQualityMaintain2.Text)) ||
                (!this.tfQualityComplain1.Text.Equals("") && regChinese.IsMatch(this.tfQualityComplain1.Text)) ||
                (!this.tfQualityComplain2.Text.Equals("") && regChinese.IsMatch(this.tfQualityComplain2.Text)) ||
                (!this.tfQualityComplain3.Text.Equals("") && regChinese.IsMatch(this.tfQualityComplain3.Text)) ||
                (!this.tfQualityComplain4.Text.Equals("") && regChinese.IsMatch(this.tfQualityComplain4.Text)) ||
                (!this.tfQualityDispose1.Text.Equals("") && regChinese.IsMatch(this.tfQualityDispose1.Text)) ||
                (!this.tfQualityDispose2.Text.Equals("") && regChinese.IsMatch(this.tfQualityDispose2.Text)) ||
                (!this.tfQualityDispose3.Text.Equals("") && regChinese.IsMatch(this.tfQualityDispose3.Text)) ||
                (!this.tfQualityGuard1.Text.Equals("") && regChinese.IsMatch(this.tfQualityGuard1.Text)) ||
                (!this.tfQualityGuard2.Text.Equals("") && regChinese.IsMatch(this.tfQualityGuard2.Text)) ||
                (!this.tfQualityRecall1.Text.Equals("") && regChinese.IsMatch(this.tfQualityRecall1.Text)) ||
                (!this.tfQualityRecall2.Text.Equals("") && regChinese.IsMatch(this.tfQualityRecall2.Text)) ||
                (!this.tfQualityRecall3.Text.Equals("") && regChinese.IsMatch(this.tfQualityRecall3.Text)) ||
                (!this.tfQualityRecall4.Text.Equals("") && regChinese.IsMatch(this.tfQualityRecall4.Text)) ||
                (!this.tfQualityRecall5.Text.Equals("") && regChinese.IsMatch(this.tfQualityRecall5.Text)) ||
                (!this.tfQualityRecall6.Text.Equals("") && regChinese.IsMatch(this.tfQualityRecall6.Text)) ||
                (!this.tfQualityExample1.Text.Equals("") && regChinese.IsMatch(this.tfQualityExample1.Text)) ||
                (!this.tfQualityLable1.Text.Equals("") && regChinese.IsMatch(this.tfQualityLable1.Text)) ||
                (!this.tfQualityTrain1.Text.Equals("") && regChinese.IsMatch(this.tfQualityTrain1.Text)) ||
                (!this.tfQualityRecord1.Text.Equals("") && regChinese.IsMatch(this.tfQualityRecord1.Text)))
            {
                massage += "请使用英文填写备注信息<br/>";
            }
            if (massage.Equals(""))
            {
                return true;
            }
            else 
            {
                massage = massage.Substring(0, massage.Length - 5);
                return false;
            }
            
        }

        #region Create IAF_Form_4 File
        protected void CreatePdf(object sender, EventArgs e)
        {
            Hashtable table = new Hashtable();
            table.Add("CmId", this.hdCmId.Value);
            conMast = _contract.GetContractMasterByCmID(table);

            string fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
            string targetPath = Server.MapPath(PdfHelper.FILE_PATH + fileName);

            Document doc = new Document(iTextSharp.text.PageSize.A4, 36, 36, 30, 12);
            try
            {
                //注册中文字库
                PdfHelper.RegisterChineseFont();
                PdfHelper pdfFont = new PdfHelper();
                
                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
                writer.PageEvent = new PdfPageEvent("069362, Rev AB", "Quality Self-Assessment Checklist, Rev AB", false);
                doc.Open();
                //doc.NewPage();

                #region Pdf Title

                //设置Title Tabel 
                PdfPTable titleTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(titleTable);

                //Pdf标题
                PdfPCell titleCell = new PdfPCell(new Paragraph("Form 4\r\nQuality Self-Assessment Checklist", PdfHelper.iafTitleGrayFont));
                titleCell.HorizontalAlignment = Rectangle.ALIGN_CENTER;
                titleCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                titleCell.PaddingBottom = 3f;
                titleCell.FixedHeight = 40.5f;
                titleCell.Border = 0;
                titleTable.AddCell(titleCell);

                //添加至pdf中
                PdfHelper.AddPdfTable(doc, titleTable);

                #endregion

                #region 副标题
                PdfPTable labelTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(labelTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("This Form to be used prior to the appointment or renewal of a Third Party (Dealers or Distributors)", PdfHelper.underLineFont)) { FixedHeight = 25f }, labelTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                Chunk chunk1 = new Chunk("Purpose:", FontFactory.GetFont("Arial", 9, Font.BOLD));
                Chunk chunk2 = new Chunk(" the purpose of this Quality Checklist is to confirm the capabilities of a Third Party to comply with Boston Scientific’s Quality requirements prior to appointment or renewal", FontFactory.GetFont("Arial", 9));
                Phrase phrase1 = new Phrase();
                phrase1.Add(chunk1);
                phrase1.Add(chunk2);

                Paragraph paragraph = new Paragraph();
                paragraph.Add(phrase1);

                PdfHelper.AddPdfCell(new PdfPCell(paragraph) { FixedHeight = 30f }, labelTable, Rectangle.ALIGN_LEFT, null);

                PdfHelper.AddPdfTable(doc, labelTable);

                #endregion

                #region 第三方信息
                PdfPTable thirdParyTable = new PdfPTable(4);
                thirdParyTable.SetWidths(new float[] { 20f, 30f, 20f, 30f });
                PdfHelper.InitPdfTableProperty(thirdParyTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Section to be filled in by the Third Party", FontFactory.GetFont("Arial", 9, BaseColor.WHITE))) { Colspan = 4, BackgroundColor = BaseColor.BLACK, BorderWidthLeft = 1f }, thirdParyTable, null, null);

                //Third Party Name
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Third Party:", PdfHelper.normalFont)) { FixedHeight = 15f, PaddingRight = 5f, BorderWidth = 0, BorderWidthLeft = 1f }, thirdParyTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(conMast.CmDealerEnName, PdfHelper.normalFont)) { BorderWidth = 0, BorderWidthBottom = 0.3f, PaddingRight = 5f }, thirdParyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                //Country
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Country:", PdfHelper.normalFont)) { FixedHeight = 15f, PaddingRight = 5f }, thirdParyTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("China", PdfHelper.normalFont)) { BorderWidth = 0, BorderWidthBottom = 0.3f, BorderWidthRight = 1f, PaddingRight = 5f }, thirdParyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                //Name of assessor:
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Name of assessor:", PdfHelper.normalFont)) { FixedHeight = 15f, PaddingRight = 5f, BorderWidth = 0, BorderWidthLeft = 1f }, thirdParyTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(conMast.CmForm4AssessName, PdfHelper.normalFont)) { BorderWidth = 0, BorderWidthBottom = 0.3f, PaddingRight = 5f }, thirdParyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                //Signature of assessor:
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Signature of assessor:", PdfHelper.normalFont)) { FixedHeight = 15f, PaddingRight = 5f }, thirdParyTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { BorderWidth = 0, BorderWidthBottom = 0.3f, BorderWidthRight = 1f, PaddingRight = 5f }, thirdParyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                //Date of assessment (dd-mmm-yyyy):
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Date of assessment\r\n (dd-mmm-yyyy):", PdfHelper.normalFont)) { FixedHeight = 25f, PaddingRight = 5f, BorderWidth = 0, BorderWidthLeft = 1f }, thirdParyTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(base.GetStringByDate(conMast.CmForm4AssessDate, null), PdfHelper.normalFont)) { BorderWidth = 0, BorderWidthBottom = 0.3f, PaddingRight = 5f }, thirdParyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddEmptyPdfCell(thirdParyTable);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { FixedHeight = 6f, PaddingRight = 5f, BorderWidth = 0, BorderWidthRight = 1f }, thirdParyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { FixedHeight = 6f, PaddingRight = 5f, BorderWidth = 0, BorderWidthLeft = 1f }, thirdParyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(thirdParyTable);
                PdfHelper.AddEmptyPdfCell(thirdParyTable);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { FixedHeight = 6f, PaddingRight = 5f, BorderWidth = 0, BorderWidthRight = 1f }, thirdParyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddPdfTable(doc, thirdParyTable);
                #endregion

                #region Page 1

                PdfPTable part1Table = new PdfPTable(4);
                part1Table.SetWidths(new float[] { 15f, 35f, 15f, 35f });
                PdfHelper.InitPdfTableProperty(part1Table);

                //Add Head
                this.AddHead(part1Table, false);

                #region Product storage
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("Product storage", PdfHelper.answerFont)) { BorderWidth = 0f, BorderWidthLeft = 1f, BorderWidthBottom = 0.6f, Rowspan = 5 }
                    , part1Table, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...storing product in a location secure, clean and pest free?", PdfHelper.normalFont)) { FixedHeight = 23f }
                    , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityStoreProperty1), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityStoreDesc1, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...dedicating a Boston Scientific product storage location limited to authorized personnel only?", PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityStoreProperty2), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityStoreDesc2, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...maintaining the environmental conditions specified on the product label or as defined by Boston Scientific?", PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityStoreProperty3), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityStoreDesc3, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...contacting Boston Scientific for guidance in case of environmental deviations?", PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityStoreProperty4), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityStoreDesc4, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...establishing a process to prevent expired, non-conforming, and/or quarantined Products from being sent to final customers?", PdfHelper.normalFont)) { BorderWidth = 0.3f }
                    , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityStoreProperty5), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityStoreDesc5, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);
                #endregion

                #region Product Traceability
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("Product Traceability", PdfHelper.answerFont)) { BorderWidth = 0f, BorderWidthLeft = 1f, BorderWidthBottom = 0.6f, Rowspan = 4 }
                    , part1Table, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...producing a complete and current list of all customers who have purchased or consigned products from Third Party?", PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityTraceabilityProperty1), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityTraceabilityDesc1, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...keeping the following minimum traceability data?\r\n• dates of purchases or consignment, \r\n• date of implant/attempted implant of active implantables and accessories,\r\n• quantity, \r\n• model number (as identified on the product label), \r\n• lot and/or serial numbers (as identified on the product label), and\r\n• UPNs (as identified on the product label). ", PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityTraceabilityProperty2), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityTraceabilityDesc2, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...keeping current and historical traceability records for programmers and other equipment locations and movements?", PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityTraceabilityProperty3), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityTraceabilityDesc3, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...reconciling consumed units at accounts with consignment inventory?", PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityTraceabilityProperty4), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityTraceabilityDesc4, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);
                #endregion

                #region Implant Reporting
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("Implant Reporting (to be completed by CRM and Neuromodulation Third Parties Only)", PdfHelper.answerFont)) { BorderWidth = 0f, BorderWidthLeft = 1f, BorderWidthBottom = 0.6f }
                    , part1Table, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...submitting implant registration forms in a timely fashion to Boston Scientific for all active implantable medical devices and their accessories?", PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityImplantedProperty1), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityImplantedDesc1, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);
                #endregion

                #region Equipment Maintenance and Software Updates
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("Equipment Maintenance and Software Updates", PdfHelper.answerFont)) { BorderWidth = 0f, BorderWidthLeft = 1f, BorderWidthBottom = 0.6f, Rowspan = 2 }
                    , part1Table, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...keeping programmers in good working order, and returning those requiring repair to Boston Scientific?", PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityMaintainProperty1), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityMaintainDesc1, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...updating software for programmers or capital equipment within the specified timeframe as directed by Boston Scientific?", PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityMaintainProperty2), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityMaintainDesc2, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);
                #endregion

                #region Complaint Reporting
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Complaint Reporting", PdfHelper.answerFont)) { BorderWidth = 0f, BorderWidthLeft = 1f, BorderWidthBottom = 0.6f, Rowspan = 4 }
                    , part1Table, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...reporting complaints to Boston Scientific within two business days?", PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityComplainProperty1), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityComplainDesc1, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...performing and documenting at least three due diligent attempts in cases where additional complaint information from the customer is required?", PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityComplainProperty2), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityComplainDesc2, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...returning complaint products to Boston Scientific?", PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityComplainProperty3), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityComplainDesc3, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...documenting at least three due dilligent attempts to retrieve a product if the customer indicated the product is available but has not returned it?", PdfHelper.normalFont))
                   , part1Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityComplainProperty4), PdfHelper.normalFont))
                    , part1Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityComplainDesc4, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part1Table, Rectangle.ALIGN_RIGHT, null);
                #endregion

                PdfHelper.AddPdfTable(doc, part1Table);

                #endregion

                #region Page 2
                doc.NewPage();

                PdfPTable part2Table = new PdfPTable(4);
                part2Table.SetWidths(new float[] { 15f, 35f, 15f, 35f });
                PdfHelper.InitPdfTableProperty(part2Table);
                //Add Head
                this.AddHead(part2Table, true);

                #region Handling Biohazardous or Hazardous Product Returns
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("Handling Biohazardous or Hazardous Product Returns", PdfHelper.answerFont)) { BorderWidth = 0f, BorderWidthLeft = 1f, BorderWidthBottom = 0.6f, Rowspan = 3 }
                    , part2Table, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...returning active Implantable Medical Devices and their Accessories in biohazard controlled packaging (as these are not to be decontaminated, disinfected or sterilized) and under safe handling controls?", PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityDisposeProperty1), PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityDisposeDesc1, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part2Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...accompanying Other Medical Devices by a disinfection certificate, even if the products have not been used, or returning them in biohazard controlled packaging and under safe handling controls?", PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityDisposeProperty2), PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityDisposeDesc2, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part2Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...returning Hazardous Products following Boston Scientific instructions?", PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityDisposeProperty3), PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityDisposeDesc3, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part2Table, Rectangle.ALIGN_RIGHT, null);
                #endregion

                #region Vigilance or other Medical Device Adverse Event Reporting
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("Vigilance or other Medical Device Adverse Event Reporting", PdfHelper.answerFont)) { BorderWidth = 0f, BorderWidthLeft = 1f, BorderWidthBottom = 0.6f, Rowspan = 2 }
                    , part2Table, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...submitting Vigilance or other Medical Device Adverse Event Reports to the Ministry of Health or applicable authority within the required timeframe?", PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityGuardProperty1), PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityGuardDesc1, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part2Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...informing Boston Scientific within a reasonable period of time of any changes to the vigilance or any other medical device adverse event reporting requirements within the Territory?", PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityGuardProperty2), PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityGuardDesc2, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part2Table, Rectangle.ALIGN_RIGHT, null);
                #endregion

                #region Recalls and Other Field Actions
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("Recalls and Other Field Actions", PdfHelper.answerFont)) { BorderWidth = 0f, BorderWidthLeft = 1f, BorderWidthBottom = 0.6f, Rowspan = 6 }
                    , part2Table, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...acting immediately upon receiving the notification packet for Recalls and other field actions from Boston Scientific? …sending an acknowledgement of the receipt of the field action notice to Boston Scientific?", PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityRecallProperty1), PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityRecallDesc1, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part2Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...following the instructions contained in the notification packet and ensuring that actions are carried out in accordance with the timeframe specified?", PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityRecallProperty2), PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityRecallDesc2, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part2Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...retrieving products from the following applicable locations?\r\n• Third Party warehouse(s) inventories\r\n• In-transit shipments from Boston Scientific to Third Party\r\n• Thid Party's Sales Reps inventory\r\n• Customer locations:  whether sold, consigned or samples", PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityRecallProperty3), PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityRecallDesc3, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part2Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("…performing at least three due diligent attempts to document that the customer has received the notification and has actioned upon instructions given by Boston Scientific?", PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityRecallProperty4), PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityRecallDesc4, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part2Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("...reporting recalled stock to Boston Scientific using the verification form contained in the notification packet once all product retrieval actions have been completed? ...matching quantities documented on the verification forms with the units physically returned to Boston Scientific?", PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityRecallProperty5), PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityRecallDesc5, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part2Table, Rectangle.ALIGN_RIGHT, null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("… returning products to Boston Scientific following the instructions contained in the notification packet?", PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityRecallProperty6), PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityRecallDesc6, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part2Table, Rectangle.ALIGN_RIGHT, null);
                #endregion

                #region Demonstration Units
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("Demonstration Units", PdfHelper.answerFont)) { BorderWidth = 0f, BorderWidthLeft = 1f, BorderWidthBottom = 0.6f }
                    , part2Table, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("... using Demonstration Units (non-sterile, not for human use) for demonstration purposes only and not giving them to final customers? (Nonfunctional implantable generators that do not contain a battery are the only demos that can be given to customers)  ", PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityExampleProperty1), PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityExampleDesc1, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part2Table, Rectangle.ALIGN_RIGHT, null);
                #endregion

                #region Label Control
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("Label Control", PdfHelper.answerFont)) { FixedHeight = 30f, BorderWidth = 0f, BorderWidthLeft = 1f, BorderWidthBottom = 0.6f }
                    , part2Table, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("…ensuring that product labeling fully meet local laws?  ", PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityLableProperty1), PdfHelper.normalFont))
                    , part2Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityLableDesc1, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part2Table, Rectangle.ALIGN_RIGHT, null);
                #endregion

                PdfHelper.AddPdfTable(doc, part2Table);
                #endregion

                #region Page 3
                doc.NewPage();

                PdfPTable part3Table = new PdfPTable(4);
                part3Table.SetWidths(new float[] { 15f, 35f, 15f, 35f });
                PdfHelper.InitPdfTableProperty(part3Table);
                //Add Head
                this.AddHead(part3Table, true);

                #region Training
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("Training", PdfHelper.answerFont)) { BorderWidth = 0f, BorderWidthLeft = 1f, BorderWidthBottom = 0.6f }
                    , part3Table, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase("…sending its employees directly engaged in selling the Products to attend a Boston Scientific technical training seminar or training those  employees in a program approved by Boston Scientific within a reasonable period of time?", PdfHelper.normalFont)) { BorderWidth = 0.3f }
                    , part3Table, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityTrainProperty1), PdfHelper.normalFont))
                    , part3Table, Rectangle.ALIGN_RIGHT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityTrainDesc1, pdfFont.normalChineseFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f }
                    , part3Table, Rectangle.ALIGN_RIGHT, null);
                #endregion

                #region Record Retention
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("Record Retention", PdfHelper.answerFont)) { BorderWidth = 0f, BorderWidthLeft = 1f, BorderWidthBottom = 1f }
                    , part3Table, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("...retaining all records related to the Quality Annex per the following?\r\n- Implantable Device: indefinitely\r\n- Equipment: Two years beyond dated removal from distribution or as otherwise indicated by Boston Scientific\r\n- All other products: At least Product lifetime/expiry + two years or as otherwise indicated by Boston Scientific.", PdfHelper.normalFont)) { BorderWidthTop = 0f, BorderWidthRight = 0f, BorderWidthBottom = 1f, BorderWidthLeft = 0.6f }
                    , part3Table, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(this.GetChooseString(conMast.CmQualityRecordProperty1), PdfHelper.normalFont)) { BorderWidthTop = 0f, BorderWidthRight = 0f, BorderWidthBottom = 1f, BorderWidthLeft = 0.6f }
                    , part3Table, Rectangle.ALIGN_RIGHT, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(conMast.CmQualityRecordDesc1, pdfFont.normalChineseFont)) { BorderWidthTop = 0f, BorderWidthRight = 1f, BorderWidthBottom = 1f, BorderWidthLeft = 0.6f }
                    , part3Table, Rectangle.ALIGN_RIGHT, null);
                #endregion

                PdfHelper.AddPdfTable(doc, part3Table);
                #endregion

                #region Signature
                PdfPTable signatureTable = new PdfPTable(4);
                signatureTable.SetWidths(new float[] { 20f, 30f, 20f, 30f });
                PdfHelper.InitPdfTableProperty(signatureTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Colspan = 4 }, signatureTable, null, null);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Section to be filled in by the BSC  Relationship Manager (RM)", FontFactory.GetFont("Arial", 9, BaseColor.WHITE))) { Colspan = 4, BackgroundColor = BaseColor.BLACK, BorderWidthLeft = 1f }, signatureTable, null, null);

                //Name of assessor:
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Name of RM:", PdfHelper.normalFont)) { FixedHeight = 20f, PaddingRight = 5f, BorderWidth = 0, BorderWidthLeft = 1f }, signatureTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { BorderWidth = 0, BorderWidthBottom = 0.3f, PaddingRight = 5f }, signatureTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);

                //Signature of assessor:
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Signature of RM:", PdfHelper.normalFont)) { FixedHeight = 20f, PaddingRight = 5f }, signatureTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { BorderWidth = 0, BorderWidthBottom = 0.3f, BorderWidthRight = 1f, PaddingRight = 5f }, signatureTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);

                //Date of assessment (dd-mmm-yyyy):
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Date received\r\n (dd-mmm-yyyy):", PdfHelper.normalFont)) { FixedHeight = 30f, PaddingRight = 5f, BorderWidth = 0, BorderWidthLeft = 1f }, signatureTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { BorderWidth = 0, BorderWidthBottom = 0.3f, PaddingRight = 5f }, signatureTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddEmptyPdfCell(signatureTable);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { FixedHeight = 6f, PaddingRight = 5f, BorderWidth = 0, BorderWidthRight = 1f }, signatureTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Colspan = 4, BorderWidth = 1f, BorderWidthTop = 0f }, signatureTable, null, null);

                PdfHelper.AddPdfTable(doc, signatureTable);
                #endregion

                //return fileName;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                //return string.Empty;
            }
            finally
            {
                doc.Close();
            }

            DownloadFileForDCMS(fileName, "IAF_Form_4.pdf", "DCMS");
        }

        private void AddHead(PdfPTable bodyTable, bool hasTitle)
        {
            if (hasTitle)
            {
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Section to be filled in by the Third Party", FontFactory.GetFont("Arial", 9, BaseColor.WHITE))) { Colspan = 4, BackgroundColor = BaseColor.BLACK, BorderWidthLeft = 1f }, bodyTable, null, null);
            }

            //Head
            PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("Topic", PdfHelper.normalFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthRight = 0f, BorderWidthLeft = 1f, BorderWidthTop = hasTitle ? 0f : 0.6f }
                , bodyTable, Rectangle.ALIGN_LEFT, null);
            PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("Question: is the Third Party capable of…", PdfHelper.normalFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthRight = 0f, BorderWidthTop = hasTitle ? 0f : 0.6f }
                , bodyTable, Rectangle.ALIGN_LEFT, null);
            PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("Yes / No / N/A", PdfHelper.normalFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthRight = 0f, BorderWidthTop = hasTitle ? 0f : 0.6f }
                , bodyTable, null, null);
            PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("Comments (at least all questions responded as \"No\" or \"N/A\" need to count with an explanatory comment)", PdfHelper.normalFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthRight = 1f, BorderWidthTop = hasTitle ? 0f : 0.6f }
                , bodyTable, Rectangle.ALIGN_LEFT, null);
        }

        private string GetChooseString(string radioValue)
        { 
            string reslutStr = string.Empty;

            switch (radioValue)
            {
                case "0": reslutStr = "No"; break;
                case "1": reslutStr = "Yes"; break;
                case "2": reslutStr = "N/A"; break;
                default: break;
            }

            return reslutStr;
        }

        protected void DownloadFileForDCMS(string filename, string downname, string documentName)
        {
            string savename = downname;

            try
            {
                filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Upload\\UploadFile\\" + documentName + "\\" + filename;

                Response.Clear();
                Response.Buffer = true;

                //以字符流的形式下载文件 
                System.IO.FileStream fs = new System.IO.FileStream(filename, System.IO.FileMode.Open);
                byte[] bytes = new byte[(int)fs.Length];
                fs.Read(bytes, 0, bytes.Length);
                fs.Close();
                Response.ContentType = "application/octet-stream";
                //通知浏览器下载文件而不是打开 
                Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(savename, System.Text.Encoding.UTF8));
                Response.BinaryWrite(bytes);
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {

            }

        }
        #endregion
    }
}
