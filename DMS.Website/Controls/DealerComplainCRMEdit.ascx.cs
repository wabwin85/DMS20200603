using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business;
using System.Collections;
using System.Data;
using DMS.Model.Data;
using DMS.Model;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using DMS.Common;
using Microsoft.Practices.Unity;
using System.Text;
using System.Globalization;

namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "DealerComplainCRMEdit")]
    public partial class DealerComplainCRMEdit : BaseUserControl
    {
        #region 数据字典


        #endregion

        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IDealerComplainBLL _business = new DealerComplainBLL();
        private IPurchaseOrderBLL _businessPurchaseOrder = new PurchaseOrderBLL();
        private IDealerMasters _dealers = Global.ApplicationContainer.Resolve<IDealerMasters>();
        private QueryInventoryBiz _businessQueryInv = new QueryInventoryBiz();
        private ICfns _cfn = new Cfns();
        private Hospitals _hospital = new Hospitals();
        #endregion

        #region 公开属性
        public Guid InstanceId
        {
            get
            {
                return new Guid(this.hidInstanceId.Text);
            }
            set
            {
                this.hidInstanceId.Text = value.ToString();
            }
        }
        #endregion

        #region 数据绑定

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                BindDictionary();
                if (IsDealer)
                {
                    //this.Bind_WarehouseByDealerAndType(WarehouseStore, _context.User.CorpId.Value, "");
                    this.Bind_LotByDealer(_context.User.CorpId.Value);
                }
                else
                {

                }
            }
        }

        #endregion

        #region Ajax Method

        public void Show(Guid id, String type)
        {
            this.InstanceId = id;
            Clear(BorderLayout2);
            this.CFMRETURNTYPE.Show();

            if (type == "New" && id == Guid.Empty)
            {
                InitInput();
                SetEnable(BorderLayout2, false);
                SubmitButton.Visible = true;
                this.FSLog.Hidden = true;
            }
            else if (type == "New" && id != Guid.Empty)
            {
                InitInput();
                LoadCRMInfo();
                SetEnable(BorderLayout2, false);
                SubmitButton.Visible = true;
                this.FSLog.Hidden = true;
            }
            else
            {
                if (!IsDealer)
                {
                    //获取仓库
                    Hashtable param = new Hashtable();
                    param.Add("DC_ID", this.InstanceId);
                    param.Add("ComplainType", "CRM");
                    DataRow r = _business.DealerComplainInfo(param).Rows[0];
                    this.Bind_WarehouseByDealerAndType(WarehouseStore, new Guid(r["DC_CorpId"].ToString()), "Complain");
                }
                else
                {
                    this.Bind_WarehouseByDealerAndType(WarehouseStore, _context.User.CorpId.Value, "Complain");
                }

                LoadCRMInfo();
                SetEnable(BorderLayout2, true);
                SubmitButton.Visible = false;
                this.FSLog.Hidden = false;
                this.gpLog.Reload();
            }
            this.DetailWindow.Show();
            this.DetailWindow.Maximize();
        }

        [AjaxMethod]
        public void DoSubmit()
        {

            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;

                Hashtable chkCondition = new Hashtable();
                chkCondition.Add("WHMID", new Guid(cbWarehouse.SelectedItem.Value.ToString()));
                chkCondition.Add("DMAID", _context.User.CorpId.Value);
                chkCondition.Add("UPN", this.cbUPN.SelectedItem.Value);
                chkCondition.Add("LOT", this.cbLOT.SelectedItem.Value);
                chkCondition.Add("EventDate", this.DateEvent.SelectedDate);
                chkCondition.Add("DealerDate", this.DateDealer.SelectedDate);
                chkCondition.Add("ComplainType", "CRM");

                _business.CheckUPNAndDateCRM(chkCondition, out rtnVal, out rtnMsg);
                if (rtnVal.Equals("Success"))
                {
                    Hashtable dealerComplainInfo = new Hashtable();
                    dealerComplainInfo.Add("UserId", _context.User.Id);
                    dealerComplainInfo.Add("CorpId", _context.User.CorpId.Value);
                    dealerComplainInfo.Add("ComplainType", "CRM");
                    dealerComplainInfo.Add("ComplainInfo", GenerateInfoXML());
                    dealerComplainInfo.Add("Result", "");

                    rtnVal = _business.DealerComplainSave(dealerComplainInfo);
                    this.hidRtnVal.Text = rtnVal;
                }
                else
                {
                    this.hidRtnVal.Text = rtnMsg;
                }
            }
            catch (Exception ex)
            {

            }

        }

        [AjaxMethod]
        public void DoCancel()
        {
            Hashtable dealerComplainInfo = new Hashtable();
            dealerComplainInfo.Add("UserId", _context.User.Id);
            dealerComplainInfo.Add("CarrierNumber", "");
            dealerComplainInfo.Add("ComplainType", "CRM");
            dealerComplainInfo.Add("InstanceId", this.InstanceId);
            dealerComplainInfo.Add("Status", "Revoke");
            dealerComplainInfo.Add("DMSBSCCode", "");
            dealerComplainInfo.Add("DNNumber", "");
            dealerComplainInfo.Add("PI", "");
            dealerComplainInfo.Add("IAN", "");

            _business.UpdateCRMRevoke(dealerComplainInfo);
        }


        [AjaxMethod]
        public void DoConfirm()
        {
            Hashtable dealerComplainInfo = new Hashtable();
            dealerComplainInfo.Add("UserId", _context.User.Id);
            dealerComplainInfo.Add("ComplainType", "BSC");
            dealerComplainInfo.Add("InstanceId", this.InstanceId);
            dealerComplainInfo.Add("CarrierNumber", null);
            dealerComplainInfo.Add("Status", "DealerCompleted");
            dealerComplainInfo.Add("DMSBSCCode", "");

            _business.DealerComplainConfirmCRM(dealerComplainInfo);
        }

        [AjaxMethod]
        public void ShowCRMCarrierWindow()
        {
            this.tbCRMRemark.Clear();
            //Show Window
            this.windowCRMCarrier.Show();
        }

        [AjaxMethod]
        public void SubmitCRMCarrier()
        {
            Hashtable dealerComplainInfo = new Hashtable();
            dealerComplainInfo.Add("UserId", _context.User.Id);
            dealerComplainInfo.Add("CarrierNumber", this.tbCRMRemark.Text);
            dealerComplainInfo.Add("ComplainType", "CRM");
            dealerComplainInfo.Add("InstanceId", this.InstanceId);
            dealerComplainInfo.Add("Status", "UploadCarrier");
            dealerComplainInfo.Add("DMSBSCCode", "");
            _business.UpdateCRMCarrierNumber(dealerComplainInfo);

            //修改信息
            windowCRMCarrier.Hide();
        }

        [AjaxMethod]
        public void AuotCompleteUPNInfo()
        {
            //获取产品信息
            try
            {
                Hashtable condition = new Hashtable();
                condition.Add("LOT", this.cbLOT.SelectedItem.Value);
                condition.Add("UPN", this.cbUPN.SelectedItem.Value);
                IList<ProductDataForQAComplain> prdData = _cfn.QueryProductDataInfoByUPN(condition);
                if (prdData.Count > 0)
                {
                    //this.BU.Text = prdData[0].ProductLine;
                    this.Model.Text = prdData[0].Model;
                    this.DESCRIPTION.Text = prdData[0].CNName;
                    //this.ConvertFactor.Text = prdData[0].ConvertFactor.ToString();
                    //this.TBNUM.Text = prdData[0].FactorNumber.ToString();
                    this.UPNExpDate.Text = prdData[0].UPNExpDate.ToString();
                    this.txtRegistration.Text = prdData[0].Registration.ToString();
                    if (!string.IsNullOrEmpty(prdData[0].SalesDate.ToString()))
                    {
                        this.SalesDate.SelectedDate = Convert.ToDateTime(prdData[0].SalesDate.ToString());
                    }
                    this.SalesDate.Enabled = string.IsNullOrEmpty(prdData[0].SalesDate.ToString());
                }
            }
            catch (Exception ex)
            {

            }
        }

        [AjaxMethod]
        public void CheckReturnType()
        {
            string warehouse = this.cbWarehouse.SelectedItem.Value;
            if (!string.IsNullOrEmpty(warehouse) && warehouse != "00000000-0000-0000-0000-000000000000")
            {
                //string whmtype = _business.GetWarehouseTypeById(new Guid(warehouse)).Tables[0].Rows[0]["TypeFrom"].ToString();
                //if (_context.User.CorpType == DealerType.T2.ToString() && this.RETURNTYPE.SelectedItem.Value != "2" && this.RETURNTYPE.SelectedItem.Value != "3" && (whmtype == "LP" || whmtype == "BSC"))
                //{
                //    this.RETURNTYPE.Value = "2";
                //    Ext.Msg.Alert("Failure", "平台或波科物权产品只能选择退款或仅投诉事件").Show();

                //}
                string whmtype = _business.GetWarehouseTypeById(new Guid(warehouse)).Tables[0].Rows[0]["TypeFrom"].ToString();
                if (_context.User.CorpType == DealerType.T2.ToString() && this.RETURNTYPE.SelectedItem.Value != "2" && this.RETURNTYPE.SelectedItem.Value != "3" && whmtype == "LP")
                {
                    this.RETURNTYPE.Value = "2";
                    Ext.Msg.Alert("Failure", "平台物权产品只能选择退款").Show();

                }
                else if (whmtype == "BSC" && this.RETURNTYPE.SelectedItem.Value != "5")
                {
                    this.RETURNTYPE.Value = "5";
                    Ext.Msg.Alert("Failure", "波科物权产品只能选择只退不换").Show();
                }
            }
        }
        #endregion

        #region 页面私有方法

        private String GenerateInfoXML()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<DealerComplain>");

            //sb.Append("<DC_ID>" + DC_ID + "</DC_ID>");
            //sb.Append("<DC_ComplainNbr>" + DC_ComplainNbr + "</DC_ComplainNbr>");
            //sb.Append("<DC_Status>" + DC_Status + "</DC_Status>");
            //sb.Append("<DC_CreatedBy>" + DC_CreatedBy + "</DC_CreatedBy>");
            //sb.Append("<DC_CreatedDate>" + DC_CreatedDate + "</DC_CreatedDate>");
            //sb.Append("<DC_LastModifiedBy>" + DC_LastModifiedBy + "</DC_LastModifiedBy>");
            //sb.Append("<DC_LastModifiedDate>" + DC_LastModifiedDate + "</DC_LastModifiedDate>");
            sb.Append("<PRODUCTTYPE>" + GetRadioGroupValue(PRODUCTTYPE) + "</PRODUCTTYPE>");
            sb.Append("<RETURNTYPE>" + RETURNTYPE.SelectedItem.Value + "</RETURNTYPE>");
            sb.Append("<ISPLATFORM>" + GetRadioGroupValue(ISPLATFORM) + "</ISPLATFORM>");
            sb.Append("<BSCSOLDTOACCOUNT>" + BSCSOLDTOACCOUNT.Text.Trim() + "</BSCSOLDTOACCOUNT>");
            sb.Append("<BSCSOLDTONAME>" + BSCSOLDTONAME.Text.Trim() + "</BSCSOLDTONAME>");
            sb.Append("<BSCSOLDTOCITY>" + BSCSOLDTOCITY.Text.Trim() + "</BSCSOLDTOCITY>");
            sb.Append("<SUBSOLDTONAME>" + SUBSOLDTONAME.Text.Trim() + "</SUBSOLDTONAME>");
            sb.Append("<SUBSOLDTOCITY>" + SUBSOLDTOCITY.Text.Trim() + "</SUBSOLDTOCITY>");
            //sb.Append("<DISTRIBUTORCUSTOMER>" + DISTRIBUTORCUSTOMER.Text.Trim() + "</DISTRIBUTORCUSTOMER>");
            sb.Append("<DISTRIBUTORCUSTOMER>" + cbHospital.SelectedItem.Value + "</DISTRIBUTORCUSTOMER>");
            sb.Append("<DISTRIBUTORCITY>" + DISTRIBUTORCITY.Text.Trim() + "</DISTRIBUTORCITY>");

            sb.Append("<Model>" + Model.Text.Trim() + "</Model>");
            sb.Append("<Serial>" + this.cbUPN.SelectedItem.Value + "</Serial>");
            sb.Append("<Lot>" + this.cbLOT.SelectedItem.Value + "</Lot>");
            sb.Append("<DESCRIPTION>" + this.DESCRIPTION.Text.Trim() + "</DESCRIPTION>");
            sb.Append("<UPNExpDate>" + this.UPNExpDate.Text.Trim() + "</UPNExpDate>");
            sb.Append("<PI>" + PI.Text.Trim() + "</PI>");
            sb.Append("<IAN>" + IAN.Text.Trim() + "</IAN>");
            sb.Append("<CompletedName>" + CompletedName.Text.Trim() + "</CompletedName>");
            sb.Append("<CompletedTitle>" + CompletedTitle.Text.Trim() + "</CompletedTitle>");
            sb.Append("<NonBostonName>" + NonBostonName.Text.Trim() + "</NonBostonName>");
            sb.Append("<NonBostonCompany>" + NonBostonCompany.Text.Trim() + "</NonBostonCompany>");
            sb.Append("<NonBostonAddress>" + NonBostonAddress.Text.Trim() + "</NonBostonAddress>");
            sb.Append("<NonBostonCity>" + NonBostonCity.Text.Trim() + "</NonBostonCity>");
            sb.Append("<NonBostonCountry>" + NonBostonCountry.Text.Trim() + "</NonBostonCountry>");
            sb.Append("<DateEvent>" + (DateEvent.IsNull ? "" : DateEvent.SelectedDate.ToString("yyyyMMdd")) + "</DateEvent>");
            //sb.Append("<DateBSC>" + (DateBSC.IsNull ? DateTime.Now.ToString() : DateBSC.SelectedDate.ToString("yyyyMMdd")) + "</DateBSC>");
            sb.Append("<DateDealer>" + (DateDealer.IsNull ? "" : DateDealer.SelectedDate.ToString("yyyyMMdd")) + "</DateDealer>");
            sb.Append("<EventCountry>" + EventCountry.Text.Trim() + "</EventCountry>");
            sb.Append("<OtherCountry>" + OtherCountry.Text.Trim() + "</OtherCountry>");
            sb.Append("<NeedSupport>" + GetRadioGroupValue(NeedSupport) + "</NeedSupport>");
            sb.Append("<PatientName>" + PatientName.Text.Trim() + "</PatientName>");
            sb.Append("<PatientNum>" + PatientNum.Text.Trim() + "</PatientNum>");
            sb.Append("<PatientSex>" + PatientSex.Text.Trim() + "</PatientSex>");
            sb.Append("<PatientSexInvalid>" + PatientSexInvalid.Checked + "</PatientSexInvalid>");
            sb.Append("<PatientBirth>" + (PatientBirth.IsNull ? "" : PatientBirth.SelectedDate.ToString("yyyyMMdd")) + "</PatientBirth>");
            sb.Append("<PatientBirthInvalid>" + PatientBirthInvalid.Checked + "</PatientBirthInvalid>");
            sb.Append("<PatientWeight>" + PatientWeight.Text.Trim() + "</PatientWeight>");
            sb.Append("<PatientWeightInvalid>" + PatientWeightInvalid.Checked + "</PatientWeightInvalid>");
            sb.Append("<PhysicianName>" + PhysicianName.Text.Trim() + "</PhysicianName>");
            sb.Append("<PhysicianHospital>" + PhysicianHospital.Text.Trim() + "</PhysicianHospital>");
            sb.Append("<PhysicianTitle>" + PhysicianTitle.Text.Trim() + "</PhysicianTitle>");
            sb.Append("<PhysicianAddress>" + PhysicianAddress.Text.Trim() + "</PhysicianAddress>");
            sb.Append("<PhysicianCity>" + PhysicianCity.Text.Trim() + "</PhysicianCity>");
            sb.Append("<PhysicianZipcode>" + PhysicianZipcode.Text.Trim() + "</PhysicianZipcode>");
            sb.Append("<PhysicianCountry>" + PhysicianCountry.Text.Trim() + "</PhysicianCountry>");
            sb.Append("<PatientStatus>" + GetCheckboxGroupValue(PatientStatus) + "</PatientStatus>");
            sb.Append("<DeathDate>" + (DeathDate.IsNull ? "" : DeathDate.SelectedDate.ToString("yyyyMMdd")) + "</DeathDate>");
            sb.Append("<DeathTime>" + DeathTime.Text.Trim() + "</DeathTime>");
            sb.Append("<DeathCause>" + DeathCause.Text.Trim() + "</DeathCause>");
            sb.Append("<Witnessed>" + GetRadioGroupValue(Witnessed) + "</Witnessed>");
            sb.Append("<RelatedBSC>" + GetRadioGroupValue(RelatedBSC) + "</RelatedBSC>");
            sb.Append("<ISFORBSCPRODUCT>" + GetRadioGroupValue(IsForBSCProduct) + "</ISFORBSCPRODUCT>");
            sb.Append("<ReasonsForProduct>" + GetCheckboxGroupValue(ReasonsForProduct) + "</ReasonsForProduct>");
            sb.Append("<Returned>" + GetCheckboxGroupValue(Returned) + "</Returned>");
            sb.Append("<ReturnedDay>" + ReturnedDay.Text.Trim() + "</ReturnedDay>");
            sb.Append("<AnalysisReport>" + GetCheckboxGroupValue(AnalysisReport) + "</AnalysisReport>");
            sb.Append("<RequestPhysicianName>" + RequestPhysicianName.Text.Trim() + "</RequestPhysicianName>");
            sb.Append("<Warranty>" + GetCheckboxGroupValue(Warranty) + "</Warranty>");
            sb.Append("<Pulse>" + GetCheckboxGroupValue(Pulse) + "</Pulse>");
            sb.Append("<Pulsebeats>" + Pulsebeats.Text.Trim() + "</Pulsebeats>");
            sb.Append("<Leads>" + GetCheckboxGroupValue(Leads) + "</Leads>");
            sb.Append("<LeadsFracture>" + LeadsFracture.Text.Trim() + "</LeadsFracture>");
            sb.Append("<LeadsIssue>" + LeadsIssue.Text.Trim() + "</LeadsIssue>");
            sb.Append("<LeadsDislodgement>" + LeadsDislodgement.Text.Trim() + "</LeadsDislodgement>");
            sb.Append("<LeadsMeasurements>" + LeadsMeasurements.Text.Trim() + "</LeadsMeasurements>");
            sb.Append("<LeadsThresholds>" + LeadsThresholds.Text.Trim() + "</LeadsThresholds>");
            sb.Append("<LeadsBeats>" + LeadsBeats.Text.Trim() + "</LeadsBeats>");
            sb.Append("<LeadsNoise>" + LeadsNoise.Text.Trim() + "</LeadsNoise>");
            sb.Append("<LeadsLoss>" + LeadsLoss.Text.Trim() + "</LeadsLoss>");
            sb.Append("<Clinical>" + GetCheckboxGroupValue(Clinical) + "</Clinical>");
            sb.Append("<ClinicalPerforation>" + ClinicalPerforation.Text.Trim() + "</ClinicalPerforation>");
            sb.Append("<ClinicalBeats>" + ClinicalBeats.Text.Trim() + "</ClinicalBeats>");
            sb.Append("<PulseModel>" + PulseModel.Text.Trim() + "</PulseModel>");
            sb.Append("<PulseSerial>" + PulseSerial.Text.Trim() + "</PulseSerial>");
            sb.Append("<PulseImplant>" + (PulseImplant.IsNull ? "" : PulseImplant.SelectedDate.ToString("yyyyMMdd")) + "</PulseImplant>");
            sb.Append("<Leads1Model>" + Leads1Model.Text.Trim() + "</Leads1Model>");
            sb.Append("<Leads1Serial>" + Leads1Serial.Text.Trim() + "</Leads1Serial>");
            sb.Append("<Leads1Implant>" + (Leads1Implant.IsNull ? "" : Leads1Implant.SelectedDate.ToString("yyyyMMdd")) + "</Leads1Implant>");
            sb.Append("<Leads1Position>" + GetRadioGroupValue(Leads1Position) + "</Leads1Position>");
            sb.Append("<Leads2Model>" + Leads2Model.Text.Trim() + "</Leads2Model>");
            sb.Append("<Leads2Serial>" + Leads2Serial.Text.Trim() + "</Leads2Serial>");
            sb.Append("<Leads2Implant>" + (Leads2Implant.IsNull ? "" : Leads2Implant.SelectedDate.ToString("yyyyMMdd")) + "</Leads2Implant>");
            sb.Append("<Leads2Position>" + GetRadioGroupValue(Leads2Position) + "</Leads2Position>");
            sb.Append("<Leads3Model>" + Leads3Model.Text.Trim() + "</Leads3Model>");
            sb.Append("<Leads3Serial>" + Leads3Serial.Text.Trim() + "</Leads3Serial>");
            sb.Append("<Leads3Implant>" + (Leads3Implant.IsNull ? "" : Leads3Implant.SelectedDate.ToString("yyyyMMdd")) + "</Leads3Implant>");
            sb.Append("<Leads3Position>" + GetRadioGroupValue(Leads3Position) + "</Leads3Position>");
            sb.Append("<AccessoryModel>" + AccessoryModel.Text.Trim() + "</AccessoryModel>");
            sb.Append("<AccessorySerial>" + AccessorySerial.Text.Trim() + "</AccessorySerial>");
            sb.Append("<AccessoryImplant>" + (AccessoryImplant.IsNull ? "" : AccessoryImplant.SelectedDate.ToString("yyyyMMdd")) + "</AccessoryImplant>");
            sb.Append("<AccessoryLot>" + AccessoryLot.Text.Trim() + "</AccessoryLot>");
            sb.Append("<ExplantDate>" + (ExplantDate.IsNull ? "" : ExplantDate.SelectedDate.ToString("yyyyMMdd")) + "</ExplantDate>");
            sb.Append("<RemainsService>" + GetRadioGroupValue(RemainsService) + "</RemainsService>");
            sb.Append("<RemovedService>" + GetRadioGroupValue(RemovedService) + "</RemovedService>");
            sb.Append("<Replace1Model>" + Replace1Model.Text.Trim() + "</Replace1Model>");
            sb.Append("<Replace1Serial>" + Replace1Serial.Text.Trim() + "</Replace1Serial>");
            sb.Append("<Replace1Implant>" + (Replace1Implant.IsNull ? "" : Replace1Implant.SelectedDate.ToString("yyyyMMdd")) + "</Replace1Implant>");
            sb.Append("<Replace2Model>" + Replace2Model.Text.Trim() + "</Replace2Model>");
            sb.Append("<Replace2Serial>" + Replace2Serial.Text.Trim() + "</Replace2Serial>");
            sb.Append("<Replace2Implant>" + (Replace2Implant.IsNull ? "" : Replace2Implant.SelectedDate.ToString("yyyyMMdd")) + "</Replace2Implant>");
            sb.Append("<Replace3Model>" + Replace3Model.Text.Trim() + "</Replace3Model>");
            sb.Append("<Replace3Serial>" + Replace3Serial.Text.Trim() + "</Replace3Serial>");
            sb.Append("<Replace3Implant>" + (Replace3Implant.IsNull ? "" : Replace3Implant.SelectedDate.ToString("yyyyMMdd")) + "</Replace3Implant>");
            sb.Append("<Replace4Model>" + Replace4Model.Text.Trim() + "</Replace4Model>");
            sb.Append("<Replace4Serial>" + Replace4Serial.Text.Trim() + "</Replace4Serial>");
            sb.Append("<Replace4Implant>" + (Replace4Implant.IsNull ? "" : Replace4Implant.SelectedDate.ToString("yyyyMMdd")) + "</Replace4Implant>");
            sb.Append("<Replace5Model>" + Replace5Model.Text.Trim() + "</Replace5Model>");
            sb.Append("<Replace5Serial>" + Replace5Serial.Text.Trim() + "</Replace5Serial>");
            sb.Append("<Replace5Implant>" + (Replace5Implant.IsNull ? "" : Replace5Implant.SelectedDate.ToString("yyyyMMdd")) + "</Replace5Implant>");
            sb.Append("<ProductExpDetail>" + ProductExpDetail.Text.Trim() + "</ProductExpDetail>");
            sb.Append("<CustomerComment>" + CustomerComment.Text.Trim() + "</CustomerComment>");

            sb.Append("<ISPLATFORM>" + GetRadioGroupValue(ISPLATFORM) + "</ISPLATFORM>");
            sb.Append("<BSCSOLDTOACCOUNT>" + BSCSOLDTOACCOUNT.Text.Trim() + "</BSCSOLDTOACCOUNT>");
            sb.Append("<BSCSOLDTONAME>" + BSCSOLDTONAME.Text.Trim() + "</BSCSOLDTONAME>");
            sb.Append("<BSCSOLDTOCITY>" + BSCSOLDTOCITY.Text.Trim() + "</BSCSOLDTOCITY>");
            sb.Append("<SUBSOLDTONAME>" + SUBSOLDTONAME.Text.Trim() + "</SUBSOLDTONAME>");
            sb.Append("<SUBSOLDTOCITY>" + SUBSOLDTOCITY.Text.Trim() + "</SUBSOLDTOCITY>");
            //sb.Append("<DISTRIBUTORCUSTOMER>" + DISTRIBUTORCUSTOMER.Text.Trim() + "</DISTRIBUTORCUSTOMER>");
            sb.Append("<DISTRIBUTORCITY>" + DISTRIBUTORCITY.Text.Trim() + "</DISTRIBUTORCITY>");
            //获取单据编号
            AutoNumberBLL auto = new AutoNumberBLL();
            String autoNbr = auto.GetNextAutoNumber(_context.User.CorpId.Value, OrderType.Next_ComplainNbr);
            sb.Append("<COMPLAINNBR>" + autoNbr + "</COMPLAINNBR>");
            sb.Append("<WHMID>" + cbWarehouse.SelectedItem.Value.ToString() + "</WHMID>");
            sb.Append("<EFINSTANCECODE></EFINSTANCECODE>");
            sb.Append("<REGISTRATION>" + txtRegistration.Text.Trim() + "</REGISTRATION>");
            sb.Append("<SALESDATE>" + (SalesDate.IsNull ? "" : SalesDate.SelectedDate.ToString("yyyyMMdd")) + "</SALESDATE>");
            sb.Append("</DealerComplain>");
            return sb.ToString();
        }

        private String GetCheckboxGroupValue(CheckboxGroup cg)
        {
            String v = "";
            foreach (Checkbox cb in cg.CheckedItems)
            {
                v += cb.Attributes["cvalue"].ToString() + ",";
            }
            if (v != "")
            {
                v = v.Substring(0, v.Length - 1);
            }
            return v;
        }

        private String GetRadioGroupValue(RadioGroup rg)
        {
            String v = "";
            foreach (Radio r in rg.CheckedItems)
            {
                v += r.Attributes["cvalue"].ToString() + ",";
            }
            if (v != "")
            {
                v = v.Substring(0, v.Length - 1);
            }
            return v;
        }

        private void BindDictionary()
        {
            //StoreRETURNTYPE.DataSource = DIC_RETURNTYPE;
            //StoreRETURNTYPE.DataBind();

            //Hashtable ht = new Hashtable();
            //ht.Add("CorpId", _context.User.CorpId.Value);
            //StoreUPN.DataSource = _business.GetDealerComplainUPN(ht);
            //StoreUPN.DataBind();
        }

        private void Clear(Control c)
        {
            foreach (Control cc in c.Controls)
            {
                if (cc is TextField)
                {
                    (cc as TextField).Text = "";
                }
                if (cc is TextArea)
                {
                    (cc as TextArea).Text = "";
                }
                else if (cc is DateField)
                {
                    (cc as DateField).Value = "";
                }
                else if (cc is NumberField)
                {
                    (cc as NumberField).Text = "";
                }
                else if (cc is Checkbox)
                {
                    (cc as Checkbox).Checked = false;
                }
                else if (cc is ComboBox)
                {
                    (cc as ComboBox).Value = null;
                }
                else if (cc is CheckboxGroup)
                {
                    CheckboxGroup cg = cc as CheckboxGroup;
                    for (int i = 0; i < cg.Items.Count; i++)
                    {
                        if (cg.Items[i] is CheckboxColumn)
                        {
                            Clear(cg.Items[i]);
                        }
                        else if (cg.Items[i] is Checkbox)
                        {
                            Checkbox ccc = cg.Items[i];
                            ccc.Checked = false;
                        }
                    }
                    foreach (Checkbox cb in (cc as CheckboxGroup).Items)
                    {
                        cb.Checked = false;
                    }
                }
                else if (cc is RadioGroup)
                {
                    foreach (Radio r in (cc as RadioGroup).Items)
                    {
                        r.Checked = false;
                    }
                }
                else
                {
                    Clear(cc);
                }
            }
        }

        private void SetEnable(Control c, bool b)
        {
            foreach (Control cc in c.Controls)
            {
                if (cc is TextField)
                {
                    if ((cc as TextField).Attributes["noedit"] != "TRUE")
                    {
                        (cc as TextField).Enabled = !b;
                    }
                }
                else if (cc is DateField)
                {
                    if ((cc as DateField).Attributes["noedit"] != "TRUE")
                    {
                        (cc as DateField).Enabled = !b;
                    }
                }
                else if (cc is NumberField)
                {
                    if ((cc as NumberField).Attributes["noedit"] != "TRUE")
                    {
                        (cc as NumberField).Enabled = !b;
                    }
                }
                else if (cc is CheckboxColumn)
                {
                    foreach (CheckboxColumn ccc in (cc as CheckboxColumn).Items)
                    {
                        SetEnable(ccc, b);
                    }
                }
                else if (cc is Checkbox)
                {
                    if ((cc as Checkbox).Attributes["noedit"] != "TRUE")
                    {
                        (cc as Checkbox).Enabled = !b;
                    }
                }
                else if (cc is ComboBox)
                {
                    if ((cc as ComboBox).Attributes["noedit"] != "TRUE")
                    {
                        (cc as ComboBox).Enabled = !b;
                    }
                }
                else if (cc is CheckboxGroup)
                {
                    CheckboxGroup cg = cc as CheckboxGroup;
                    for (int i = 0; i < cg.Items.Count; i++)
                    {
                        if (cg.Items[i] is CheckboxColumn)
                        {
                            SetEnable(cg.Items[i], b);
                        }
                        else if (cg.Items[i] is Checkbox)
                        {
                            Checkbox ccc = cg.Items[i];
                            if (ccc.Attributes["noedit"] != "TRUE")
                            {
                                ccc.Enabled = !b;
                            }
                        }
                    }
                }
                else if (cc is RadioGroup)
                {
                    foreach (Radio r in (cc as RadioGroup).Items)
                    {
                        if (r.Attributes["noedit"] != "TRUE")
                        {
                            r.Enabled = !b;
                        }
                    }
                }
                else if (cc is TextArea)
                {
                    if ((cc as TextArea).Attributes["noedit"] != "TRUE")
                    {
                        (cc as TextArea).Enabled = !b;
                    }
                }
                else
                {
                    SetEnable(cc, b);
                }
            }
        }

        private void InitInput()
        {
            //    EID.Text = _context.User.FullName;
            //    REQUESTDATE.Text = DateTime.Now.ToString("yyyy-MM-dd");
            //    INITIALJOB.Text = "代理商";
            //    NOTIFYDATE.Text = DateTime.Now.ToString("yyyy-MM-dd");

            //    CONTACTMETHOD_1.Checked = true;
            //    COMPLAINTSOURCE_3.Checked = true;
            CFMRETURNTYPE.Hide();
            if (_context.User.CorpType.ToUpper() == DealerType.LP.ToString() || _context.User.CorpType.ToUpper() == DealerType.LS.ToString())
            {
                ISPLATFORM_1.Checked = true;
                BSCSOLDTONAME.Text = _context.User.CorpName;

                DealerMaster lp = _dealers.GetDealerMaster(_context.User.CorpId.Value);
                BSCSOLDTOCITY.Text = lp.City;
                BSCSOLDTOACCOUNT.Text = lp.SapCode;
            }
            else if (_context.User.CorpType.ToUpper() == DealerType.T1.ToString())
            {
                ISPLATFORM_2.Checked = true;
                BSCSOLDTONAME.Text = _context.User.CorpName;

                DealerMaster t1 = _dealers.GetDealerMaster(_context.User.CorpId.Value);
                BSCSOLDTOCITY.Text = t1.City;
                BSCSOLDTOACCOUNT.Text = t1.SapCode;
            }
            else if (_context.User.CorpType.ToUpper() == DealerType.T2.ToString())
            {
                ISPLATFORM_2.Checked = true;
                SUBSOLDTONAME.Text = _context.User.CorpName;

                DealerMaster t = new DealerMaster();
                t.Id = _context.User.CorpId.Value;
                DealerMaster t2 = _dealers.QueryForDealerMaster(t)[0];
                SUBSOLDTOCITY.Text = t2.City;

                if (t2.ParentDmaId != null)
                {
                    DealerMaster t1 = _dealers.GetDealerMaster(t2.ParentDmaId.Value);
                    BSCSOLDTONAME.Text = t1.ChineseName;
                    BSCSOLDTOCITY.Text = t1.City;
                    BSCSOLDTOACCOUNT.Text = t1.SapCode;
                }
            }

            //时间发生国家默认为China
            this.EventCountry.Text = "China";

            //初始化不显示死亡相关信息
            this.DeathDate.Hidden = true;
            this.DeathTime.Hidden = true;
            this.DeathCause.Hidden = true;
            this.Witnessed.Hidden = true;
            this.RelatedBSC.Hidden = true;

            //临床观察中初始需要隐藏的内容
            this.Pulsebeats.Hidden = true;
            this.LeadsFracture.Hidden = true;
            this.LeadsIssue.Hidden = true;
            this.LeadsDislodgement.Hidden = true;
            this.LeadsMeasurements.Hidden = true;
            this.LeadsThresholds.Hidden = true;
            this.LeadsBeats.Hidden = true;
            this.LeadsNoise.Hidden = true;
            this.LeadsLoss.Hidden = true;
            this.ClinicalPerforation.Hidden = true;
            this.ClinicalBeats.Hidden = true;

        }

        private void LoadCRMInfo()
        {
            Hashtable param = new Hashtable();
            param.Add("DC_ID", this.InstanceId);
            param.Add("ComplainType", "CRM");
            DataRow r = _business.DealerComplainInfo(param).Rows[0];


            SetRadioGroupValue(PRODUCTTYPE, r["PRODUCTTYPE"].ToString());

            RETURNTYPE.SetValue(r["RETURNTYPE"].ToString());
            CFMRETURNTYPE.SetValue(r["CONFIRMRETURNTYPE"].ToString());
            SetRadioGroupValue(ISPLATFORM, r["ISPLATFORM"].ToString());
            BSCSOLDTOACCOUNT.Text = r["BSCSOLDTOACCOUNT"].ToString();
            BSCSOLDTONAME.Text = r["BSCSOLDTONAME"].ToString();
            BSCSOLDTOCITY.Text = r["BSCSOLDTOCITY"].ToString();
            SUBSOLDTONAME.Text = r["SUBSOLDTONAME"].ToString();
            SUBSOLDTOCITY.Text = r["SUBSOLDTOCITY"].ToString();
            //DISTRIBUTORCUSTOMER.Text = r["DISTRIBUTORCUSTOMER"].ToString();
            cbHospital.SelectedItem.Value = r["DISTRIBUTORCUSTOMER"].ToString();
            DISTRIBUTORCITY.Text = r["DISTRIBUTORCITY"].ToString();

            cbWarehouse.SelectedItem.Value = r["WHMID"].ToString();
            cbUPN.SelectedItem.Value = r["Serial"].ToString();
            if (IsDealer)
            {
                cbLOT.SelectedItem.Value = r["Lot"].ToString();
            }
            else {
                cbLOT.SelectedItem.Value = r["Lot"].ToString().Split('@')[0];
            }
            txtQrCode.Text = r["LOT"].ToString().Substring(r["LOT"].ToString().LastIndexOf("@") + 1);
            Model.Text = r["Model"].ToString();
            DESCRIPTION.Text = r["ProductDescription"].ToString();
            UPNExpDate.Text = r["UPNExpDate"].ToString();
            PI.Text = r["PI"].ToString();
            IAN.Text = r["IAN"].ToString();
            DNNo.Text = r["DN"].ToString();
            CompletedName.Text = r["CompletedName"].ToString();
            CompletedTitle.Text = r["CompletedTitle"].ToString();
            NonBostonName.Text = r["NonBostonName"].ToString();
            NonBostonCompany.Text = r["NonBostonCompany"].ToString();
            NonBostonAddress.Text = r["NonBostonAddress"].ToString();
            NonBostonCity.Text = r["NonBostonCity"].ToString();
            NonBostonCountry.Text = r["NonBostonCountry"].ToString();
            DateBSC.Text = r["DateBSC"].ToString();
            if (r["DateEvent"] != null && !String.IsNullOrEmpty(r["DateEvent"].ToString()))
            {
                DateEvent.SelectedDate = DateTime.ParseExact(r["DateEvent"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            //if (r["DateBSC"] != null && !String.IsNullOrEmpty(r["DateBSC"].ToString()))
            //{
            //    DateBSC.SelectedDate = DateTime.ParseExact(r["DateBSC"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            //}
            if (r["DateDealer"] != null && !String.IsNullOrEmpty(r["DateDealer"].ToString()))
            {
                DateDealer.SelectedDate = DateTime.ParseExact(r["DateDealer"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            EventCountry.Text = r["EventCountry"].ToString();
            OtherCountry.Text = r["OtherCountry"].ToString();
            SetRadioGroupValue(NeedSupport, r["NeedSupport"].ToString());
            PatientName.Text = r["PatientName"].ToString();
            PatientNum.Text = r["PatientNum"].ToString();
            PatientSex.Text = r["PatientSex"].ToString();
            PatientSexInvalid.Checked = Convert.ToBoolean(r["PatientSexInvalid"].ToString());
            if (r["PatientBirth"] != null && !String.IsNullOrEmpty(r["PatientBirth"].ToString()))
            {
                PatientBirth.SelectedDate = DateTime.ParseExact(r["PatientBirth"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            PatientBirthInvalid.Checked = Convert.ToBoolean(r["PatientBirthInvalid"].ToString());
            PatientWeight.Text = r["PatientWeight"].ToString();
            PatientWeightInvalid.Checked = Convert.ToBoolean(r["PatientWeightInvalid"].ToString());
            PhysicianName.Text = r["PhysicianName"].ToString();
            PhysicianHospital.Text = r["PhysicianHospital"].ToString();
            PhysicianTitle.Text = r["PhysicianTitle"].ToString();
            PhysicianAddress.Text = r["PhysicianAddress"].ToString();
            PhysicianCity.Text = r["PhysicianCity"].ToString();
            PhysicianZipcode.Text = r["PhysicianZipcode"].ToString();
            PhysicianCountry.Text = r["PhysicianCountry"].ToString();
            SetCheckboxGroupValue(PatientStatus, r["PatientStatus"].ToString());
            if (r["DeathDate"] != null && !String.IsNullOrEmpty(r["DeathDate"].ToString()))
            {
                DeathDate.SelectedDate = DateTime.ParseExact(r["DeathDate"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            DeathTime.Text = r["DeathTime"].ToString();
            DeathCause.Text = r["DeathCause"].ToString();
            SetRadioGroupValue(Witnessed, r["Witnessed"].ToString());
            SetRadioGroupValue(RelatedBSC, r["RelatedBSC"].ToString());
            SetRadioGroupValue(IsForBSCProduct, r["IsForBSCProduct"].ToString());
            SetCheckboxGroupValue(ReasonsForProduct, r["ReasonsForProduct"].ToString());
            SetCheckboxGroupValue(Returned, r["Returned"].ToString());
            ReturnedDay.Text = r["ReturnedDay"].ToString();
            SetCheckboxGroupValue(AnalysisReport, r["AnalysisReport"].ToString());
            RequestPhysicianName.Text = r["RequestPhysicianName"].ToString();
            SetCheckboxGroupValue(Warranty, r["Warranty"].ToString());
            SetCheckboxGroupValue(Pulse, r["Pulse"].ToString());
            Pulsebeats.Text = r["Pulsebeats"].ToString();
            SetCheckboxGroupValue(Leads, r["Leads"].ToString());
            LeadsFracture.Text = r["LeadsFracture"].ToString();
            LeadsIssue.Text = r["LeadsIssue"].ToString();
            LeadsDislodgement.Text = r["LeadsDislodgement"].ToString();
            LeadsMeasurements.Text = r["LeadsMeasurements"].ToString();
            LeadsThresholds.Text = r["LeadsThresholds"].ToString();
            LeadsBeats.Text = r["LeadsBeats"].ToString();
            LeadsNoise.Text = r["LeadsNoise"].ToString();
            LeadsLoss.Text = r["LeadsLoss"].ToString();
            SetCheckboxGroupValue(Clinical, r["Clinical"].ToString());
            ClinicalPerforation.Text = r["ClinicalPerforation"].ToString();
            ClinicalBeats.Text = r["ClinicalBeats"].ToString();
            PulseModel.Text = r["PulseModel"].ToString();
            PulseSerial.Text = r["PulseSerial"].ToString();
            if (r["PulseImplant"] != null && !String.IsNullOrEmpty(r["PulseImplant"].ToString()))
            {
                PulseImplant.SelectedDate = DateTime.ParseExact(r["PulseImplant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            Leads1Model.Text = r["Leads1Model"].ToString();
            Leads1Serial.Text = r["Leads1Serial"].ToString();
            if (r["Leads1Implant"] != null && !String.IsNullOrEmpty(r["Leads1Implant"].ToString()))
            {
                Leads1Implant.SelectedDate = DateTime.ParseExact(r["Leads1Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            SetRadioGroupValue(Leads1Position, r["Leads1Position"].ToString());
            Leads2Model.Text = r["Leads2Model"].ToString();
            Leads2Serial.Text = r["Leads2Serial"].ToString();
            if (r["Leads2Implant"] != null && !String.IsNullOrEmpty(r["Leads2Implant"].ToString()))
            {
                Leads2Implant.SelectedDate = DateTime.ParseExact(r["Leads2Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            SetRadioGroupValue(Leads2Position, r["Leads2Position"].ToString());
            Leads3Model.Text = r["Leads3Model"].ToString();
            Leads3Serial.Text = r["Leads3Serial"].ToString();
            if (r["Leads3Implant"] != null && !String.IsNullOrEmpty(r["Leads3Implant"].ToString()))
            {
                Leads3Implant.SelectedDate = DateTime.ParseExact(r["Leads3Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            SetRadioGroupValue(Leads3Position, r["Leads3Position"].ToString());
            AccessoryModel.Text = r["AccessoryModel"].ToString();
            AccessorySerial.Text = r["AccessorySerial"].ToString();
            if (r["AccessoryImplant"] != null && !String.IsNullOrEmpty(r["AccessoryImplant"].ToString()))
            {
                AccessoryImplant.SelectedDate = DateTime.ParseExact(r["AccessoryImplant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            AccessoryLot.Text = r["AccessoryLot"].ToString();
            if (r["ExplantDate"] != null && !String.IsNullOrEmpty(r["ExplantDate"].ToString()))
            {
                ExplantDate.SelectedDate = DateTime.ParseExact(r["ExplantDate"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            SetRadioGroupValue(RemainsService, r["RemainsService"].ToString());
            SetRadioGroupValue(RemovedService, r["RemovedService"].ToString());
            Replace1Model.Text = r["Replace1Model"].ToString();
            Replace1Serial.Text = r["Replace1Serial"].ToString();
            if (r["Replace1Implant"] != null && !String.IsNullOrEmpty(r["Replace1Implant"].ToString()))
            {
                Replace1Implant.SelectedDate = DateTime.ParseExact(r["Replace1Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            Replace2Model.Text = r["Replace2Model"].ToString();
            Replace2Serial.Text = r["Replace2Serial"].ToString();
            if (r["Replace2Implant"] != null && !String.IsNullOrEmpty(r["Replace2Implant"].ToString()))
            {
                Replace2Implant.SelectedDate = DateTime.ParseExact(r["Replace2Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            Replace3Model.Text = r["Replace3Model"].ToString();
            Replace3Serial.Text = r["Replace3Serial"].ToString();
            if (r["Replace3Implant"] != null && !String.IsNullOrEmpty(r["Replace3Implant"].ToString()))
            {
                Replace3Implant.SelectedDate = DateTime.ParseExact(r["Replace3Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            Replace4Model.Text = r["Replace4Model"].ToString();
            Replace4Serial.Text = r["Replace4Serial"].ToString();
            if (r["Replace4Implant"] != null && !String.IsNullOrEmpty(r["Replace4Implant"].ToString()))
            {
                Replace4Implant.SelectedDate = DateTime.ParseExact(r["Replace4Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            Replace5Model.Text = r["Replace5Model"].ToString();
            Replace5Serial.Text = r["Replace5Serial"].ToString();
            if (r["Replace5Implant"] != null && !String.IsNullOrEmpty(r["Replace5Implant"].ToString()))
            {
                Replace5Implant.SelectedDate = DateTime.ParseExact(r["Replace5Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            ProductExpDetail.Text = r["ProductExpDetail"].ToString();
            CustomerComment.Text = r["CustomerComment"].ToString();
            if (r["SALESDATE"] != null && !String.IsNullOrEmpty(r["SALESDATE"].ToString()))
            {
                SalesDate.SelectedDate = Convert.ToDateTime(r["SALESDATE"]);
                //TBEDATE.Text = r["EDATE"].ToString();
            }
            txtRegistration.Text = r["REGISTRATION"].ToString();
        }

        private void SetCheckboxGroupValue(CheckboxGroup cg, String value)
        {
            String[] values = value.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            foreach (String v in values)
            {
                for (int i = 0; i < cg.Items.Count; i++)
                {
                    if (cg.Items[i] is CheckboxColumn)
                    {
                        CheckboxColumn cc = cg.Items[i] as CheckboxColumn;
                        for (int j = 0; j < cc.Items.Count; j++)
                        {
                            if (cc.Items[j] is Checkbox)
                            {
                                Checkbox cb = cc.Items[j] as Checkbox;
                                if (cb.Attributes["cvalue"].ToString() == v)
                                {
                                    cb.Checked = true;
                                }
                            }
                        }
                    }
                    else if (cg.Items[i] is Checkbox)
                    {
                        Checkbox cb = cg.Items[i];
                        if (cb.Attributes["cvalue"].ToString() == v)
                        {
                            cb.Checked = true;
                        }
                    }
                }
                //foreach (Checkbox cb in cg.Items)
                //{
                //    if (cb.Attributes["cvalue"].ToString() == v)
                //    {
                //        cb.Checked = true;
                //    }
                //}
            }
        }

        private void SetRadioGroupValue(RadioGroup rg, String value)
        {
            String[] values = value.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            foreach (String v in values)
            {
                foreach (Radio r in rg.Items)
                {
                    if (r.Attributes["cvalue"].ToString() == v)
                    {
                        r.Checked = true;
                    }
                }
            }
        }

        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = _businessPurchaseOrder.QueryPurchaseOrderLogByHeaderId(this.InstanceId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
        }

        protected void HospitalStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {

            if (IsDealer)
            {
                this.HospitalStore.DataSource = _hospital.SelectHospitalByAuthorization(_context.User.CorpId.Value);
            }
            else
            {
                this.HospitalStore.DataSource = _hospital.GetAllHospitals();
            }
            this.HospitalStore.DataBind();
        }

        protected void Bind_LotByDealer(Guid dealerId)
        {
            Hashtable param = new Hashtable();
            param.Add("DealerID", dealerId);
            param.Add("OwnerIdentityType", "Dealer");
            DataSet ds = null;
            ds = _businessQueryInv.SelectInventoryLotForQACRMComplainsDataSet(param);

            LotStore.DataSource = ds;
            LotStore.DataBind();
        }

        protected internal virtual void Store_AllLotByWHMId(object sender, StoreRefreshDataEventArgs e)
        {
            //获取LotID

            Hashtable param = new Hashtable();

            Guid WHMId = Guid.Empty;
            if (e.Parameters["WHMId"] != null && !string.IsNullOrEmpty(e.Parameters["WHMId"].ToString()))
            {
                WHMId = new Guid(e.Parameters["WHMId"].ToString());
                param.Add("WHMId", WHMId);

                DataSet ds = null;
                ds = _businessQueryInv.SelectInventoryLotForQACRMComplainsDataSet(param);

                if (sender is Store)
                {
                    Store store1 = (sender as Store);

                    store1.DataSource = ds;
                    store1.DataBind();
                }
            }
        }

        protected internal virtual void Store_AllUPNByLot(object sender, StoreRefreshDataEventArgs e)
        {
            //获取UPN

            Hashtable param = new Hashtable();
            Guid WHMId = Guid.Empty;
            String LotNumber = "";
            if (e.Parameters["LotId"] != null && !string.IsNullOrEmpty(e.Parameters["LotId"].ToString()))
            {
                LotNumber = e.Parameters["LotId"].ToString();
                if (IsDealer)
                {
                    param.Add("DealerID", _context.User.CorpId.Value);
                    param.Add("OwnerIdentityType", "Dealer");
                }
                else
                {
                    param.Add("OwnerIdentityType", "User");
                }
                param.Add("LotNumber", LotNumber);

                DataSet ds = null;
                ds = _businessQueryInv.SelectInventoryUPNForQACRMComplainsDataSet(param);

                if (sender is Store)
                {
                    Store store1 = (sender as Store);

                    store1.DataSource = ds;
                    store1.DataBind();
                }
            }
        }

        protected internal virtual void Store_AllWHMByLotUPN(object sender, StoreRefreshDataEventArgs e)
        {
            //获取UPN

            Hashtable param = new Hashtable();
            String UPNId = "";
            String LotNumber = "";
            if (e.Parameters["LotId"] != null && !string.IsNullOrEmpty(e.Parameters["LotId"].ToString()) && e.Parameters["UPNId"] != null && !string.IsNullOrEmpty(e.Parameters["UPNId"].ToString()))
            {
                UPNId = e.Parameters["UPNId"].ToString();
                LotNumber = e.Parameters["LotId"].ToString();

                param.Add("UPN", UPNId);
                if (IsDealer)
                {
                    param.Add("DealerID", _context.User.CorpId.Value);
                    param.Add("OwnerIdentityType", "Dealer");
                }
                else
                {
                    param.Add("OwnerIdentityType", "User");
                }
                param.Add("LotNumber", LotNumber);

                DataSet ds = null;
                ds = _businessQueryInv.SelectInventoryWHMForQACRMComplainsDataSet(param);

                if (sender is Store)
                {
                    Store store1 = (sender as Store);

                    store1.DataSource = ds;
                    store1.DataBind();
                }
            }


        }


        #endregion
    }
}