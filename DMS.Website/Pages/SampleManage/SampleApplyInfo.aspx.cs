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

namespace DMS.Website.Pages.SampleManage
{
    public partial class SampleApplyInfo : BasePage
    {
        SampleApplyBLL Bll = new SampleApplyBLL();
        IRoleModelContext _context = RoleModelContext.Current;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["HeadId"]))
                {
                    IptSampleHeadId.Text = Request.QueryString["HeadId"].ToString();
                }
                if (!string.IsNullOrEmpty(IptSampleHeadId.Text))
                {
                    Bindata();
                }
            }
        }

        public void Bindata()
        {
            SampleApplyHead Head = Bll.GetSampleApplyHeadById(new Guid(IptSampleHeadId.Text));
            if (Head != null)
            {
                if (Head.SampleType == "商业样品")
                {
                    DivSampleBusiness.Hidden = false;
                    RstUpn.Hidden = false;
                    RstSampleTrace.Hidden = false;
                    RstSampleTrace.ColumnModel.SetHidden(4, false);
                    RstSampleTrace.ColumnModel.SetHidden(6, false);
                    RstSampleTrace.ColumnModel.SetHidden(7, false);
                    RstOperLog.Hidden = false;

                    IptBusinessSampleType.Text = Head.SampleType;
                    IptBusinessApplyStatus.Text = DictionaryCacheHelper.GetDictionaryNameById("CONST_Sample_State", Head.ApplyStatus);
                    //IptBusinessApplyQuantity.Text = Head.ApplyQuantity;
                    //IptBusinessProcessUser.Text = Head.ProcessUser;
                    //IptBusinessApplyDate.Text = Head.ApplyDate;
                    IptBusinessApplyNo.Text = Head.ApplyNo;
                    //IptBusinessApplyUser.Text = Head.ApplyUser;
                    //IptBusinessApplyDept.Text = Head.ApplyDept;
                    //IptBusinessApplyDivision.Text = Head.ApplyDivision;
                    //IptBusinessArrivalDate.Text = Head.ArrivalDate;
                    IptBusinessApplyPurpose.Text = Head.ApplyPurpose;
                    //IptBusinessApplyCost.Text = Head.ApplyCost;
                    IptBusinessIrfNo.Text = Head.IrfNo;
                    IptBusinessHospName.Text = Head.HospName;
                    IptBusinessHpspAddress.Text = Head.HpspAddress;
                    IptBusinessTrialDoctor.Text = Head.TrialDoctor;
                    IptBusinessReceiptUser.Text = Head.ReceiptUser;
                    IptBusinessReceiptPhone.Text = Head.ReceiptPhone;
                    IptBusinessReceiptAddress.Text = Head.ReceiptAddress;
                    //IptBusinessDealerName.Text = Head.DealerName;
                    IptBusinessApplyMemo.Text = Head.ApplyMemo;
                    IptBusinessConfirmItem1.Checked = Head.ConfirmItem1 == "true";
                    IptBusinessConfirmItem2.Checked = Head.ConfirmItem2 == "true";
                    IptBusinessIrfNo.Visible = Head.ApplyPurpose.ToString() == "捐赠";
                    IptBusinessApplyMemo.Visible = !(Head.ApplyPurpose.ToString() == "捐赠");
                    IptApplyUser.Text = Head.ApplyUser;
                    IptApplyDate.Text = Head.ApplyDate;
                    IptCostCenter.Text = Head.CostCenter;
                    Ipt6MonthsExpProduct.Text = Head.ConfirmItem3;
                    if (Head.ApplyPurpose.ToString() == "捐赠" || Head.ApplyPurpose.ToString() == "CRM手术辅助")
                    {
                        IptBusinessConfirmItem1.Visible = false;
                        IptBusinessConfirmItem2.Visible = false;
                    }
                    BtnApprove.Hidden = true;
                }
                else if (Head.SampleType == "测试样品")
                {
                    DivSampleTest.Hidden = false;
                    //RstSampleTesting.Hidden = true;
                    RstUpn.Hidden = false;
                    RstSampleTrace.Hidden = false;
                    RstSampleTrace.ColumnModel.SetHidden(4, true);
                    RstSampleTrace.ColumnModel.SetHidden(6, true);
                    RstSampleTrace.ColumnModel.SetHidden(7, true);
                    RstOperLog.Hidden = false;
                    RstDelivery.Hidden = false;

                    IptTestSampleType.Text = Head.SampleType;
                    IptTestApplyStatus.Text = DictionaryCacheHelper.GetDictionaryNameById("CONST_Sample_State", Head.ApplyStatus);
                    IptTestApplyQuantity.Text = Head.ApplyQuantity;
                    IptTestProcessUser.Text = Head.ProcessUser;
                    IptTestApplyDate.Text = Head.ApplyDate;
                    IptTestApplyNo.Text = Head.ApplyNo;
                    IptTestApplyUser.Text = Head.ApplyUser;
                    IptTestApplyDept.Text = Head.ApplyDept;
                    IptTestApplyDivision.Text = Head.ApplyDivision;
                    IptTestApplyCost.Text = Head.ApplyCost;
                    IptTestCustType.Text = Head.CustType;
                    IptTestCustName.Text = Head.CustName;
                    IptTestApplyPurpose.Text = Head.ApplyPurpose;
                    IptTestReceiptUser.Text = Head.ReceiptUser;
                    IptTestReceiptPhone.Text = Head.ReceiptPhone;
                    IptTestReceiptAddress.Text = Head.ReceiptAddress;
                    IptTestDealerName.Text = Head.DealerName;
                    IptTestApplyMemo.Text = Head.ApplyMemo;
                    IptTestCostCenter.Text = Head.CostCenter;

                    if (Head.ApplyStatus == "Approved" && _context.IsInRole("SAMPLE DP"))
                    {
                        //BtnAddDelivery.Hidden = false;
                        RstUpn.ColumnModel.SetHidden(6, false);
                    }
                    if (_context.IsInRole("SAMPLE IE"))
                    {
                        RstDelivery.ColumnModel.SetHidden(7, false);
                    }
                    if (_context.IsInRole("SAMPLE RA"))
                    {
                        //RstDelivery.ColumnModel.SetHidden(8, false);
                    }

                    //如果是测试样品，则判断是否是新证
                    this.IsNewCertificate.Text = Bll.IsNewCertificate(Head.SampleApplyHeadId) ? "True" : "False";

                    //样品检测
                    IList<SampleTesting> list = Bll.GetSampleTestingList(new Guid(IptSampleHeadId.Text));
                    if (list != null && list.Count > 0)
                    {
                        SampleTesting st = list[0];
                        tbDivision.Text = st.Division;
                        tbCostCenter.Text = st.CostCenter;
                        tbRA.Text = st.Ra;
                        tbPriority.Text = st.Priority;
                        tbArrivalDate.Text = st.ArrivalDate;
                        tbCertificate.Text = st.Certificate;
                        tbIRF.Text = st.Irf;
                    }
                    BtnApprove.Hidden = true;
                }
                else if(Head.SampleType == "临床样品")
                {

                    DivSampleClin.Hidden = false;
                    RstUpn.Hidden = false;
                    RstSampleTrace.Hidden = false;
                    RstSampleTrace.ColumnModel.SetHidden(4, false);
                    RstSampleTrace.ColumnModel.SetHidden(6, false);
                    RstSampleTrace.ColumnModel.SetHidden(7, false);
                    RstOperLog.Hidden = false;

                    IptClinSampleType.Text = Head.SampleType;
                    IptClinApplyStatus.Text = DictionaryCacheHelper.GetDictionaryNameById("CONST_Sample_State", Head.ApplyStatus);
                    IptClinApplyNo.Text = Head.ApplyNo;
                    IptClinApplyPurpose.Text = Head.ApplyPurpose;
                    //IptBusinessApplyCost.Text = Head.ApplyCost;
                    IptClinHospName.Text = Head.HospName;
                    IptClinHospAddress.Text = Head.HpspAddress;
                    IptClinRoom.Text = Head.TrialDoctor;
                    IptClinReceiptUser.Text = Head.ReceiptUser;
                    IptClinReceiptPhone.Text = Head.ReceiptPhone;
                    IptClinReceiptAddress.Text = Head.ReceiptAddress;
                    IptClinApplyMemo.Text = Head.ApplyMemo;
                    IptClinApplyUser.Text = Head.ApplyUser;
                    IptClinApplyDate.Text = Head.ApplyDate;
                    IptClinCostCenter.Text = Head.CostCenter;
                    IptClin6MonthsExpProduct.Text = Head.ConfirmItem3;
                    IptClinReceiptPhone2.Text = Head.ConfirmItem1;
                    IptClinHospCode.Text = Head.ConfirmItem2;
                    BtnApprove.Hidden = !(Head.ApplyStatus == "InApproval");
                }
            }
        }

        //protected void StoSampleTesting_RefershData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    DataSet ds = Bll.GetSampleTestingList(new Guid(IptSampleHeadId.Text));
        //    StoSampleTesting.DataSource = ds;
        //    StoSampleTesting.DataBind();
        //}

        protected void StoUpn_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataSet ds = Bll.GetSampleUpnList(new Guid(IptSampleHeadId.Text));
            StoUpn.DataSource = ds;
            StoUpn.DataBind();
        }

        protected void StoSampleTrace_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable ds = Bll.GetSampleTrace(new Guid(IptSampleHeadId.Text));
            StoSampleTrace.DataSource = ds;
            StoSampleTrace.DataBind();
        }

        protected void StoOperLog_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataSet ds = Bll.GetOperLogList(new Guid(IptSampleHeadId.Text));
            StoOperLog.DataSource = ds;
            StoOperLog.DataBind();
        }

        protected void StoDelivery_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable ds = Bll.GetSampleDeliveryList(IptTestApplyNo.Text);
            StoDelivery.DataSource = ds;
            StoDelivery.DataBind();
        }

        protected void StoRemain_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //DataTable ds = Bll.GetSampleRemainList(IptSampleHeadId.Text);
            //StoRemain.DataSource = ds;
            //StoRemain.DataBind();
        }

        [AjaxMethod]
        public void ShowDpDelivery(string upnId)
        {
            DataTable dt = Bll.GetSampleRemainList(IptSampleHeadId.Text, upnId);
            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow dr = dt.Rows[0];
                IptDpDeliveryUpn.Text = dr["UpnNo"].ToString();
                IptDpDeliveryRemainQuantity.Text = dr["RemainQuantity"].ToString();
                IptDpDeliveryProductName.Text = dr["ProductName"].ToString();
                IptDpDeliveryProductDesc.Text = dr["ProductDesc"].ToString();
                IptDpDelvieryConvertFactor.Text = dr["ConvertFactor"].ToString();
            }
            WdwDpDelivery.Show();
        }

        [AjaxMethod]
        public void SaveDpDelivery()
        {
            Hashtable condition = new Hashtable();
            condition.Add("Upn", IptDpDeliveryUpn.Text);
            condition.Add("Lot", IptDpDeliveryLot.Text);
            condition.Add("Quantity", IptDpDeliveryQuantity.Text);
            condition.Add("Memo", IptDpDeliveryMemo.Text);
            condition.Add("SampleNo", IptTestApplyNo.Text);
            Bll.CreateDpDelivery(condition);
        }

        [AjaxMethod]
        public void SaveIeDelivery(String deliveryId)
        {
            Hashtable condition = new Hashtable();
            condition.Add("DeliveryId", deliveryId);
            condition.Add("DeliveryStatus", SampleDeliveryStatus.CS.ToString());
            Bll.ModifyDeliveryStatus(condition);
        }

        [AjaxMethod]
        public void SaveCsDelivery(String deliveryId)
        {
            Hashtable condition = new Hashtable();
            condition.Add("DeliveryId", deliveryId);
            condition.Add("DeliveryStatus", SampleDeliveryStatus.RA.ToString());
            Bll.ModifyDeliveryStatus(condition);
        }

        [AjaxMethod]
        public void ShowSampleEval(string HeaderID, string UPN, string Lot)
        {
            DataSet ds = Bll.GetSampleEvalListByCondition(new Guid(HeaderID), UPN, Lot);
            StoEval.DataSource = ds;
            StoEval.DataBind();
            WdwSampleEval.Show();
           
        }

        [AjaxMethod]
        public void Agree()
        {
            Bll.ApproveSampleClin(new Guid(IptSampleHeadId.Text));
        }
    }
}
