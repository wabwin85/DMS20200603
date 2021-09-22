using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Model.Data;
using Coolite.Ext.Web;
using System.Collections;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using DMS.Business.Contract;
using DMS.Model;
using System.Data;
using DMS.Business;
using Microsoft.Practices.Unity;
using DMS.Common;
using System.IO;

namespace DMS.Website.Pages.Contract
{
    public partial class TerminationUpdate : BasePage
    {

        IRoleModelContext _context = RoleModelContext.Current;
        ContractAmendmentService ContractBll = new ContractAmendmentService();
        private IAttachmentBLL _attachmentBLL = null;
        ContractTerminationService cts = new ContractTerminationService();
        [Dependency]
        public IAttachmentBLL attachmentBLL
        {
            get { return _attachmentBLL; }
            set { _attachmentBLL = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.hidUpdateId.Value = Guid.NewGuid().ToString();
            }
        }
        protected void Store_Refreshlog(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataTable dt = cts.GetUpdatelog(this.contractid.Value.ToString() == "" ? "00000000-0000-0000-0000-000000000000" : this.contractid.Value.ToString(), (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.logStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            logStore.DataSource = dt;
            logStore.DataBind();

        }
        protected void Store_RefreshAttachment(object sender, StoreRefreshDataEventArgs e)
        {
            if (this.hidUpdateId.Value.ToString()!="")
            {
                int totalCount = 0;
                DataTable dt = attachmentBLL.GetAttachmentByMainId(new Guid(this.hidUpdateId.Value.ToString()), AttachmentType.UpdateContractAdmin, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount).Tables[0];
                (this.AttachmentStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                AttachmentStore.DataSource = dt;
                AttachmentStore.DataBind();
            }
        }
        [AjaxMethod]
        public void ContractQuery()
        {
            DataSet dt = cts.GetTermination(this.txtContractNo.Value.ToString());
            if (dt.Tables[0].Rows.Count > 0)
            {
                this.contractid.Value = dt.Tables[0].Rows[0]["ContractId"].ToString();
                this.labDealerName.Text = dt.Tables[0].Rows[0]["DMA_ChineseShortName"].ToString();
                this.labProductLine.Text = dt.Tables[0].Rows[0]["ProductLineName"].ToString();
                this.labContractStatus.Text = dt.Tables[0].Rows[0]["ContractStatus"].ToString();
                this.labSubBu.Text = dt.Tables[0].Rows[0]["CC_NameCN"].ToString();
                this.labEName.Text = dt.Tables[0].Rows[0]["EName"].ToString();
                this.ButtonEdit.Enabled = true;
            }
        }
        [AjaxMethod]
        public void ContractAbandon()
        {
            this.txtContractNo.Enabled = true;
            this.ButtonQuery.Enabled = true;
            this.ButtonAbandon.Enabled = false;
            this.BtnApprove.Enabled = false;
            this.btnAddAttachment.Enabled = false;


            this.gpAttachment.Reload();
            this.gplog.Reload();

            this.txtContractNo.Value = "";
            this.labDealerName.Text = "";
            this.labProductLine.Text = "";
            this.labContractStatus.Text = "";
            this.labSubBu.Text = "";
            this.labEName.Text = "";
            this.DealerBeginDate.Text = "";
            this.DealerEndTyp0.Checked = false;
            this.DealerEndTyp1.Checked = false;
            this.DealerEndDate.Text = "";
            this.PlanExpiration.Value = "";
            this.DealerEndReason1.Checked = false;
            this.DealerEndReason2.Checked = false;
            this.DealerEndReason3.Checked = false;
            this.DealerEndReason4.Checked = false;
            this.OtherReason.Value = "";
            this.TenderIssue1.Checked = false;
            this.TenderIssue0.Checked = false;
            this.Exchangeproduct1.Checked = false;
            this.Refund1.Checked = false;
            this.None1.Checked = false;
            this.Exchangeproduct2.Checked = false;
            this.Refund2.Checked = false;
            this.None2.Checked = false;
            this.Exchangeproduct3.Checked = false;
            this.Refund3.Checked = false;
            this.None3.Checked = false;
            this.GoodsReturn1.Checked = false;
            this.GoodsReturn0.Checked = false;
            this.ReturnReason1.Checked = false;
            this.ReturnReason2.Checked = false;
            this.ReturnReason3.Checked = false;
            this.CreditMemo1.Checked = false;
            this.CreditMemo0.Checked = false;
            this.IsPendingPayment1.Checked = false;
            this.IsPendingPayment0.Checked = false;
            this.PendingRemark.Value = "";
            this.CurrentAR.Text = "";
            this.TenderIssueRemark.Value = "";
            this.RebateAmt.Text = "";
            this.PromotionAmt.Text = "";
            this.ComplaintAmt.Text = "";
            this.GoodsReturnAmt.Text = "";

            this.IsRGAAttach1.Checked = false;
            this.IsRGAAttach0.Checked = false;
            this.PendingAmt.Text = "";
            this.CashDeposit1.Checked = false;
            this.CashDeposit0.Checked = false;
            this.BGuarantee1.Checked = false;
            this.BGuarantee0.Checked = false;
            this.CGuarantee1.Checked = false;
            this.CGuarantee0.Checked = false;
            this.Inventory1.Checked = false;
            this.Inventory0.Checked = false;
            this.EstimatedAR.Text = "";
            this.Wirteoff.Value = "";
            this.PaymentPlan.Value = "";
            this.Reserve1.Checked = false;
            this.Reserve0.Checked = false;
            this.ReserveAmt.Text = "";
            this.BadDebt.Checked = false;
            this.Settlement.Checked = false;
            this.SalesReturn.Checked = false;
            this.Other.Checked = false;
            this.TakeOver.Value = "";
            this.BSC.Checked = false;
            this.LP.Checked = false;
            this.T1.Checked = false;
            this.T2.Checked = false;
            this.TakeOverIsNew1.Checked = false;
            this.TakeOverIsNew0.Checked = false;
            this.Notified1.Checked = false;
            this.Notified0.Checked = false;
            this.WhenNotify.Clear();
            this.WhenSettlement.Clear();
            this.WhenHandover.Clear();
            this.FollowUp1.Checked = false;
            this.FollowUp0.Checked = false;
            this.FollowUpRemark.Value = "";
            this.FieldOperation1.Checked = false;
            this.FieldOperation0.Checked = false;
            this.FieldOperationRemark.Value = "";
            this.AdverseEvent1.Checked = false;
            this.AdverseEvent0.Checked = false;
            this.AdverseEventRemark.Value = "";
            this.SubmitImplant1.Checked = false;
            this.SubmitImplant0.Checked = false;
            this.SubmitImplantRemark.Value = "";
            this.InventoryDispose1.Checked = false;
            this.InventoryDispose2.Checked = false;
            this.InventoryDispose3.Checked = false;
            this.InventoryDisposeRemark2.Value = "";
            this.InventoryDisposeRemark1.Value = "";
            this.NotifiedNCM1.Checked = false;
            this.NotifiedNCM0.Checked = false;
            this.Reviewed1.Checked = false;
            this.Handover1.Checked = false;
            this.Reviewed0.Checked = false;
            this.Handover0.Checked = false;
            this.HandoverRemark.Value = "";
            this.CurrentQuota.Text = "";
            this.ActualSales.Text = "";
            this.TenderDetails.Value = "";



        }
        [AjaxMethod]
        public string checkAttachment()
        {
            string retMassage = "Error";
            Hashtable obj = new Hashtable();
            obj.Add("UpdateId", this.hidUpdateId.Value);
            string retValue = ContractBll.CheckAttachmentUpload(obj);
            if (!retValue.Equals("0"))
            {
                retMassage = "success";
            }
            return retMassage;
        }
        [AjaxMethod]
        public void ContractEdit()
        {

            this.txtContractNo.Enabled = false;
            this.ButtonQuery.Enabled = false;
            this.ButtonEdit.Enabled = false;
            this.ButtonAbandon.Enabled = true;
            this.btnAddAttachment.Enabled = true;
            this.gplog.Reload();
            this.BtnApprove.Enabled = true;
            DataTable ds = cts.GetTerminationall(this.txtContractNo.Value.ToString()).Tables[0];
            if (ds.Rows.Count > 0)
            {

                this.DealerBeginDate.Text = ds.Rows[0]["DealerBeginDate"].ToString();
                this.DealerEndDate.Text = ds.Rows[0]["DealerEndDate"].ToString();
                this.PlanExpiration.SelectedDate = Convert.ToDateTime(ds.Rows[0]["PlanExpiration"].ToString());
                if (ds.Rows[0]["DealerEndTyp"].ToString() == "Termination")
                {
                    this.DealerEndTyp1.Checked = true;
                }
                if (ds.Rows[0]["DealerEndTyp"].ToString() == "Non-Renewal")
                {
                    this.DealerEndTyp0.Checked = true;
                }
                if (ds.Rows[0]["OtherReason"].ToString()!=""&& ds.Rows[0]["OtherReason"]!= DBNull.Value)
                {
                    this.OtherReason.Value = ds.Rows[0]["OtherReason"].ToString();
                }
                if (ds.Rows[0]["DealerEndTyp"].ToString().Equals("Product Line Discontinued"))
                {
                    this.DealerEndReason3.Checked = true;
                }
                if (ds.Rows[0]["DealerEndReason"].ToString().Equals("Not Meeting Quota"))
                {
                    this.DealerEndReason2.Checked = true;
                }
                if (ds.Rows[0]["DealerEndReason"].ToString().Equals("Accounts Receivable Issues"))
                {
                    this.DealerEndReason1.Checked = true;
                }
                if (ds.Rows[0]["DealerEndReason"].ToString().Equals("Others"))
                {
                    this.DealerEndReason4.Checked = true;
                }
                if (ds.Rows[0]["TenderIssue"].ToString() == "0")
                {
                    this.TenderIssue0.Checked = true;
                }
                if (ds.Rows[0]["TenderIssue"].ToString() == "1")
                {
                    this.TenderIssue1.Checked = true;
                }
                if (ds.Rows[0]["TenderIssueRemark"].ToString() != "" && ds.Rows[0]["TenderIssueRemark"] != DBNull.Value)
                {
                    this.TenderIssueRemark.Value = ds.Rows[0]["TenderIssueRemark"].ToString();
                }
                if (ds.Rows[0]["Rebate"].ToString() != "" && ds.Rows[0]["Rebate"] != DBNull.Value)
                {

                    if (ds.Rows[0]["Rebate"].ToString().Equals("Exchange product")) 
                    {
                        this.Exchangeproduct1.Checked = true;
                    }
                    if (ds.Rows[0]["Rebate"].ToString().Equals("None"))
                    {
                        this.None1.Checked = true;
                    }
                    if (ds.Rows[0]["Rebate"].ToString().Equals("Refund")) 
                    {
                        this.Refund1.Checked = true;
                    }
                }
                if (ds.Rows[0]["RebateAmt"].ToString() != "" && ds.Rows[0]["RebateAmt"] != DBNull.Value)
                {
                    this.RebateAmt.Text = (Convert.ToDouble(ds.Rows[0]["RebateAmt"])).ToString();
                }
                if (ds.Rows[0]["Promotion"].ToString() != "" && ds.Rows[0]["Promotion"] != DBNull.Value)
                {
                    if (ds.Rows[0]["Promotion"].ToString() == "Exchange product")
                    {
                        this.Exchangeproduct2.Checked = true;
                    }
                    if (ds.Rows[0]["Promotion"].ToString() == "None")
                    {
                        this.None2.Checked = true;
                    }
                    if (ds.Rows[0]["Promotion"].ToString() == "Refund")
                    {
                        this.Refund2.Checked = true;
                    }
                }
                if (ds.Rows[0]["PromotionAmt"].ToString() != "" && ds.Rows[0]["PromotionAmt"] != DBNull.Value)
                {
                    this.PromotionAmt.Text = (Convert.ToDouble(ds.Rows[0]["PromotionAmt"])).ToString();

                }
                if (ds.Rows[0]["Complaint"].ToString() != "" && ds.Rows[0]["Complaint"] != DBNull.Value)
                {
                    if (ds.Rows[0]["Complaint"].ToString() == "Exchange product")
                    {
                        this.Exchangeproduct3.Checked = true;
                    }
                    if (ds.Rows[0]["Complaint"].ToString() == "None")
                    {
                        this.None3.Checked = true;
                    }
                    if (ds.Rows[0]["Complaint"].ToString() == "Refund")
                    {
                        this.Refund3.Checked = true;
                    }
                }
                if (ds.Rows[0]["ComplaintAmt"].ToString() != "" && ds.Rows[0]["ComplaintAmt"] != DBNull.Value)
                {
                    this.ComplaintAmt.Text = (Convert.ToDouble(ds.Rows[0]["ComplaintAmt"])).ToString();
                }

                if (ds.Rows[0]["GoodsReturn"].ToString() != "" && ds.Rows[0]["GoodsReturn"] != DBNull.Value)
                {
                    if (ds.Rows[0]["GoodsReturn"].ToString() == "0")
                    {
                        this.GoodsReturn0.Checked = true;
                    }
                    if (ds.Rows[0]["GoodsReturn"].ToString() == "1")
                    {
                        this.GoodsReturn1.Checked = true;
                    }
                }
                if (ds.Rows[0]["GoodsReturnAmt"].ToString() != "" && ds.Rows[0]["GoodsReturnAmt"] != DBNull.Value)
                {
                    this.GoodsReturnAmt.Text = (Convert.ToDouble(ds.Rows[0]["GoodsReturnAmt"])).ToString();
                }
                if (ds.Rows[0]["ReturnReason"].ToString() != "" && ds.Rows[0]["ReturnReason"] != DBNull.Value)
                {
                    if (ds.Rows[0]["ReturnReason"].ToString().Equals("Long Expiry Products (over 6 months)") )
                    {
                        this.ReturnReason1.Checked = true;
                    }
                    if (ds.Rows[0]["ReturnReason"].ToString().Equals("Short Expiry Products"))
                    {

                        this.ReturnReason2.Checked = true;
                    }
                    if (ds.Rows[0]["ReturnReason"].ToString().Equals("Expired & Damaged Products"))
                    {
                        this.ReturnReason3.Checked = true;
                    }
                }
                if (ds.Rows[0]["IsRGAAttach"].ToString() != "" && ds.Rows[0]["IsRGAAttach"] != DBNull.Value)
                {
                    if (ds.Rows[0]["IsRGAAttach"].ToString() == "0")
                    {
                        this.IsRGAAttach0.Checked = true;
                    }
                    if (ds.Rows[0]["IsRGAAttach"].ToString() == "1")
                    {
                        this.IsRGAAttach1.Checked = true;
                    }
                }
                if (ds.Rows[0]["CreditMemo"].ToString() != "" && ds.Rows[0]["CreditMemo"] != DBNull.Value)
                {
                    if (ds.Rows[0]["CreditMemo"].ToString() == "0")
                    {
                        this.CreditMemo0.Checked = true;
                    }
                    if (ds.Rows[0]["CreditMemo"].ToString() == "1")
                    {
                        this.CreditMemo1.Checked = true;
                    }
                }
                if (ds.Rows[0]["CreditMemoRemark"].ToString() != "" && ds.Rows[0]["CreditMemoRemark"] != DBNull.Value)
                {
                    this.CreditMemoRemark.Text = ds.Rows[0]["CreditMemoRemark"].ToString();
                }
                if (ds.Rows[0]["IsPendingPayment"].ToString() != "" && ds.Rows[0]["IsPendingPayment"] != DBNull.Value)
                {
                    if (ds.Rows[0]["IsPendingPayment"].ToString() == "0")
                    {
                        this.IsPendingPayment0.Checked = true;
                    }
                    if (ds.Rows[0]["IsPendingPayment"].ToString() == "1")
                    {
                        this.IsPendingPayment1.Checked = true;
                    }
                }
                if (ds.Rows[0]["PendingAmt"].ToString() != "" && ds.Rows[0]["PendingAmt"] != DBNull.Value)
                {

                    this.PendingAmt.Text = (Convert.ToDouble(ds.Rows[0]["PendingAmt"])).ToString();
                }
                if (ds.Rows[0]["PendingRemark"].ToString() != "" && ds.Rows[0]["PendingRemark"] != DBNull.Value)
                {
                    this.PendingRemark.Value = ds.Rows[0]["PendingRemark"].ToString();
                }
                if (ds.Rows[0]["CurrentAR"].ToString() != "" && ds.Rows[0]["CurrentAR"] != DBNull.Value)
                {
                    this.CurrentAR.Text = ds.Rows[0]["CurrentAR"].ToString();
                }
                if (ds.Rows[0]["CashDeposit"].ToString() != "" && ds.Rows[0]["CashDeposit"] != DBNull.Value)
                {
                    if (ds.Rows[0]["CashDeposit"].ToString() == "0")
                    {
                        this.CashDeposit0.Checked = true;
                    }
                    if (ds.Rows[0]["CashDeposit"].ToString() == "1")
                    {
                        this.CashDeposit1.Checked = true;
                    }
                }
                if (ds.Rows[0]["CashDepositAmt"].ToString() != "" && ds.Rows[0]["CashDepositAmt"] != DBNull.Value)
                {
                    this.CashDepositAmt.Text = ds.Rows[0]["CashDepositAmt"].ToString();
                }
                if (ds.Rows[0]["BGuarantee"].ToString() != "" && ds.Rows[0]["BGuarantee"] != DBNull.Value)
                {
                    if (ds.Rows[0]["BGuarantee"].ToString() == "0")
                    {
                        this.BGuarantee0.Checked = true;
                    }
                    if (ds.Rows[0]["BGuarantee"].ToString() == "1")
                    {
                        this.BGuarantee1.Checked = true;
                    }
                }
                if (ds.Rows[0]["BGuaranteeAmt"].ToString() != "" && ds.Rows[0]["BGuaranteeAmt"] != DBNull.Value)
                {
                    this.BGuaranteeAmt.Text = ds.Rows[0]["BGuaranteeAmt"].ToString();
                }
                if (ds.Rows[0]["CGuarantee"].ToString() != "" && ds.Rows[0]["CGuarantee"] != DBNull.Value)
                {
                    if (ds.Rows[0]["CGuarantee"].ToString() == "0")
                    {
                        this.CGuarantee0.Checked = true;
                    }
                    if (ds.Rows[0]["CGuarantee"].ToString() == "1")
                    {
                        this.CGuarantee1.Checked = true;
                    }
                }
                if (ds.Rows[0]["CGuaranteeAmt"].ToString() != "" && ds.Rows[0]["CGuaranteeAmt"] != DBNull.Value)
                {
                    this.CGuaranteeAmt.Text = ds.Rows[0]["CGuaranteeAmt"].ToString();
                }
                if (ds.Rows[0]["Inventory"].ToString() != "" && ds.Rows[0]["Inventory"] != DBNull.Value)
                {
                    if (ds.Rows[0]["Inventory"].ToString() == "0")
                    {
                        this.Inventory0.Checked = true;
                    }
                    if (ds.Rows[0]["Inventory"].ToString() == "1")
                    {
                        this.Inventory1.Checked = true;
                    }
                }
                if (ds.Rows[0]["InventoryAmt"].ToString() != "" && ds.Rows[0]["InventoryAmt"] != DBNull.Value)
                {
                    this.InventoryAmt.Text = ds.Rows[0]["InventoryAmt"].ToString();
                }
                if (ds.Rows[0]["EstimatedAR"].ToString() != "" && ds.Rows[0]["EstimatedAR"] != DBNull.Value)
                {
                    this.EstimatedAR.Text = (Convert.ToDouble(ds.Rows[0]["EstimatedAR"])).ToString();
                }
                if (ds.Rows[0]["Wirteoff"].ToString() != "" && ds.Rows[0]["Wirteoff"] != DBNull.Value)
                {
                    this.Wirteoff.Value = ds.Rows[0]["Wirteoff"].ToString();
                }
                if (ds.Rows[0]["PaymentPlan"].ToString() != "" && ds.Rows[0]["PaymentPlan"] != DBNull.Value)
                {
                    this.PaymentPlan.Value = ds.Rows[0]["PaymentPlan"].ToString();
                }
                if (ds.Rows[0]["Reserve"].ToString() != "" && ds.Rows[0]["Reserve"] != DBNull.Value)
                {
                    if (ds.Rows[0]["Reserve"].ToString() == "0")
                    {
                        this.Reserve0.Checked = true;
                    }
                    if (ds.Rows[0]["Reserve"].ToString() == "1")
                    {
                        this.Reserve1.Checked = true;
                    }
                }
                if (ds.Rows[0]["ReserveAmt"].ToString() != "" && ds.Rows[0]["ReserveAmt"] != DBNull.Value)
                {
                    this.ReserveAmt.Text = (Convert.ToDouble(ds.Rows[0]["ReserveAmt"])).ToString();
                }
                if (ds.Rows[0]["ReserveType"].ToString() != "" && ds.Rows[0]["ReserveType"] != DBNull.Value)
                {
                    if (ds.Rows[0]["ReserveType"].ToString() == "Other")
                    {
                        this.Other.Checked = true;
                    }
                    if (ds.Rows[0]["ReserveType"].ToString() == "Sales Return")
                    {
                        this.SalesReturn.Checked = true;
                    }
                    if (ds.Rows[0]["ReserveType"].ToString() == "Settlement")
                    {
                        this.Settlement.Checked = true;
                    }
                    if (ds.Rows[0]["ReserveType"].ToString() == "Bad Debt")
                    {
                        this.BadDebt.Checked = true;
                    }
                }
                if (ds.Rows[0]["TakeOver"].ToString() != "" && ds.Rows[0]["TakeOver"] != DBNull.Value)
                {
                    this.TakeOver.Value = ds.Rows[0]["TakeOver"].ToString();
                }
                if (ds.Rows[0]["TakeOverType"].ToString() != "" && ds.Rows[0]["TakeOverType"] != DBNull.Value)
                {
                    if (ds.Rows[0]["TakeOverType"].ToString() == "BSC")
                    {
                        this.BSC.Checked = true;
                    }
                    if (ds.Rows[0]["TakeOverType"].ToString() == "LP")
                    {
                        this.LP.Checked = true;
                    }
                    if (ds.Rows[0]["TakeOverType"].ToString() == "T1")
                    {
                        this.T1.Checked = true;
                    }
                    if (ds.Rows[0]["TakeOverType"].ToString() == "T2")
                    {
                        this.T2.Checked = true;
                    }
                }
                if (ds.Rows[0]["TakeOverIsNew"].ToString() != "" && ds.Rows[0]["TakeOverIsNew"] != DBNull.Value)
                {
                    if (ds.Rows[0]["TakeOverIsNew"].ToString() == "1")
                    {
                        this.TakeOverIsNew1.Checked = true;
                    }
                    if (ds.Rows[0]["TakeOverIsNew"].ToString() == "0")
                    {
                        this.TakeOverIsNew0.Checked = true;
                    }
                }
                if (ds.Rows[0]["Notified"].ToString() != "" && ds.Rows[0]["Notified"] != DBNull.Value)
                {
                    if (ds.Rows[0]["Notified"].ToString() == "1")
                    {
                        this.Notified1.Checked = true;
                    }
                    if (ds.Rows[0]["Notified"].ToString() == "0")
                    {
                        this.Notified0.Checked = true;
                    }
                }
                if (ds.Rows[0]["WhenNotify"].ToString() != "" && ds.Rows[0]["WhenNotify"] != DBNull.Value)
                {
                    this.WhenNotify.SelectedDate = Convert.ToDateTime(ds.Rows[0]["WhenNotify"].ToString());
                }
                if (ds.Rows[0]["WhenSettlement"].ToString() != "" && ds.Rows[0]["WhenSettlement"] != DBNull.Value)
                {
                    this.WhenSettlement.SelectedDate = Convert.ToDateTime(ds.Rows[0]["WhenSettlement"].ToString());
                }
                if (ds.Rows[0]["WhenHandover"].ToString() != "" && ds.Rows[0]["WhenHandover"] != DBNull.Value)
                {
                    this.WhenHandover.SelectedDate = Convert.ToDateTime(ds.Rows[0]["WhenHandover"].ToString());
                }
                if (ds.Rows[0]["FollowUp"].ToString() != "" && ds.Rows[0]["FollowUp"] != DBNull.Value)
                {
                    if (ds.Rows[0]["FollowUp"].ToString() == "1")
                    {
                        this.FollowUp1.Checked = true;
                    }
                    if (ds.Rows[0]["FollowUp"].ToString() == "0")
                    {
                        this.FollowUp0.Checked = true;
                    }
                }
                if (ds.Rows[0]["FollowUpRemark"].ToString() != "" && ds.Rows[0]["FollowUpRemark"] != DBNull.Value)
                {
                    this.FollowUpRemark.Value = ds.Rows[0]["FollowUpRemark"].ToString();
                }
                if (ds.Rows[0]["FieldOperation"].ToString() != "" && ds.Rows[0]["FieldOperation"] != DBNull.Value)
                {
                    if (ds.Rows[0]["FieldOperation"].ToString() == "1")
                    {
                        this.FieldOperation1.Checked = true;
                    }
                    if (ds.Rows[0]["FieldOperation"].ToString() == "0")
                    {
                        this.FieldOperation0.Checked = true;
                    }
                }
                if (ds.Rows[0]["SubmitImplant"].ToString() != "" && ds.Rows[0]["SubmitImplant"] != DBNull.Value)
                {
                    if (ds.Rows[0]["SubmitImplant"].ToString() == "1")
                    {
                        this.SubmitImplant1.Checked = true;
                    }
                    if (ds.Rows[0]["SubmitImplant"].ToString() == "0")
                    {
                        this.SubmitImplant0.Checked = true;
                    }
                }
                if (ds.Rows[0]["SubmitImplantRemark"].ToString() != "" && ds.Rows[0]["SubmitImplantRemark"] != DBNull.Value)
                {
                    this.SubmitImplantRemark.SelectedDate = Convert.ToDateTime(ds.Rows[0]["SubmitImplantRemark"]);
                }
                if (ds.Rows[0]["AdverseEvent"].ToString() != "" && ds.Rows[0]["AdverseEvent"] != DBNull.Value)
                {
                    if (ds.Rows[0]["AdverseEvent"].ToString() == "1")
                    {
                        this.AdverseEvent1.Checked = true;
                    }
                    if (ds.Rows[0]["AdverseEvent"].ToString() == "0")
                    {
                        this.AdverseEvent0.Checked = true;
                    }
                }
                if (ds.Rows[0]["AdverseEventRemark"].ToString() != "" && ds.Rows[0]["AdverseEventRemark"] != DBNull.Value)
                {
                    this.AdverseEventRemark.Value = ds.Rows[0]["AdverseEventRemark"].ToString();
                }
                if (ds.Rows[0]["FieldOperationRemark"].ToString() != "" && ds.Rows[0]["FieldOperationRemark"] != DBNull.Value)
                {
                    this.FieldOperationRemark.Value = ds.Rows[0]["FieldOperationRemark"].ToString();
                }

                if (ds.Rows[0]["InventoryDisposeRemark2"].ToString() != "" && ds.Rows[0]["InventoryDisposeRemark2"] != DBNull.Value)
                {

                    this.InventoryDisposeRemark2.Value = ds.Rows[0]["InventoryDisposeRemark2"].ToString();
                }
                if (ds.Rows[0]["NotifiedNCM"].ToString() != "" && ds.Rows[0]["NotifiedNCM"] != DBNull.Value)
                {
                    if (ds.Rows[0]["NotifiedNCM"].ToString() == "1")
                    {
                        this.NotifiedNCM1.Checked = true;
                    }
                    if (ds.Rows[0]["NotifiedNCM"].ToString() == "0")
                    {
                        this.NotifiedNCM0.Checked = true;
                    }
                }
                if (ds.Rows[0]["Reviewed"].ToString() != "" && ds.Rows[0]["Reviewed"] != DBNull.Value)
                {
                    if (ds.Rows[0]["Reviewed"].ToString() == "1")
                    {
                        this.Reviewed1.Checked = true;
                    }
                    if (ds.Rows[0]["Reviewed"].ToString() == "0")
                    {
                        this.Reviewed0.Checked = true;
                    }
                }
                if (ds.Rows[0]["Handover"].ToString() != "" && ds.Rows[0]["Handover"] != DBNull.Value)
                {
                    if (ds.Rows[0]["Handover"].ToString() == "1")
                    {
                        this.Handover1.Checked = true;
                    }
                    if (ds.Rows[0]["Handover"].ToString() == "0")
                    {
                        this.Handover0.Checked = true;
                    }
                }
                if (ds.Rows[0]["CurrentQuota"].ToString() != "" && ds.Rows[0]["CurrentQuota"] != DBNull.Value)
                {

                    this.CurrentQuota.Text = (Convert.ToDouble(ds.Rows[0]["CurrentQuota"])).ToString();
                }
                if (ds.Rows[0]["ActualSales"].ToString() != "" && ds.Rows[0]["ActualSales"] != DBNull.Value)
                {
                    this.ActualSales.Text = (Convert.ToDouble(ds.Rows[0]["ActualSales"])).ToString();
                }
                if (ds.Rows[0]["TenderDetails"].ToString() != "" && ds.Rows[0]["TenderDetails"] != DBNull.Value)
                {
                    this.TenderDetails.Value = ds.Rows[0]["TenderDetails"].ToString();
                }
                if (ds.Rows[0]["InventoryDisposeRemark1"].ToString() != "" && ds.Rows[0]["InventoryDisposeRemark1"] != DBNull.Value)
                {
                    this.InventoryDisposeRemark1.Value = ds.Rows[0]["InventoryDisposeRemark1"].ToString();
                }
                if (ds.Rows[0]["HandoverRemark"].ToString() != "" && ds.Rows[0]["HandoverRemark"] != DBNull.Value)
                {
                    this.HandoverRemark.Value = ds.Rows[0]["HandoverRemark"].ToString();
                }
                if (ds.Rows[0]["InventoryDispose"].ToString() != "" && ds.Rows[0]["InventoryDispose"] != DBNull.Value)
                {
                    if (ds.Rows[0]["InventoryDispose"].ToString() == "BSC")
                    {
                        this.InventoryDispose1.Checked = true;
                    }
                    if (ds.Rows[0]["InventoryDispose"].ToString() == "Dealer")
                    {
                        this.InventoryDispose2.Checked = true;
                    }
                    if (ds.Rows[0]["InventoryDispose"].ToString() == "Other")
                    {
                        this.InventoryDispose3.Checked = true;
                    }
                }
            }

        }
        [AjaxMethod]
        public string SaveSubmint()
        {
            insertTerminationHandoverTemp();
            insertTerminationMainTemp();
            insertTerminationNCMTemp();
            insertTerminationEndFormTemp();
            insertTerminationStatusTemp();

            bool result = cts.SaveAmendmentUpdate(this.hidUpdateId.Value.ToString());
            if (result)
            {
                //完成修改后，清空修改主键ID，更新附件表
                this.hidUpdateId.Value = Guid.NewGuid().ToString();
                this.gpAttachment.Reload();
                this.gplog.Reload();
                return "success";
            }
            else
            {
                return "error";
            }
        }
        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            try
            {
                if (this.FileUploadField1.HasFile)
                {
                    bool error = false;
                    string fileName = FileUploadField1.PostedFile.FileName;
                    string fileExtention = string.Empty;
                    string fileExt = string.Empty;
                    if (fileName.LastIndexOf(".") < 0)
                    {
                        error = true;
                    }
                    else
                    {
                        fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
                        fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                    }

                    if (error)
                    {
                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.INFO,
                            Title = "文件错误",
                            Message = "请上传正确的文件！"
                        });

                        return;
                    }

                    //构造文件名称

                    string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;

                    //上传文件在Upload文件夹

                    string file = Server.MapPath("~") + "\\Upload\\UploadFile\\TenderFile\\" + newFileName;


                    //文件上传
                    FileUploadField1.PostedFile.SaveAs(file);

                    Attachment attach = new Attachment();
                    attach.Id = Guid.NewGuid();
                    attach.MainId = new Guid(this.hidUpdateId.Value.ToString());
                    attach.Name = fileExtention;
                    attach.Url = newFileName;
                    attach.Type = "UpdateContractAdmin";
                    attach.UploadDate = DateTime.Now;
                   

                    attach.UploadUser = new Guid(_context.User.Id);
                    //维护附件信息
                    bool ckUpload = attachmentBLL.AddAttachment(attach);

                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "上传成功",
                        Message = "已成功上传文件！"
                    });
                }
                else
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "上传失败",
                        Message = "文件未被成功上传！"
                    });
                }
            }
            catch (Exception ex)
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "上传失败",
                    Message = ex.ToString()
                });
            }
        }
        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                //逻辑删除
                attachmentBLL.DelAttachment(new Guid(id));
                //物理删除
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\TenderFile");
                File.Delete(uploadFile + "\\" + fileName);
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除失败").Show();
            }
        }

        protected void insertTerminationHandoverTemp()
        {
            Hashtable Handover = new Hashtable();
            Handover.Add("Temp_Id", this.hidUpdateId.Value);
            Handover.Add("ContractId", this.contractid.Value);
            if (BSC.Checked == true)
            {
                Handover.Add("TakeOverType", "BSC");
            }
            if (LP.Checked == true)
            {
                Handover.Add("TakeOverType", "LP");
            }
            if (T1.Checked == true)
            {
                Handover.Add("TakeOverType", "T1");
            }
            if (T2.Checked == true)
            {
                Handover.Add("TakeOverType", "T2");
            }
            if (TakeOverIsNew1.Checked == true)
            {
                Handover.Add("TakeOverIsNew", "1");
            }
            if (TakeOverIsNew0.Checked == true)
            {
                Handover.Add("TakeOverIsNew", "0");
            }
            if (FollowUp1.Checked == true)
            {
                Handover.Add("FollowUp", "1");
            }
            if (FollowUp0.Checked == true)
            {
                Handover.Add("FollowUp", "0");
            }
            if (FieldOperation1.Checked == true)
            {
                Handover.Add("FieldOperation", "1");
            }
            if (FieldOperation0.Checked == true)
            {
                Handover.Add("FieldOperation", "0");
            }
            if (AdverseEvent1.Checked == true)
            {
                Handover.Add("AdverseEvent", "1");
            }
            if (AdverseEvent0.Checked == true)
            {
                Handover.Add("AdverseEvent", "0");
            }
            if (NotifiedNCM1.Checked == true)
            {
                Handover.Add("NotifiedNCM", "1");
            }
            if (NotifiedNCM0.Checked == true)
            {
                Handover.Add("NotifiedNCM", "0");
            }
            if (!string.IsNullOrEmpty(TakeOver.Value.ToString()))
            {
                Handover.Add("TakeOver", TakeOver.Value.ToString());
            }
            if (!this.WhenNotify.IsNull)
            {
                Handover.Add("WhenNotify", WhenNotify.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.WhenSettlement.IsNull)
            {
                Handover.Add("WhenSettlement", WhenSettlement.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.WhenHandover.IsNull)
            {
                Handover.Add("WhenHandover", WhenHandover.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(FollowUpRemark.Value.ToString()))
            {
                Handover.Add("FollowUpRemark", FollowUpRemark.Value.ToString());
            }
            if (!string.IsNullOrEmpty(FieldOperationRemark.Value.ToString()))
            {
                Handover.Add("FieldOperationRemark", FieldOperationRemark.Value.ToString());
            }
            if (!string.IsNullOrEmpty(AdverseEventRemark.Value.ToString()))
            {
                Handover.Add("AdverseEventRemark", AdverseEventRemark.Value.ToString());
            }
            if (!this.SubmitImplantRemark.IsNull)
            {
                Handover.Add("SubmitImplantRemark", SubmitImplantRemark.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(InventoryDisposeRemark2.Value.ToString()))
            {
                Handover.Add("InventoryDisposeRemark2", InventoryDisposeRemark2.Value.ToString());
            }
            if (!string.IsNullOrEmpty(InventoryDisposeRemark1.Value.ToString()))
            {
                Handover.Add("InventoryDisposeRemark1", InventoryDisposeRemark1.Value.ToString());
            }
            if (this.SubmitImplant1.Checked == true)
            {
                Handover.Add("SubmitImplant", "1");
            }
            if (this.SubmitImplant0.Checked == true)
            {
                Handover.Add("SubmitImplant", "0");
            }
            if(Notified1.Checked == true)
            {
                Handover.Add("Notified", "1");
            }
            if (Notified0.Checked == true)
            {
                Handover.Add("Notified", "0");
            }
            if (this.InventoryDispose1.Checked == true)
            {
                Handover.Add("InventoryDispose", "BSC");
            }
            if (this.InventoryDispose2.Checked == true)
            {
                Handover.Add("InventoryDispose", "Dealer");
            }
            if (this.InventoryDispose3.Checked == true)
            {
                Handover.Add("InventoryDispose", "Other");
            }
            cts.insertTerminationHandoverTemp(Handover);
        }

        protected void insertTerminationNCMTemp()
        {
            Hashtable NCM = new Hashtable();
            NCM.Add("Temp_Id", this.hidUpdateId.Value);
            NCM.Add("ContractId", this.contractid.Value);

            if (NotifiedNCM1.Checked == true)
            {
                NCM.Add("Notified", "1");
            }
            if (NotifiedNCM0.Checked == true)
            {
                NCM.Add("Notified", "0");
            }
            if (Reviewed1.Checked == true)
            {
                NCM.Add("Reviewed", "1");
            }
            if (Reviewed0.Checked == true)
            {
                NCM.Add("Reviewed", "0");
            }
            if (Handover1.Checked == true)
            {
                NCM.Add("Handover", "1");
            }
            if (Handover0.Checked == true)
            {
                NCM.Add("Handover", "0");
            }
            if (!string.IsNullOrEmpty(HandoverRemark.Value.ToString()))
            {
                NCM.Add("HandoverRemark", HandoverRemark.Value.ToString());
            }
            cts.insertTerminationNCMTemp(NCM);



        }

        protected void insertTerminationEndFormTemp()
        {
            Hashtable EndFormTemp = new Hashtable();
            EndFormTemp.Add("Temp_Id", this.hidUpdateId.Value);
            EndFormTemp.Add("ContractId", this.contractid.Value);
            if (!string.IsNullOrEmpty(CurrentQuota.Value.ToString()))
            {
                EndFormTemp.Add("CurrentQuota", CurrentQuota.Value.ToString());
            }
            if (!string.IsNullOrEmpty(ActualSales.Value.ToString()))
            {
                EndFormTemp.Add("ActualSales", ActualSales.Value.ToString());
            }
            if (!string.IsNullOrEmpty(TenderDetails.Value.ToString()))
            {
                EndFormTemp.Add("TenderDetails", TenderDetails.Value.ToString());
            }
            cts.insertTerminationEndFormTemp(EndFormTemp);

        }

        protected void insertTerminationStatusTemp()
        {
            Hashtable StatusTemp = new Hashtable();
            StatusTemp.Add("Temp_Id", this.hidUpdateId.Value);
            StatusTemp.Add("ContractId", this.contractid.Value);
            if (TenderIssue1.Checked == true)
            {
                StatusTemp.Add("TenderIssue", "1");
            }
            if (TenderIssue0.Checked == true)
            {
                StatusTemp.Add("TenderIssue", "0");
            }
            if (!string.IsNullOrEmpty(TenderIssueRemark.Value.ToString()))
            {
                StatusTemp.Add("TenderIssueRemark", TenderIssueRemark.Value.ToString());
            }
            if (Exchangeproduct1.Checked == true)
            {
                StatusTemp.Add("Rebate", "Exchange product");
            }
            if (Refund1.Checked == true)
            {
                StatusTemp.Add("Rebate", "Refund");
            }
            if (None1.Checked == true)
            {
                StatusTemp.Add("Rebate", "None");
            }
            if (!string.IsNullOrEmpty(RebateAmt.Value.ToString()))
            {
                StatusTemp.Add("RebateAmt", RebateAmt.Value.ToString());
            }
            if (Exchangeproduct2.Checked == true)
            {
                StatusTemp.Add("Promotion", "Exchange product");
            }
            if (Refund2.Checked == true)
            {
                StatusTemp.Add("Promotion", "Refund");
            }
            if (None2.Checked == true)
            {
                StatusTemp.Add("Promotion", "None");
            }
            if (!string.IsNullOrEmpty(PromotionAmt.Value.ToString()))
            {
                StatusTemp.Add("PromotionAmt", PromotionAmt.Value.ToString());
            }

            if (Exchangeproduct3.Checked == true)
            {
                StatusTemp.Add("Complaint", "Exchange product");
            }
            if (Refund3.Checked == true)
            {
                StatusTemp.Add("Complaint", "Refund");
            }
            if (None3.Checked == true)
            {
                StatusTemp.Add("Complaint", "None");
            }
            if (!string.IsNullOrEmpty(ComplaintAmt.Value.ToString()))
            {
                StatusTemp.Add("ComplaintAmt", ComplaintAmt.Value.ToString());
            }
            if (GoodsReturn1.Checked == true)
            {
                StatusTemp.Add("GoodsReturn", "1");
            }
            if (GoodsReturn0.Checked == true)
            {
                StatusTemp.Add("GoodsReturn", "0");
            }
            if (!string.IsNullOrEmpty(GoodsReturnAmt.Value.ToString()))
            {
                StatusTemp.Add("GoodsReturnAmt", GoodsReturnAmt.Value.ToString());
            }
            if (ReturnReason1.Checked == true)
            {
                StatusTemp.Add("ReturnReason", "Long Expiry Products (over 6 montStatusTemp)");
            }
            if (ReturnReason2.Checked == true)
            {
                StatusTemp.Add("ReturnReason", "Short Expiry Products");
            }
            if (ReturnReason3.Checked == true)
            {
                StatusTemp.Add("ReturnReason", "Expired & Damaged Products");
            }
            if (IsRGAAttach1.Checked == true)
            {
                StatusTemp.Add("IsRGAAttach", "1");
            }
            if (IsRGAAttach0.Checked == true)
            {
                StatusTemp.Add("IsRGAAttach", "0");
            }
            if (!string.IsNullOrEmpty(CreditMemoRemark.Value.ToString()))
            {
                StatusTemp.Add("CreditMemoRemark", CreditMemoRemark.Value.ToString());
            }
            if (CreditMemo1.Checked == true)
            {
                StatusTemp.Add("CreditMemo", "1");
            }
            if (CreditMemo0.Checked == true)
            {
                StatusTemp.Add("CreditMemo", "0");
            }
            if (IsPendingPayment1.Checked == true)
            {
                StatusTemp.Add("IsPendingPayment", "1");
            }
            if (IsPendingPayment0.Checked == true)
            {
                StatusTemp.Add("IsPendingPayment", "0");
            }
            if (!string.IsNullOrEmpty(PendingAmt.Value.ToString()))
            {
                StatusTemp.Add("PendingAmt", PendingAmt.Value.ToString());
            }
            if (!string.IsNullOrEmpty(PendingRemark.Value.ToString()))
            {
                StatusTemp.Add("PendingRemark", PendingRemark.Value.ToString());
            }
            if (!string.IsNullOrEmpty(CurrentAR.Value.ToString()))
            {
                StatusTemp.Add("CurrentAR", CurrentAR.Value.ToString());
            }
            if (CashDeposit1.Checked == true)
            {
                StatusTemp.Add("CashDeposit", "1");
            }
            if (CashDeposit0.Checked == true)
            {
                StatusTemp.Add("CashDeposit", "0");
            }
            if (!string.IsNullOrEmpty(CashDepositAmt.Value.ToString()))
            {
                StatusTemp.Add("CashDepositAmt", CashDepositAmt.Value.ToString());
            }
            if (BGuarantee1.Checked == true)
            {
                StatusTemp.Add("BGuarantee", "1");
            }
            if (BGuarantee0.Checked == true)
            {
                StatusTemp.Add("BGuarantee", "0");
            }
            if (!string.IsNullOrEmpty(BGuaranteeAmt.Value.ToString()))
            {
                StatusTemp.Add("BGuaranteeAmt", BGuaranteeAmt.Value.ToString());
            }
            if (CGuarantee1.Checked == true)
            {
                StatusTemp.Add("CGuarantee", "1");
            }
            if (CGuarantee0.Checked == true)
            {
                StatusTemp.Add("CGuarantee", "0");
            }
            if (!string.IsNullOrEmpty(CGuaranteeAmt.Value.ToString()))
            {
                StatusTemp.Add("CGuaranteeAmt", CGuaranteeAmt.Value.ToString());
            }
            if (Inventory1.Checked == true)
            {
                StatusTemp.Add("Inventory", "1");
            }
            if (Inventory0.Checked == true)
            {
                StatusTemp.Add("Inventory", "0");
            }
            if (!string.IsNullOrEmpty(InventoryAmt.Value.ToString()))
            {
                StatusTemp.Add("InventoryAmt", InventoryAmt.Value.ToString());
            }
            if (!string.IsNullOrEmpty(EstimatedAR.Value.ToString()))
            {
                StatusTemp.Add("EstimatedAR", EstimatedAR.Value.ToString());
            }
            if (!string.IsNullOrEmpty(Wirteoff.Value.ToString()))
            {
                StatusTemp.Add("Wirteoff", Wirteoff.Value.ToString());
            }
            if (!string.IsNullOrEmpty(PaymentPlan.Value.ToString()))
            {
                StatusTemp.Add("PaymentPlan", PaymentPlan.Value.ToString());
            }
            if (Reserve1.Checked == true)
            {
                StatusTemp.Add("Reserve", "1");
            }
            if (Reserve0.Checked == true)
            {
                StatusTemp.Add("Reserve", "0");
            }
            if (BadDebt.Checked == true)
            {
                StatusTemp.Add("ReserveType", "Bad Debt");
            }
            if (Settlement.Checked == true)
            {
                StatusTemp.Add("ReserveType", "Settlement");
            }
            if (SalesReturn.Checked == true)
            {
                StatusTemp.Add("ReserveType", "SalesReturn");
            }
            if (Other.Checked == true)
            {
                StatusTemp.Add("ReserveType", "Other");
            }
            if (!string.IsNullOrEmpty(ReserveAmt.Value.ToString()))
            {
                StatusTemp.Add("ReserveAmt", ReserveAmt.Value.ToString());
            }
            cts.insertTerminationStatusTemp(StatusTemp);

        }

        protected void insertTerminationMainTemp()
        {
            Hashtable hs = new Hashtable();
            hs.Add("UpdateUser", _context.User.Id);
            hs.Add("UpdateDate", DateTime.Now);
            if (DealerEndTyp0.Checked == true)
            {
                hs.Add("DealerEndTyp", "Non-Renewal");
            }
            if (DealerEndTyp1.Checked == true)
            {
                hs.Add("DealerEndTyp", "Termination");
            }
            if (!this.PlanExpiration.IsNull)
            {
                hs.Add("PlanExpiration", this.PlanExpiration.SelectedDate.ToString("yyyyMMdd"));
            }
            if (DealerEndReason1.Checked == true)
            {
                hs.Add("DealerEndReason", "Accounts Receivable Issues");
            }
            if (DealerEndReason2.Checked == true)
            {
                hs.Add("DealerEndReason", "Not Meeting Quota");
            }
            if (DealerEndReason3.Checked == true)
            {
                hs.Add("DealerEndReason", "Product Line Discontinued");
            }
            if (DealerEndReason4.Checked == true)
            {
                hs.Add("DealerEndReason", "Others");
            }
            if (!string.IsNullOrEmpty(OtherReason.Value.ToString()))
            {
                hs.Add("OtherReason", OtherReason.Value.ToString());
            }
            hs.Add("Temp_Id", hidUpdateId.Value);
            hs.Add("ContractId", this.contractid.Value);
            cts.insertTerminationMainTemp(hs);
        }
    }
}