using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using Coolite.Ext.Web;
using System.Data;
using DMS.Business.Contract;
using DMS.Model;
using DMS.Model.Data;
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
    using System.Text.RegularExpressions;
    using DMS.Business;
    using System.Collections;
    public partial class ContractThirdPartyV2 : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IThirdPartyDisclosureService _thirdPartyDisclosure = new ThirdPartyDisclosureService();
        private IDealerMasters _dealers = Global.ApplicationContainer.Resolve<IDealerMasters>();
        private IContractMasterBLL masterBll = new ContractMasterBLL();
        private IDealerMasters _dealerMasters = new DealerMasters();
        private IMessageBLL _messageBLL = new MessageBLL();
        private IAttachmentBLL _attachmentBLL = null;
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
                hidalert.Value = "Y";

                this.hidall.Value = "";
                this.submintname.Value = string.Empty;
                this.job.Value = string.Empty;
                if (Request.QueryString["DealerId"] != null)
                {
                    this.hdDmaId.Value = Request.QueryString["DealerId"];
                    DealerMaster dMaster = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));
                    this.pagedealername.Value = dMaster.ChineseName;

                    BindPageDate();
                    SynchronousHospital();
                }

                if (!RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                {
                    btnCreatePdf.Enabled = false;
                }
                if (this.hdDealerType.Value.ToString() == "T2" && !IsDealer || !RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation) && !IsDealer)
                {
                    this.GpWdAttachment.ColumnModel.SetHidden(4, true);
                    this.btnPolicyAttachmentAdd.Hidden = true;
                    this.hidall.Value = "true";
                }


                if (IsDealer)

                {
                    DealerMaster dMaster = _dealerMasters.GetDealerMaster(new Guid(_context.User.CorpId.ToString()));
                    this.DealerName.Value = dMaster.ChineseName;

                }



            }

        }
        private void BindPageDate()
        {
            DealerMaster dMaster = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));

            this.tfDealerNameCn.Text = dMaster.ChineseName;

            this.hdDealerType.Value = dMaster.DealerType.ToString();
        }

        protected void Store_RefreshThirdPartyDisclosure(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("DmaId", this.hdDmaId.Value.ToString());
            if (!string.IsNullOrEmpty(this.txtHospitalName.Text))
            {
                obj.Add("HospitalName", this.txtHospitalName.Text);
            }
            if (!string.IsNullOrEmpty(this.Type.SelectedItem.Value))
            {
                obj.Add("type", this.Type.SelectedItem.Value);
            }

            DataTable dt = _thirdPartyDisclosure.ThirdPartylist(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.ThirdPartyDisclosureStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            ThirdPartyDisclosureStore.DataSource = dt;
            ThirdPartyDisclosureStore.DataBind();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (!Convert.IsDBNull(dt.Rows[i]["EndDate"]))
                {
                    DateTime d1 = Convert.ToDateTime(dt.Rows[i]["EndDate"].ToString());
                    DateTime d2 = DateTime.Now;
                    if ((d1 - d2).TotalDays <= 30 && this.hidalert.Value.ToString() == "Y" && (d1 - d2).TotalDays >= 0)
                    {

                        Ext.Msg.Alert("提示", "黄色高亮条目表示需要进行续约的第三方公司，请尽快安排续约").Show();
                    }


                }

            }
            this.hidalert.Value = "";

        }

        protected void HospitalStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("DmaId", this.hdDmaId.Value.ToString());
            if (!string.IsNullOrEmpty(this.txtHospitalName.Text))
            {
                obj.Add("HospitalName", this.txtHospitalName.Text);
            }
            DataTable dt = _thirdPartyDisclosure.DealerAuthorizationHospital(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount).Tables[0];
            (this.HospitalStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            HospitalStore.DataSource = dt;
            HospitalStore.DataBind();

            if (this.hidall.Value.ToString() == "true")
            {
                this.DealerAuthorizationHospital.ColumnModel.SetHidden(2, true);
            }
        }

        protected void AttachmentStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataTable dt = attachmentBLL.GetAttachmentByMainId(new Guid(this.hiddenMainId.Value.ToString()), AttachmentType.HospitalThirdPart, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarAttachment.PageSize : e.Limit), out totalCount).Tables[0];
            (this.AttachmentStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.hiddenCountAttachment.Value = totalCount;
            AttachmentStore.DataSource = dt;
            AttachmentStore.DataBind();
        }

        protected void ProductLineStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {

            DataTable dt = _dealerMasters.GetDealerProductLine(new Guid(this.hdDmaId.Value.ToString())).Tables[0];
            CurrentProductLineStore.DataSource = dt;
            CurrentProductLineStore.DataBind();
        }












        [AjaxMethod]
        public void SaveThirdParty()
        {

            string massage = "";
            ThirdPartyDisclosureList ThirdParty = new ThirdPartyDisclosureList();

            if (String.IsNullOrEmpty(this.tfWinCompanyName.Text))
            {
                massage += "请填写公司名称<br/>";
            }
            if (String.IsNullOrEmpty(this.cbWinRs.SelectedItem.Value))
            {
                massage += "请填写与贵司或医院关系<br/>";
            }
            if (String.IsNullOrEmpty(this.hiddenProductLineName.Text))
            {
                massage += "请选择合作的产品线<br/>";
            }
            if (String.IsNullOrEmpty(this.job.Text))
            {
                massage += "请填写提交人手机<br/>";
            }
            if (String.IsNullOrEmpty(this.submintname.Text))
            {
                massage += "请填写提交人姓名/职务<br/>";
            }
            Verification(this.hiddenHospitalId.Value.ToString(), this.tfWinCompanyName.Text, this.hiddenProductLineName.Text, "申请审批中", this.cbWinRs.SelectedItem.Value);
            if (this.hidresful.Value.ToString() == "true")
            {

                massage += "具有相同的披露在审批中，不允许重复提交申请<br/>";
            }


            try
            {
                if (massage == "")
                {
                    //Create
                    if (this.hdtype.Value.ToString() == "new")
                    {
                        this.hidCompanyName.Value = this.tfWinCompanyName.Text;
                        if (RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) && this.hdDealerType.Value.ToString() == "T2" || this.hdDealerType.Value.ToString() != "T2" && !IsDealer && RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                        {
                            Verification(this.hiddenHospitalId.Value.ToString(), this.tfWinCompanyName.Text, this.hiddenProductLineName.Text, "申请审批通过", this.cbWinRs.SelectedItem.Value);
                            if (this.hidresful.Value.ToString() == "true")
                            {
                                Hashtable hs = new Hashtable();

                               
                                hs.Add("hosid", this.hiddenHospitalId.Value.ToString());
                                hs.Add("CompanyName", this.tfWinCompanyName.Text == "" ? this.hidCompanyName.Value.ToString() : this.tfWinCompanyName.Text);
                                hs.Add("rsm", this.cbWinRs.SelectedItem.Value.ToString());
                                hs.Add("productline", this.hiddenProductLineName.Text);
                                hs.Add("ApprovalStatus", "申请审批通过");
                                hs.Add("dmaid", this.hdDmaId.Value);
                                _thirdPartyDisclosure.updateendThirdPartyList(hs);
                                
                            }

                            this.hidhospitalname.Value = this.tfWinHospitalName.Text;
                            ThirdParty.Id = new Guid(this.hiddenMainId.Value.ToString());
                            ThirdParty.DmaId = new Guid(this.hdDmaId.Value.ToString());
                            //ThirdParty.ProductLineId = new Guid(this.hdProductLineId.Value.ToString());
                            ThirdParty.HosId = new Guid(this.hiddenHospitalId.Value.ToString());
                            ThirdParty.CompanyName = this.tfWinCompanyName.Text;
                            ThirdParty.Rsm = this.cbWinRs.SelectedItem.Value.ToString();
                            ThirdParty.CreatUser = new Guid(this._context.User.Id);
                            ThirdParty.CreatDate = DateTime.Now;
                            ThirdParty.ProductNameString = this.hiddenProductLineName.Text;
                            ThirdParty.ApprovalDate = DateTime.Now;
                            ThirdParty.Position = this.job.Value.ToString();
                            ThirdParty.SubmitterName = this.submintname.Value.ToString();
                            ThirdParty.ApprovalRemark = this.taWinApprovalRemark.Text;
                            ThirdParty.ApplicationNote = this.ApplicationNote.Text;
                            ThirdParty.ApprovalUser = new Guid(_context.User.Id);
                            ThirdParty.ApprovalStatus = "申请审批通过";
                            _thirdPartyDisclosure.InsertThirdPartyDisclosureListLp(ThirdParty);
                            //SandMailApproval("Approval", "EMAIL_ThirdParty_Approval");



                            Hashtable obj = new Hashtable();
                            obj.Add("DmaId", this.hdDmaId.Value.ToString());
                            DealerMaster dm = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));
                            //DataSet dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
                            DataSet dt = _thirdPartyDisclosure.ThirdPartyDisclosureListByBU(obj);
                            string Remarks = _context.UserName + "在" + DateTime.Now + "对" + dm.ChineseName + ":";
                            string hospital = dt.Tables[0].Rows[0]["HOS_HospitalName"].ToString();
                            string productline = dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() != null ? dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() : "";
                            Remarks += hospital + productline + "," + "申请审批通过";
                            Hashtable logobj = new Hashtable();
                            logobj.Add("ContractUser", _context.User.Id);
                            logobj.Add("DMAId", this.hdDmaId.Value.ToString());
                            logobj.Add("Remarks", Remarks);
                            _thirdPartyDisclosure.InsertContractLog(logobj);
                            SandMailApproval("new", "EMAIL_ThirdPartyListinsert_LPT2");
                            SandMailAudit();


                        }
                        else
                        {
                            ThirdParty.Id = new Guid(this.hiddenMainId.Value.ToString());
                            ThirdParty.DmaId = new Guid(this.hdDmaId.Value.ToString());
                            ThirdParty.HosId = new Guid(this.hiddenHospitalId.Value.ToString());
                            ThirdParty.CompanyName = this.tfWinCompanyName.Text;
                            ThirdParty.Rsm = this.cbWinRs.SelectedItem.Value.ToString();
                            ThirdParty.CreatUser = new Guid(this._context.User.Id);
                            ThirdParty.Position = this.job.Value.ToString();
                            ThirdParty.SubmitterName = this.submintname.Value.ToString();
                            ThirdParty.CreatDate = DateTime.Now;
                            ThirdParty.ProductNameString = this.hiddenProductLineName.Text;
                            ThirdParty.ApplicationNote = this.ApplicationNote.Text;
                            ThirdParty.ApprovalStatus = "申请审批中";


                            _thirdPartyDisclosure.SaveThirdPartyDisclosureList(ThirdParty);
                            ChangeAttachment("EMAIL_ThirdPartyInsert_LPCO");
                            SandMailAudit();
                        }
                    }



                    windowThirdParty.Hide();
                    gpThirdPartyDisclosure.Reload();

                    massage = "保存成功";

                    Ext.Msg.Alert("Success", massage).Show();
                }
                else
                {
                    throw new Exception(massage);
                }
            }
            catch
            {
                massage = massage.Substring(0, massage.Length - 5);
                Ext.Msg.Alert("Error", massage).Show();
            }
        }


        [AjaxMethod]
        public void DeleteThirdPartyDisclosureItem(string detailId)
        {
            if (!string.IsNullOrEmpty(detailId))
            {
                _thirdPartyDisclosure.DeleteThirdPartyDisclosureListById(new Guid(detailId));
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        [AjaxMethod]
        public void EditThirdPartyDisclosureItem(string detailId, string HospitalName, string HospitalId)
        {


            if (!string.IsNullOrEmpty(detailId))
            {
                this.hdtype.Value = "old";
                this.TabPanel1.ActiveTabIndex = 0;
                InitThirdPartyWindow(true);
                this.taWinApprovalRemark.Enabled = false;
                this.tfWinHospitalName.Enabled = false;
                this.begindate.Enabled = false;
                this.enddate.Enabled = false;
                this.btnWdProductLine.Enabled = false;
                this.tfWinCompanyName.Enabled = false;
                this.cbWinRs.Enabled = false;
                this.Productline.Enabled = false;
                this.ApplicationNote.Enabled = true;
                this.job.Enabled = false;
                this.taWinApprovalRemark.Enabled = false;
                this.submintname.Enabled = false;
                this.TerminationendDate.Enabled = false;
                this.ApplicationNote.Enabled = false;
                this.Productline.ReadOnly = false;
                LoadThirdPartyWindow(new Guid(detailId));



                //Set Value
                this.hiddenMainId.Value = detailId;
                this.hiddenWinThirdPartyDetailId.Value = detailId;
                this.windowThirdParty.Show();

            }
            else
            {
                this.hdtype.Value = "new";
                InitThirdPartyWindow(true);
                this.tfWinCompanyName.Enabled = true;
                this.Productline.Enabled = true;
                this.Productline.ReadOnly = true;
                this.ApplicationNote.Enabled = true;
                this.submintname.Enabled = true;
                this.job.Enabled = true;
                this.tfWinHospitalName.Enabled = true;
                if (RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) && this.hdDealerType.Value.ToString() == "T2" || this.hdDealerType.Value.ToString() != "T2" && !IsDealer && RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                {
                    this.btnThirdPartySubmit.Text = "披露提交";

                }

                Hashtable hs = new Hashtable();
                hs.Add("DmaId", this.hdDmaId.Value);
                DataSet dt = _thirdPartyDisclosure.Authorinformation(hs);
                if (dt.Tables[0].Rows.Count > 0)
                {
                    this.submintname.Value = dt.Tables[0].Rows[0]["TDL_SubmitterName"].ToString();
                    this.job.Value = dt.Tables[0].Rows[0]["TDL_Position"].ToString();

                }
                this.TabPanel1.ActiveTabIndex = 0;
                this.hiddenMainId.Value = Guid.NewGuid();
                //LoadThirdPartyWindow(new Guid(detailId));
                this.tfWinHospitalName.Text = HospitalName;
                this.hiddenHospitalId.Value = HospitalId;
                this.windowThirdParty.Show();
            }

            //Show Window


        }

        [AjaxMethod]
        public void Approval()
        {
            if (this.ApprovalStatus.Value.ToString() == "")
            {
                Verification(this.hiddenHospitalId.Value.ToString(), this.tfWinCompanyName.Text, this.hiddenProductLineName.Text, "申请审批通过", this.cbWinRs.SelectedItem.Value);
            }
            if (this.ApprovalStatus.Value.ToString() == "申请审批中")
            {
                Verification(this.hiddenHospitalId.Value.ToString(), this.hidCompanyName.Value.ToString(), this.hiddenProductLineName.Text, "申请审批通过", this.hidrelationship.Value.ToString());
            }
            if (this.hidresful.Value.ToString() == "true")
            {
                Hashtable hs = new Hashtable();

                
                hs.Add("hosid", this.hiddenHospitalId.Value.ToString());
                hs.Add("CompanyName", this.tfWinCompanyName.Text == "" ? this.hidCompanyName.Value.ToString() : this.tfWinCompanyName.Text);
                hs.Add("rsm", this.hidrelationship.Value.ToString() == "" ? this.cbWinRs.SelectedItem.Value.ToString() : this.hidrelationship.Value.ToString());
                hs.Add("productline", this.hiddenProductLineName.Text);
                hs.Add("ApprovalStatus", "申请审批通过");
                hs.Add("dmaid", this.hdDmaId.Value);
                _thirdPartyDisclosure.updateendThirdPartyList(hs);


            }
            Hashtable obj = new Hashtable();
            obj.Add("Id", this.hiddenMainId.Value.ToString());
            obj.Add("ApprovalStatus", "申请审批通过");
            obj.Add("ApprovalDate", DateTime.Now.ToString());
            obj.Add("ApprovalName", _context.User.Id);
            obj.Add("ApprovalRemark", this.taWinApprovalRemark.Text);
            _thirdPartyDisclosure.ApprovalThirdPartyDisclosureList(obj);

            SandMailAudit();
            SandMailApproval("Approval", "EMAIL_ThirdParty_Approval");
            obj.Add("DmaId", this.hdDmaId.Value.ToString());
            DealerMaster dm = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));
            //DataSet dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
            DataSet dt = _thirdPartyDisclosure.ThirdPartyDisclosureListByBU(obj);
            string Remarks = _context.UserName + "在" + DateTime.Now + "对" + dm.ChineseName + ":";
            string hospital = dt.Tables[0].Rows[0]["HOS_HospitalName"].ToString();
            string productline = dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() != null ? dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() : "";
            Remarks += hospital + productline + "," + "申请审批通过";
            Hashtable logobj = new Hashtable();
            logobj.Add("ContractUser", _context.User.Id);
            logobj.Add("DMAId", this.hdDmaId.Value.ToString());
            logobj.Add("Remarks", Remarks);
            _thirdPartyDisclosure.InsertContractLog(logobj);
        }

        [AjaxMethod]
        public void Reject()
        {
            Hashtable obj = new Hashtable();
            obj.Add("Id", this.hiddenMainId.Value.ToString());
            obj.Add("ApprovalStatus", "申请审批拒绝");
            obj.Add("ApprovalDate", DateTime.Now.ToString());
            obj.Add("ApprovalName", _context.User.Id);
            obj.Add("ApprovalRemark", this.taWinApprovalRemark.Text);
            _thirdPartyDisclosure.RefuseThirdPartyDisclosureList(obj);
            SandMailAudit();
            SandMailApproval("Reject", "EMAIL_ThirdParty_Reject");
            obj.Add("DmaId", this.hdDmaId.Value.ToString());
            DealerMaster dm = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));
            //DataSet dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
            DataSet dt = _thirdPartyDisclosure.ThirdPartyDisclosureListByBU(obj);
            string Remarks = _context.UserName + "在" + DateTime.Now + "对" + dm.ChineseName + ":";
            string hospital = dt.Tables[0].Rows[0]["HOS_HospitalName"].ToString();
            string productline = dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() != null ? dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() : "";
            Remarks += hospital + productline + "," + "申请审批拒绝";
            Hashtable logobj = new Hashtable();
            logobj.Add("ContractUser", _context.User.Id);
            logobj.Add("DMAId", this.hdDmaId.Value.ToString());
            logobj.Add("Remarks", Remarks);
            _thirdPartyDisclosure.InsertContractLog(logobj);
        }

        [AjaxMethod]
        public void SaveProductLine(string ProductLineName)
        {
            if (!string.IsNullOrEmpty(ProductLineName))
            {

                this.hiddenProductLineName.Text = ProductLineName.Substring(0, ProductLineName.Length - 1);
                this.Productline.Text = this.hiddenProductLineName.Text;
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        [AjaxMethod]
        public void ProductLineShow()
        {

            this.wdProductLine.Show();
        }



        #region Init
        /// <summary>
        /// Init Control value and status of TrainingSignIn Window
        /// </summary>
        /// <param name="canSubmit"></param>
        private void InitThirdPartyWindow(bool canSubmit)
        {
            this.hidrelationship.Value = "";
            this.hidname.Value = "";
            this.hidpost.Value = "";
            this.hidTerminationDate.Value = string.Empty;
            this.submintname.Value = "";
            this.job.Value = "";
            this.hidhospitalname.Value = string.Empty;
            this.hidCompanyName.Value = string.Empty;
            this.hidApplicationNote.Value = string.Empty;
            this.lbWinRsmRemark.Text = string.Empty;
            this.ApplicationNote.Text = string.Empty;
            this.taWinApprovalRemark.Hidden = true;
            this.Productline.Text = "";
            this.btnWdProductLine.Enabled = true;
            this.Submit.Hidden = true;
            this.TerminationendDate.Value = "";
            this.TerminationendDate.Hidden = true;
            this.hiddenMainId.Value = string.Empty;
            this.tfWinHospitalName.Clear();
            this.tfWinCompanyName.Clear();
            this.cbWinRs.SelectedItem.Value = "";
            this.hidresful.Value = string.Empty;
            this.hiddenHospitalId.Value = string.Empty;

            this.hiddenMainId.Value = string.Empty;
            this.taWinApprovalRemark.Text = "";

            this.ApprovalStatus.Value = "";
            this.hiddenWinThirdPartyDetailId.Clear(); //Id
            this.hiddenCountAttachment.Clear();

            this.cbWinRs.Enabled = true;
            this.btnThirdPartyApproval.Hidden = true;
            this.btnThirdPartyReject.Hidden = true;

            this.enddate.Hidden = true;
            this.begindate.Hidden = true;
            this.ApprovalStatus.Value = string.Empty;
            this.Renewbtn.Hidden = true;
            this.btnThirdPartyApproval.Hidden = true;//披露审批通过
            this.btnThirdPartyReject.Hidden = true; //披露申请审批拒绝
            this.EndThirdParty.Hidden = true;// 终止披露申请
            this.Approver.Hidden = true;//终止披露审批通过
            this.refuseEndThirdParty.Hidden = true;//终止披露审批拒绝

            if (this.hdtype.Value.ToString() == "old")
            {
                this.btnThirdPartySubmit.Hidden = true;
            }
            else
            {
                this.btnThirdPartySubmit.Hidden = false;

            }
            if (canSubmit)
            {
                this.btnThirdPartySubmit.Visible = true;
            }
            else
            {
                this.btnThirdPartySubmit.Visible = false;
            }
        }
        [AjaxMethod]
        public void Renew()
        {

            this.hiddenMainId.Value = Guid.NewGuid();
            this.Renewbtn.Hidden = true;
            this.Submit.Hidden = false;
            this.hdtype.Value = "new";
            this.EndThirdParty.Hidden = true;
            this.Approver.Hidden = true;
        }

        [AjaxMethod]
        public void RenewSubmit()
        {
            string massage = "";
            ThirdPartyDisclosureList ThirdParty = new ThirdPartyDisclosureList();
            Verification(this.hiddenHospitalId.Value.ToString(), this.hidCompanyName.Value.ToString(), this.hiddenProductLineName.Text, "申请审批中", this.hidrelationship.Value.ToString());
            if (this.hidresful.Value.ToString() == "true")
            {
                massage += "当前披露在审批中不允许重复提交申请<br/>";
            }
            if (massage == "")
            {
                if (RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) && this.hdDealerType.Value.ToString() == "T2" || this.hdDealerType.Value.ToString() != "T2" && !IsDealer && RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                {

                    ThirdParty.Id = new Guid(this.hiddenMainId.Value.ToString());
                    ThirdParty.DmaId = new Guid(this.hdDmaId.Value.ToString());
                    //ThirdParty.ProductLineId = new Guid(this.hdProductLineId.Value.ToString());
                    ThirdParty.HosId = new Guid(this.hiddenHospitalId.Value.ToString());
                    ThirdParty.CompanyName = this.hidCompanyName.Value.ToString();
                    ThirdParty.Rsm = this.hidrelationship.Value.ToString();
                    ThirdParty.CreatUser = new Guid(this._context.User.Id);
                    ThirdParty.CreatDate = DateTime.Now;
                    ThirdParty.ProductNameString = this.hiddenProductLineName.Text;
                    ThirdParty.ApprovalRemark = this.taWinApprovalRemark.Text;
                    ThirdParty.ApprovalUser = new Guid(_context.User.Id);
                    ThirdParty.SubmitterName = this.hidname.Value.ToString();
                    ThirdParty.Position = this.hidpost.Value.ToString();
                    ThirdParty.ApprovalStatus = "申请审批通过";
                    ThirdParty.ApprovalDate = DateTime.Now;
                    _thirdPartyDisclosure.InsertThirdPartyDisclosureListLp(ThirdParty);
                    //SandMailApproval("Approval", "EMAIL_ThirdParty_Approval");
                    Hashtable obj = new Hashtable();
                    obj.Add("DmaId", this.hdDmaId.Value.ToString());
                    DealerMaster dm = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));
                    //DataSet dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
                    DataSet dt = _thirdPartyDisclosure.ThirdPartyDisclosureListByBU(obj);
                    string Remarks = _context.UserName + "在" + DateTime.Now + "对" + dm.ChineseName + ":";
                    string hospital = dt.Tables[0].Rows[0]["HOS_HospitalName"].ToString();
                    string productline = dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() != null ? dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() : "";
                    Remarks += hospital + productline + "," + "申请审批通过";
                    Hashtable logobj = new Hashtable();
                    logobj.Add("ContractUser", _context.User.Id);
                    logobj.Add("DMAId", this.hdDmaId.Value.ToString());
                    logobj.Add("Remarks", Remarks);
                    _thirdPartyDisclosure.InsertContractLog(logobj);
                    SandMailAudit();
                    SandMailApproval("new", "EMAIL_RenewalContract_LPT2");
                    if (this.ApprovalStatus.Value.ToString() == "申请审批通过")
                    {
                        Hashtable hs = new Hashtable();
                        hs.Add("enddate", DateTime.Now);
                        hs.Add("Id", this.hiddenWinThirdPartyDetailId.Value.ToString());
                        _thirdPartyDisclosure.TerminationThirdPartyList(hs);


                    }
                }
                else
                {
                    ThirdParty.Id = new Guid(this.hiddenMainId.Value.ToString());
                    ThirdParty.DmaId = new Guid(this.hdDmaId.Value.ToString());
                    ThirdParty.HosId = new Guid(this.hiddenHospitalId.Value.ToString());
                    ThirdParty.CompanyName = this.hidCompanyName.Value.ToString();
                    ThirdParty.Rsm = this.hidrelationship.Value.ToString();
                    ThirdParty.CreatUser = new Guid(this._context.User.Id);
                    ThirdParty.SubmitterName = this.hidname.Value.ToString();
                    ThirdParty.Position = this.hidpost.Value.ToString();
                    ThirdParty.CreatDate = DateTime.Now;
                    ThirdParty.ProductNameString = this.hiddenProductLineName.Text;
                    ThirdParty.ApprovalStatus = "申请审批中";

                    _thirdPartyDisclosure.SaveThirdPartyDisclosureList(ThirdParty);
                    SandMailAudit();
                    ChangeAttachment("EMAIL_RenewalContract");
                }
            }
            else
            {

                throw new Exception(massage);
            }

        }
        private void LoadThirdPartyWindow(Guid detailId)
        {
            DataTable ThirdParty = _thirdPartyDisclosure.GetThirdPartyDisclosureListById(detailId).Tables[0];
            if (ThirdParty.Rows.Count > 0)
            {
                this.job.Text = ThirdParty.Rows[0]["Position"].ToString();
                this.submintname.Text = ThirdParty.Rows[0]["SubmitterName"].ToString();
                this.hiddenHospitalId.Text = ThirdParty.Rows[0]["HosId"].ToString();
                this.tfWinHospitalName.Text = ThirdParty.Rows[0]["HospitalName"].ToString();
                this.tfWinCompanyName.Text = ThirdParty.Rows[0]["CompanyName"].ToString();
                this.cbWinRs.SelectedItem.Value = ThirdParty.Rows[0]["Rsm"].ToString();
                this.taWinApprovalRemark.Text = ThirdParty.Rows[0]["ApprovalRemark"].ToString();
                this.ApprovalStatus.Value = ThirdParty.Rows[0]["ApprovalStatus"].ToString();
                this.hiddenProductLineName.Value = ThirdParty.Rows[0]["ProductNameString"].ToString();
                this.Productline.Text = this.hiddenProductLineName.Value.ToString();
                this.ApplicationNote.Text = ThirdParty.Rows[0]["ApplicationNote"].ToString();
                this.hidApplicationNote.Value = this.ApplicationNote.Text;
                this.hidhospitalname.Value = this.tfWinHospitalName.Text;
                this.hidCompanyName.Value = this.tfWinCompanyName.Text;
                this.hidrelationship.Value = this.cbWinRs.SelectedItem.Value;
                this.hidpost.Value = ThirdParty.Rows[0]["Position"].ToString();
                this.hidname.Value = ThirdParty.Rows[0]["SubmitterName"].ToString();
                if (ThirdParty.Rows[0]["TerminationDate"].ToString() != "")
                {
                    this.hidTerminationDate.Value = ThirdParty.Rows[0]["TerminationDate"].ToString();
                    this.TerminationendDate.SelectedDate = Convert.ToDateTime(ThirdParty.Rows[0]["TerminationDate"].ToString());
                }
                if (this.ApprovalStatus.Value.ToString() == "申请审批中")
                {    //平台登录
                    this.ApplicationNote.Enabled = false;
                    this.taWinApprovalRemark.Enabled = true;
                    if (ThirdParty.Rows[0]["DealerType"].ToString() == "T2" && RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                    {
                        this.btnThirdPartyApproval.Hidden = false;//披露申请审批通过
                        this.btnThirdPartyReject.Hidden = false; //披露申请审批拒绝
                        this.taWinApprovalRemark.Hidden = false;


                    }
                    //管理员登录
                    if (ThirdParty.Rows[0]["DealerType"].ToString() != "T2" && !IsDealer && RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                    {

                        this.btnThirdPartyApproval.Hidden = false;//披露审批通过
                        this.btnThirdPartyReject.Hidden = false; //披露申请审批拒绝
                        this.taWinApprovalRemark.Hidden = false;

                    }
                    if (ThirdParty.Rows[0]["DMA_ID"].ToString() == _context.User.CorpId.ToString())
                    {
                        this.btnThirdPartySubmit.Hidden = true;//披露申请提交
                        this.btnWdProductLine.Enabled = false;
                        this.taWinApprovalRemark.Hidden = true;
                    }

                }
                if (this.ApprovalStatus.Value.ToString() == "申请审批通过")
                {

                    this.begindate.SelectedDate = Convert.ToDateTime(ThirdParty.Rows[0]["BeginDate"].ToString());
                    this.enddate.SelectedDate = Convert.ToDateTime(ThirdParty.Rows[0]["EndDate"].ToString());
                    this.begindate.Hidden = false;
                    this.enddate.Hidden = false;
                    this.TerminationendDate.Hidden = false;
                    this.ApplicationNote.Enabled = true;
                    this.TerminationendDate.Enabled = true;
                    if (ThirdParty.Rows[0]["DealerType"].ToString() != "T2" && !IsDealer && RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation) || ThirdParty.Rows[0]["DealerType"].ToString() == "T2" && RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                    {
                        if (DateTime.Compare(DateTime.Now, Convert.ToDateTime(this.enddate.SelectedDate)) < 0)
                        {
                            this.Approver.Text = "终止披露";
                            this.Approver.Hidden = false;
                            this.TerminationendDate.Hidden = false;

                        }
                        this.Renewbtn.Hidden = false;
                    }
                    if (ThirdParty.Rows[0]["DMA_ID"].ToString() == _context.User.CorpId.ToString())
                    {
                        if (DateTime.Compare(DateTime.Now, Convert.ToDateTime(this.enddate.SelectedDate)) < 0)
                        {
                            this.EndThirdParty.Hidden = false;


                        }
                        this.Renewbtn.Hidden = false;
                    }


                }


                if (this.ApprovalStatus.Value.ToString() == "终止申请审批中")
                {


                    this.TerminationendDate.Hidden = false;
                    this.begindate.SelectedDate = Convert.ToDateTime(ThirdParty.Rows[0]["BeginDate"].ToString());
                    this.enddate.SelectedDate = Convert.ToDateTime(ThirdParty.Rows[0]["EndDate"].ToString());
                    this.taWinApprovalRemark.Hidden = false;
                    if (ThirdParty.Rows[0]["DealerType"].ToString() == "T2" && RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                    {
                        this.Approver.Text = "终止披露审批通过";
                        this.Approver.Hidden = false;//终止披露审批通过
                        this.refuseEndThirdParty.Hidden = false;//终止披露审批拒绝
                        this.taWinApprovalRemark.Enabled = true;

                    }
                    if (ThirdParty.Rows[0]["DealerType"].ToString() != "T2" && !IsDealer && RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                    {
                        this.Approver.Text = "终止披露审批通过";
                        this.Approver.Hidden = false;//终止披露审批通过
                        this.refuseEndThirdParty.Hidden = false;//终止披露审批拒绝
                        this.taWinApprovalRemark.Enabled = true;
                    }

                }

                if (this.ApprovalStatus.Value.ToString() == "终止申请审批拒绝")
                {

                    this.taWinApprovalRemark.Hidden = false;
                    this.TerminationendDate.Hidden = false;

                }
                if (this.ApprovalStatus.Value.ToString() == "申请审批拒绝")
                {
                    this.ApplicationNote.Enabled = false;
                    this.taWinApprovalRemark.Hidden = false;
                }
                if (this.ApprovalStatus.Value.ToString() == "终止申请审批通过")
                {
                    this.TerminationendDate.Hidden = false;
                    this.taWinApprovalRemark.Enabled = false;
                }










            }
        }


        #endregion

        #region 公用方法




        private string GetDealerName(Guid dealerid)
        {
            string dealerName = "";
            if (dealerid != null && dealerid != Guid.Empty)
            {
                IDealerMasters bll = new DealerMasters();
                DealerMaster dm = new DealerMaster();
                dm.Id = dealerid;
                IList<DealerMaster> listDm = bll.QueryForDealerMaster(dm);
                if (listDm.Count > 0)
                {
                    DealerMaster getDealerMaster = listDm[0];
                    dealerName = getDealerMaster.ChineseName;
                }
            }
            return dealerName;
        }

        private void SynchronousHospital()
        {
            if (!string.IsNullOrEmpty(this.hdDmaId.Value.ToString()))
            {
                //同步合同信息到第三方披露表上
                _thirdPartyDisclosure.SynchronousHospitalToThirdParty(new Guid(this.hdDmaId.Value.ToString()));
            }
        }

        [AjaxMethod]
        public void changeWinPageValue()
        {



        }

        public void SandMailAudit()
        {
            MailMessageTemplate mailMessage = _messageBLL.GetMailMessageTemplate("EMAIL_ThirdParty_ChangeNotice_Audit");

            Hashtable tbaddress = new Hashtable();
            tbaddress.Add("MailType", "DCMS");
            tbaddress.Add("MailTo", "Audit");
            IList<MailDeliveryAddress> Addresslist = masterBll.GetMailDeliveryAddress(tbaddress);
            SendMail(mailMessage, Addresslist);
        }

        public void SandMailApproval(string Type, string MessageTemplate)
        {
            MailMessageTemplate mailMessage = null;
            if (Type == "Reject")
            {
                mailMessage = _messageBLL.GetMailMessageTemplate(MessageTemplate);
            }
            else if (Type == "Approval")
            {
                mailMessage = _messageBLL.GetMailMessageTemplate(MessageTemplate);
            }
            else if (Type == "ChangeAttachment")
            {
                mailMessage = _messageBLL.GetMailMessageTemplate(MessageTemplate);
            }
            else if (Type == "new")
            {

                mailMessage = _messageBLL.GetMailMessageTemplate(MessageTemplate);

            }
            string role = "";
            string dealerNam = this.tfWinCompanyName.Value.ToString().Equals("") ? this.tfWinCompanyName.Value.ToString() : this.tfWinCompanyName.Value.ToString();
            DealerMaster dealermaster = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));

            if (!IsDealer)
            {
                role = "波科渠道管理员";
            }
            else
            {
                role = this.DealerName.Value.ToString();
            }
            if (!dealermaster.Email.ToString().Equals(""))
            {
                MailMessageQueue mail = new MailMessageQueue();
                mail.Id = Guid.NewGuid();
                mail.QueueNo = "email";
                mail.From = "";
                mail.To = dealermaster.Email.ToString();
                mail.Subject = mailMessage.Subject.Replace("{#role}", role);
                mail.Body = mailMessage.Body.Replace("{#DealerName}", this.pagedealername.Value.ToString()).Replace("{#Hospital}", this.hidhospitalname.Value.ToString()).Replace("{#ProductNameString}", this.hiddenProductLineName.Value.ToString()).Replace("{#CompanyName}", this.hidCompanyName.Value.ToString()).Replace("{#role}", role);
                mail.Status = "Waiting";
                mail.CreateDate = DateTime.Now;
                _messageBLL.AddToMailMessageQueue(mail);
            }
        }

        /// <summary>
        /// 发邮件
        /// </summary>
        private void SendMail(MailMessageTemplate mailMessage, IList<MailDeliveryAddress> Addresslist)
        {
            Hashtable hasButype = new Hashtable();
            hasButype.Add("DmaId", this.hdDmaId.Value.ToString());
            DataTable dtButype = _thirdPartyDisclosure.GetThirdPartyDisclosureListBuType(hasButype).Tables[0];
            DataRow drButype = null;
            if (dtButype.Rows.Count > 0)
            {
                drButype = dtButype.Rows[0];
            }
            string titalSubject = mailMessage.Subject;
            if (drButype != null && drButype[0] != null && drButype[0].ToString() != "")
            {
                titalSubject += ("(" + drButype[0].ToString() + ")");
            }
            //发邮件给平台或者CO时，需要添加该医院所属BU信息    LIJIE ADD 20160816
            Hashtable obj = new Hashtable();
            obj.Add("ID", this.hiddenMainId.Value.ToString());
            DataTable dsb = _thirdPartyDisclosure.ThirdPartyDisclosureListALL(obj).Tables[0];

            if (dsb.Rows.Count > 0)
            {

                string ProductNameString = dsb.Rows[0]["TDL_ProductNameString"].ToString();
                string HospitalName = dsb.Rows[0]["HOS_HospitalName"].ToString();
                string CompanyName = dsb.Rows[0]["TDL_CompanyName"].ToString();



                if (Addresslist != null && Addresslist.Count > 0)
                {
                    //发邮件通知CO确认IAF信息
                    foreach (MailDeliveryAddress mailAddress in Addresslist)
                    {
                        MailMessageQueue mail = new MailMessageQueue();
                        mail.Id = Guid.NewGuid();
                        mail.QueueNo = "email";
                        mail.From = "";
                        mail.To = mailAddress.MailAddress;
                        mail.Subject = titalSubject;
                        mail.Body = mailMessage.Body.Replace("{#DealerName}", this.tfDealerNameCn.Value.ToString()).Replace("{#hospital}", HospitalName).Replace("{#ProductNameString}", ProductNameString).Replace("{#CompanyName}", CompanyName);
                        mail.Status = "Waiting";
                        mail.CreateDate = DateTime.Now;
                        _messageBLL.AddToMailMessageQueue(mail);
                    }
                }
            }
        }

        private void SendMailDelaer(MailMessageTemplate mailMessage, IList<MailDeliveryAddress> Addresslist)
        {
            string titalSubject = mailMessage.Subject;
            if (Addresslist != null && Addresslist.Count > 0)
            {
                //发邮件通知CO确认IAF信息
                foreach (MailDeliveryAddress mailAddress in Addresslist)
                {
                    MailMessageQueue mail = new MailMessageQueue();
                    mail.Id = Guid.NewGuid();
                    mail.QueueNo = "email";
                    mail.From = "";
                    mail.To = mailAddress.MailAddress;
                    mail.Subject = titalSubject;
                    mail.Body = mailMessage.Body.Replace("{#DealerName}", this.tfDealerNameCn.Value.ToString());
                    mail.Status = "Waiting";
                    mail.CreateDate = DateTime.Now;
                    _messageBLL.AddToMailMessageQueue(mail);
                }
            }
        }
        #endregion

        #region Ajax Method  (Attachment)
        [AjaxMethod]
        public void AttachmentShow()
        {
            this.wdAttachment.Show();
        }

        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                //逻辑删除
                attachmentBLL.DelAttachment(new Guid(id));
                //物理删除
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\DCMS");
                File.Delete(uploadFile + "\\" + fileName);
                if (this.hdtype.Value.ToString() == "old" && this.hdDmaId.Value.ToString() == _context.User.CorpId.ToString() && this.hdtype.Value.ToString() != "new")
                {
                    ChangeAttachment("EMAIL_ThirdParty_ChangeAttachment_LPCO");

                }
                if (RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString())
                      && this.hdDealerType.Value.ToString() == "T2" && this.hdtype.Value.ToString() != "new" || this.hdDealerType.Value.ToString() != "T2" && !IsDealer && RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation) && this.hdtype.Value.ToString() != "new")
                {
                    SandMailApproval("ChangeAttachment", "EMAIL_ThirdParty_ChangeAttachment_LPT2");

                }


            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除失败").Show();
            }
        }


        #endregion

        #region 页面私有方法 (Attachment)

        protected void UploadAttachmentClick(object sender, AjaxEventArgs e)
        {
            if (this.ufUploadAttachment.HasFile)
            {

                bool error = false;

                string fileName = ufUploadAttachment.PostedFile.FileName;
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

                string file = Server.MapPath("\\Upload\\UploadFile\\DCMS\\" + newFileName);


                //文件上传
                ufUploadAttachment.PostedFile.SaveAs(file);


                Attachment attach = new Attachment();
                attach.Id = Guid.NewGuid();
                attach.MainId = new Guid(this.hiddenMainId.Value.ToString());
                attach.Name = fileExtention;
                attach.Url = newFileName;
                attach.UploadDate = DateTime.Now;
                attach.UploadUser = new Guid(_context.User.Id);
                attach.Type = "HospitalThirdPart";
                //维护附件信息
                bool ckUpload = attachmentBLL.AddAttachment(attach);
                if (this.hdtype.Value.ToString() == "old" && this.hdDmaId.Value.ToString() == _context.User.CorpId.ToString() && this.hdtype.Value.ToString() != "new")
                {
                    ChangeAttachment("EMAIL_ThirdParty_ChangeAttachment_LPCO");

                }
                if (RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString())
                     && this.hdDealerType.Value.ToString() == "T2" && this.hdtype.Value.ToString() != "new" || this.hdDealerType.Value.ToString() != "T2" && !IsDealer && RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation) && this.hdtype.Value.ToString() != "new")
                {
                    SandMailApproval("ChangeAttachment", "EMAIL_ThirdParty_ChangeAttachment_LPT2");

                }


                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = "上传成功",
                    Message = "附件上传成功</font>"
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
        #endregion


        [AjaxMethod]
        public void ExportDetail()
        {
            Hashtable obj = new Hashtable();
            obj.Add("DmaId", this.hdDmaId.Value.ToString());
            if (!string.IsNullOrEmpty(this.txtHospitalName.Text))
            {
                obj.Add("HospitalName", this.txtHospitalName.Text);
            }
            DataTable dt = _thirdPartyDisclosure.ExportThirdPartylist(obj).Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=result.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }
        #region Create IAF_ThirdParty File
        [AjaxMethod]
        public void CreatePdf()
        {

            Hashtable objsign = new Hashtable();
            objsign.Add("DealerId", this.hdDmaId.Value.ToString());
            DataTable sign = _dealers.GetThirdPartSignature(objsign).Tables[0];

            string fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
            string targetPath = Server.MapPath(PdfHelper.FILE_PATH + fileName);

            Document doc = new Document(iTextSharp.text.PageSize.A4, 36, 36, 12, 12);
            try
            {
                //注册中文字库
                PdfHelper.RegisterChineseFont();
                PdfHelper pdfFont = new PdfHelper();

                //DataSet ds = _trainingSignIn.GetTrainingSignInByContId(new Guid(this.hdCmId.Value.ToString()));

                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
                //设置脚注，页码
                PdfPageEvent pdfPage = new PdfPageEvent("Third party disclosure");
                writer.PageEvent = pdfPage;

                doc.Open();

                #region Pdf Title

                //设置Title Tabel 
                PdfPTable titleTable = new PdfPTable(3);
                titleTable.SetWidths(new float[] { 25f, 50f, 25f });
                PdfHelper.InitPdfTableProperty(titleTable);

                titleTable.AddCell(PdfHelper.GetIAFBscLogoImageCell());

                //Pdf标题
                PdfPCell titleCell = new PdfPCell(new Paragraph("经销商第三方公司披露表", pdfFont.normalBoldChineseFont14));
                titleCell.HorizontalAlignment = Rectangle.ALIGN_CENTER;
                titleCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                titleCell.PaddingBottom = 9f;
                titleCell.FixedHeight = 65.5f;
                titleCell.Border = 0;
                titleTable.AddCell(titleCell);

                PdfHelper.AddEmptyPdfCell(titleTable);

                //添加至pdf中
                PdfHelper.AddPdfTable(doc, titleTable);

                #endregion

                //#region 副标题
                //PdfPTable labelTable = new PdfPTable(1);
                //PdfHelper.InitPdfTableProperty(labelTable);

                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Transacting Business with Integrity Training", PdfHelper.iafTitleFont)) { FixedHeight = 50f, BackgroundColor = PdfHelper.remarkBgColor, PaddingTop = 10f }, labelTable, null, null);

                //PdfHelper.AddPdfTable(doc, labelTable);

                //#endregion

                #region 第三方信息
                PdfPTable thirdParyTable = new PdfPTable(2);
                thirdParyTable.SetWidths(new float[] { 30f, 70f });
                PdfHelper.InitPdfTableProperty(thirdParyTable);
                this.AddHeadTable(doc, 1, "公司信息", "");
                //PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("1.	     贵公司信息", pdfFont.normalChineseFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT, Colspan = 2, BackgroundColor = PdfHelper.remarkBgColor }
                //       , thirdParyTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                //Third Party Name
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("公司名称（本表简称“公司”）: ", pdfFont.normalChineseFont)) { FixedHeight = 20f, Colspan = 2 }
                      , thirdParyTable, Rectangle.ALIGN_LEFT, null, true, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.tfDealerNameCn.Value.ToString(), pdfFont.normalChineseFont)) { Colspan = 2 }
                      , thirdParyTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);


                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph(" ")) { Colspan = 4, FixedHeight = 10f }, thirdParyTable, null, null);


                PdfHelper.AddPdfTable(doc, thirdParyTable);
                #endregion

                #region Third Party User
                Hashtable obj = new Hashtable();
                obj.Add("DmaId", this.hdDmaId.Value.ToString());
                DataSet ds = _thirdPartyDisclosure.ThirdPartylist(obj);

                PdfPTable bodyTable = new PdfPTable(3);
                bodyTable.SetWidths(new float[] { 40f, 30f, 30f });
                PdfHelper.InitPdfTableProperty(bodyTable);

                this.AddHeadTable(doc, 2, "第三方公司披露", "若贵公司通过其它第三方公司向医院进行开票和销售，请列出第三方公司的名称、涉及医院及关系描述。若贵公司直接向医院进行开票和销售，请在此填“无”");

                //Head
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("医院", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor, BorderColor = PdfHelper.blueColor, BorderColorRight = BaseColor.BLACK, BorderWidthLeft = 1f, BorderWidthTop = 1f, BorderWidthRight = 0f, BorderWidthBottom = 0f }
                    , bodyTable, null, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("第三方公司", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor, BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthLeft = 0.6f, BorderWidthTop = 1f, BorderWidthRight = 0f, BorderWidthBottom = 0f }
                    , bodyTable, null, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("与贵司或医院关系", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor, BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthTop = 1f, BorderWidthRight = 1f, BorderWidthLeft = 0.6f, BorderWidthBottom = 0f }
                    , bodyTable, null, null);
                //PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("第三方公司2", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor, BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthLeft = 0f, BorderWidthTop = 1f, BorderWidthRight = 0f, BorderWidthBottom = 0f }
                //  , bodyTable, null, null);
                //PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("与贵司或医院关系2", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor, BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthTop = 1f, BorderWidthRight = 1f, BorderWidthLeft = 0.6f, BorderWidthBottom = 0f }
                //    , bodyTable, null, null);

                PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Phrase("  1.  " + this.GetStringByDataRow(ds, 1, "HospitalName"), pdfFont.normalChineseFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 1, "CompanyName").Equals("") ? "N/A" : this.GetStringByDataRow(ds, 1, "CompanyName"), pdfFont.normalChineseFont)) { BorderColor = BaseColor.BLACK, BorderColorTop = PdfHelper.blueColor, BorderWidth = 0.3f, BorderWidthTop = 1.5f }, bodyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 1, "Rsm").Equals("") ? "N/A" : this.GetStringByDataRow(ds, 1, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                //PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 1, "CompanyName2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, 1, "CompanyName2"), pdfFont.normalChineseFont)) { BorderColor = BaseColor.BLACK, BorderColorTop = PdfHelper.blueColor, BorderWidth = 0.3f, BorderWidthTop = 1.5f }, bodyTable, Rectangle.ALIGN_LEFT, null, false);
                //PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 1, "Rsm2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, 1, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 20)
                {
                    for (int i = 2; i <= ds.Tables[0].Rows.Count - 1; i++)
                    {
                        PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Phrase("  " + i + ".  " + this.GetStringByDataRow(ds, i, "HospitalName"), pdfFont.normalChineseFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                        if (this.GetStringByDataRow(ds, i, "HospitalName").Equals(""))
                        {
                            PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        }
                        else
                        {
                            PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "CompanyName2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        }
                    }
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Phrase(" " + ds.Tables[0].Rows.Count.ToString() + ".  " + this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "HospitalName"), pdfFont.normalChineseFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "CompanyName").Equals("") ? "N/A" : this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "Rsm").Equals("") ? "N/A" : this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                    //PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "CompanyName2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                    //PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "Rsm2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                }
                else
                {
                    for (int i = 2; i < 20; i++)
                    {
                        PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Phrase("  " + i + ".  " + this.GetStringByDataRow(ds, i, "HospitalName"), pdfFont.normalChineseFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                        if (this.GetStringByDataRow(ds, i, "HospitalName").Equals(""))
                        {
                            PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        }
                        else
                        {
                            PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "CompanyName2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        }
                    }
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Phrase("  20.  " + this.GetStringByDataRow(ds, 20, "HospitalName"), pdfFont.normalChineseFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                    if (this.GetStringByDataRow(ds, 20, "HospitalName").Equals(""))
                    {
                        PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 20, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 20, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        //PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 20, "CompanyName2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        //PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 20, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                    }
                    else
                    {
                        PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 20, "CompanyName").Equals("") ? "N/A" : this.GetStringByDataRow(ds, 20, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 20, "Rsm").Equals("") ? "N/A" : this.GetStringByDataRow(ds, 20, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 20, "CompanyName2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, 20, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 20, "Rsm2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, 20, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                    }
                }
                bodyTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 5 });
                PdfHelper.AddPdfTable(doc, bodyTable);
                #endregion

                #region Remark
                PdfPTable cbTable = new PdfPTable(4);
                cbTable.SetWidths(new float[] { 5f, 30f, 35f, 10f });
                PdfHelper.InitPdfTableProperty(cbTable);
                Chunk descChunk = new Chunk("兹通知，在贵司披露第三方公司时，蓝威或其代理公司可能会购买尽职调查验证报告及/或调查性的尽职调查报告，以获取有关各种事项的信息，包括但不限于公司结构、所有权、商务实践、银行记录、资信状况、破产程序、犯罪记录、民事记录、一般声誉及个人品质（包括前述任何项目，以及个人的教育程度、从业历史等），并有权根据报告结果拒绝与该第三方公司合作。若贵司未主动披露第三方公司，蓝威或其代理公司发现后，蓝威或其代理公司保留扣减贵司返利，直至解除合同取消授权等措施的权利。", pdfFont.normalChineseFont);

                Phrase notePhrase = new Phrase();
                notePhrase.Add(descChunk);

                Paragraph noteParagraph = new Paragraph();
                noteParagraph.Add(notePhrase);

                PdfHelper.AddPdfCell(new PdfPCell(noteParagraph) { Colspan = 4, BackgroundColor = PdfHelper.grayColor }, cbTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, cbTable, null, null);

                PdfHelper.AddPdfTable(doc, cbTable);
                #endregion



                //return fileName;
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "发生错误！").Show();
                Console.WriteLine(ex.Message);
                //return string.Empty;
            }
            finally
            {
                doc.Close();
            }
            DownloadFileForDCMS(fileName, "ThirdPartyDisclosure.pdf", "DCMS");

        }

        private void AddHeadTable(Document doc, int number, string headText, string subHeadText)
        {
            PdfHelper pdfFont = new PdfHelper();
            PdfPTable headTable = new PdfPTable(2);
            headTable.SetWidths(new float[] { 5f, 95f });
            PdfHelper.InitPdfTableProperty(headTable);

            Chunk numberChunk = new Chunk(number.ToString() + ".     ", PdfHelper.italicFont);
            Chunk headChunk = new Chunk(headText, pdfFont.normalChineseFontB);

            Phrase headPhrase = new Phrase();
            headPhrase.Add(headChunk);

            if (!string.IsNullOrEmpty(subHeadText))
            {
                Chunk subHeadChunk = new Chunk("\r\n" + subHeadText, pdfFont.normalChineseFont);
                headPhrase.Add(subHeadChunk);
            }

            Phrase nbrPhrase = new Phrase();
            nbrPhrase.Add(numberChunk);

            Paragraph headParagraph = new Paragraph();
            headParagraph.Add(headPhrase);

            Paragraph nbrParagraph = new Paragraph();
            nbrParagraph.Add(nbrPhrase);

            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(nbrParagraph) { BackgroundColor = PdfHelper.remarkBgColor }
                        , headTable, Rectangle.ALIGN_LEFT, null, true, false, false, true);
            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(headParagraph) { BackgroundColor = PdfHelper.remarkBgColor }
                        , headTable, Rectangle.ALIGN_LEFT, null, true, true, false, false);

            doc.Add(headTable);
        }

        private string GetStringByDataRow(DataSet ds, int rowNumber, string column)
        {
            string resultStr = string.Empty;
            if (ds.Tables != null && ds.Tables.Count > 0)
            {
                if (rowNumber <= ds.Tables[0].Rows.Count)
                {
                    if (ds.Tables[0].Rows[rowNumber - 1][column] != null)
                    {
                        resultStr = ds.Tables[0].Rows[rowNumber - 1][column].ToString();
                    }
                }
            }

            return resultStr;
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


        public void ChangeAttachment(string MessageTemplatelpco)
        {

            Hashtable obj = new Hashtable();
            obj.Add("DmaId", this.hdDmaId.Value.ToString());
            obj.Add("MainId", this.hiddenMainId.Value.ToString());
            DataTable dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureListHospitBU(obj).Tables[0];
            string hospital = dsb.Rows[0]["HospitalName"].ToString();
            string bu = dsb.Rows[0]["ProductNameString"].ToString();
            string CompanyName = dsb.Rows[0]["CompanyName"].ToString();
            string DMA_ChineseName = dsb.Rows[0]["DMA_ChineseName"].ToString();

            DealerMaster dMaster = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));
            MailMessageTemplate mailMessage = null;
            IList<MailDeliveryAddress> Addresslist = null;
            if (this.hdDealerType.Value.ToString().Equals(DealerType.T2.ToString()))
            {
                mailMessage = _messageBLL.GetMailMessageTemplate(MessageTemplatelpco);

                Hashtable tbaddress = new Hashtable();
                tbaddress.Add("MailType", "DCMS");
                tbaddress.Add("DealerId", this.hdDmaId.Value.ToString());
                Addresslist = masterBll.GetLPMailDeliveryAddressByDealerId(tbaddress);
            }
            else
            {
                mailMessage = _messageBLL.GetMailMessageTemplate(MessageTemplatelpco);
                Hashtable tbaddress = new Hashtable();
                tbaddress.Add("MailType", "DCMS");
                tbaddress.Add("MailTo", "CO");
                Addresslist = masterBll.GetMailDeliveryAddress(tbaddress);
            }

            //发邮件给平台和CO
            Hashtable hasButype = new Hashtable();
            hasButype.Add("DmaId", this.hdDmaId.Value.ToString());
            DataTable dtButype = _thirdPartyDisclosure.GetThirdPartyDisclosureListBuType(hasButype).Tables[0];
            DataRow drButype = null;
            if (dtButype.Rows.Count > 0)
            {
                drButype = dtButype.Rows[0];
            }
            string titalSubject = mailMessage.Subject;
            if (drButype != null && drButype[0] != null && drButype[0].ToString() != "")
            {
                titalSubject += ("(" + drButype[0].ToString() + ")");
            }


            if (Addresslist != null && Addresslist.Count > 0)
            {
                //发邮件通知CO确认IAF信息
                foreach (MailDeliveryAddress mailAddress in Addresslist)
                {
                    MailMessageQueue mail = new MailMessageQueue();
                    mail.Id = Guid.NewGuid();
                    mail.QueueNo = "email";
                    mail.From = "";
                    mail.To = mailAddress.MailAddress;
                    mail.Subject = titalSubject.Replace("{#Delertype}", this.hdDealerType.Value.ToString());
                    mail.Body = mailMessage.Body.Replace("{#DealerName}", DMA_ChineseName).Replace("{#hospital}", hospital).Replace("{#CompanyName}", CompanyName).Replace("{#ProductNameString}", bu);
                    mail.CreateDate = DateTime.Now;
                    mail.Status = "Waiting";
                    _messageBLL.AddToMailMessageQueue(mail);
                }
            }

        }
        //终止披露审批拒绝
        [AjaxMethod]
        public void refuseEndThirdPartylist()
        {

            Hashtable obj = new Hashtable();
            obj.Add("Id", this.hiddenMainId.Value.ToString());
            obj.Add("ApprovalStatus", "终止申请审批拒绝");
            obj.Add("ApprovalDate", DateTime.Now.ToString());
            obj.Add("ApprovalName", _context.User.Id);
            obj.Add("ApprovalRemark", this.taWinApprovalRemark.Text);
            _thirdPartyDisclosure.endThirdPartyList(obj);
            SandMailApproval("Reject", "EMAIL_ThirdPartyDisclosureList_EndReject");
            obj.Add("DmaId", this.hdDmaId.Value.ToString());
            DealerMaster dm = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));
            //DataSet dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
            DataSet dt = _thirdPartyDisclosure.ThirdPartyDisclosureListByBU(obj);
            string Remarks = _context.UserName + "在" + DateTime.Now + "对" + dm.ChineseName + ":";
            string hospital = dt.Tables[0].Rows[0]["HOS_HospitalName"].ToString();
            string productline = dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() != null ? dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() : "";
            Remarks += hospital + productline + "," + "终止申请审批拒绝";
            Hashtable logobj = new Hashtable();
            logobj.Add("ContractUser", _context.User.Id);
            logobj.Add("DMAId", this.hdDmaId.Value.ToString());
            logobj.Add("Remarks", Remarks);
            _thirdPartyDisclosure.InsertContractLog(logobj);
            SandMailAudit();

        }
        //终止披露审批通过
        [AjaxMethod]
        public void EndThirdPartylistApprover()
        {

            Hashtable obj = new Hashtable();
            obj.Add("Id", this.hiddenMainId.Value.ToString());
            obj.Add("ApprovalStatus", "终止申请审批通过");
            obj.Add("ApprovalDate", DateTime.Now);
            obj.Add("ApprovalName", _context.User.Id);
            obj.Add("ApprovalRemark", this.taWinApprovalRemark.Text);
            obj.Add("ApplicationNote", this.ApplicationNote.Text);
            if (this.hidTerminationDate.Value.ToString() != "")
            {
                obj.Add("TerminationDate", this.hidTerminationDate.Value);
            }
            else
            {
                obj.Add("TerminationDate", this.TerminationendDate.SelectedDate.ToShortDateString());
            }

            _thirdPartyDisclosure.UpdateThirdPartyDisclosureListend(obj);
            SandMailAudit();
            if (this.ApprovalStatus.Value.ToString() == "申请审批通过")
            {
                SandMailApproval("new", "EMAIL_ThirdPartyListend_LPT2");

            }
            if (this.ApprovalStatus.Value.ToString() == "终止申请审批中")
            {
                SandMailApproval("Approval", "EMAIL_ThirdPartyDisclosureList_EndApproval");
            }
            obj.Add("DmaId", this.hdDmaId.Value.ToString());
            DealerMaster dm = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));
            //DataSet dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
            DataSet dt = _thirdPartyDisclosure.ThirdPartyDisclosureListByBU(obj);
            string Remarks = _context.UserName + "在" + DateTime.Now + "对" + dm.ChineseName + ":";
            string hospital = dt.Tables[0].Rows[0]["HOS_HospitalName"].ToString();
            string productline = dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() != null ? dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() : "";
            Remarks += hospital + productline + "," + "终止申请审批通过";
            Hashtable logobj = new Hashtable();
            logobj.Add("ContractUser", _context.User.Id);
            logobj.Add("DMAId", this.hdDmaId.Value.ToString());
            logobj.Add("Remarks", Remarks);
            _thirdPartyDisclosure.InsertContractLog(logobj);




        }

        //提交终止披露申请
        [AjaxMethod]
        public void EndThirdPartylist()
        {
            Hashtable obj = new Hashtable();
            obj.Add("Id", this.hiddenMainId.Value.ToString());
            obj.Add("ApprovalStatus", "终止申请审批中");
            obj.Add("ApplicationNote", this.ApplicationNote.Text);
            obj.Add("TerminationDate", this.TerminationendDate.SelectedDate.ToShortDateString());


            _thirdPartyDisclosure.RefuseThirdPartyDisclosureList(obj);
            ChangeAttachment("EMAIL_ThirdPartyEnd_LPCO");
            SandMailAudit();

        }



        public void sendtoApprover()
        {
            DealerMaster dMaster = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));
            MailMessageTemplate mailMessage = null;
            IList<MailDeliveryAddress> Addresslist = null;
            if (this.hdDealerType.Value.ToString().Equals(DealerType.T2.ToString()))
            {
                mailMessage = _messageBLL.GetMailMessageTemplate("EMAIL_ThirdParty_ChangeNotice_LP");

                Hashtable tbaddress = new Hashtable();
                tbaddress.Add("MailType", "DCMS");
                tbaddress.Add("DealerId", dMaster.Id.ToString());
                Addresslist = masterBll.GetLPMailDeliveryAddressByDealerId(tbaddress);
            }
            else
            {
                mailMessage = _messageBLL.GetMailMessageTemplate("EMAIL_ThirdParty_ChangeNotice_CO");
                Hashtable tbaddress = new Hashtable();
                tbaddress.Add("MailType", "DCMS");
                tbaddress.Add("MailTo", "CO");
                Addresslist = masterBll.GetMailDeliveryAddress(tbaddress);
            }

            //发邮件给平台和CO
            SendMail(mailMessage, Addresslist);


        }

        public void Verification(string hosid, string CompanyName, string productline, string ApprovalStatus, string rsm)
        {

            Hashtable hs = new Hashtable();
            hs.Add("hosid", hosid);
            hs.Add("CompanyName", CompanyName);
            hs.Add("productline", productline);
            hs.Add("ApprovalStatus", ApprovalStatus);
            hs.Add("dmaid", this.hdDmaId.Value);
            hs.Add("rsm", rsm);
            DataTable dt = _thirdPartyDisclosure.SelectThirdPartylist(hs).Tables[0];
            if (dt.Rows.Count > 0)
            {

                this.hidresful.Value = "true";
                this.hiddenWinThirdPartyDetailId.Value = dt.Rows[0]["TDL_ID"].ToString();
            }
            else
            {
                this.hidresful.Value = "false";
                //Ext.Msg.Alert("提示", "当前披露在有效期内的不允许重复提交申请").Show();
            }

        }

    }
}