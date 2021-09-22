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
    public partial class ContractThirdParty : BasePage
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
                if (Request.QueryString["DealerId"] != null)
                {
                    this.hdDmaId.Value = Request.QueryString["DealerId"];

                    BindPageDate();

                    SynchronousHospital();
                }
                if (!RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                {
                    btnCreatePdf.Enabled = false;
                }
            }
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
            DataTable dt = _thirdPartyDisclosure.GetThirdPartyDisclosureQuery(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.ThirdPartyDisclosureStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            ThirdPartyDisclosureStore.DataSource = dt;
            ThirdPartyDisclosureStore.DataBind();
        }

        protected void Store_RsType(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> contractStatus = DictionaryHelper.GetDictionary(SR.ThirdPartType);
            RsType.DataSource = contractStatus;
            RsType.DataBind();
        }

        protected void AttachmentStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataTable dt = attachmentBLL.GetAttachmentByMainId(new Guid(this.hiddenWinThirdPartyDetailId.Value.ToString()), AttachmentType.HospitalThirdPart, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarAttachment.PageSize : e.Limit), out totalCount).Tables[0];
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


        #region 保存页面签名

        [AjaxMethod]
        public void SaveSubmit()
        {
            try
            {
                DealerMaster dMaster = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));

                string massage = "";
                if (!PageCheck(ref  massage))
                {
                    Ext.Msg.Alert("Error", massage).Show();
                }
                else
                {
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

                    ////发邮件给审计公司
                    SandMailAudit();

                    ////保存签字信息
                    SaveDate(ContractMastreStatus.Submit.ToString());
                    //记录批录日志 lijie add 20160816
                    DealerMaster dm = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));
                    Hashtable obj = new Hashtable();
                    obj.Add("DmaId", this.hdDmaId.Value.ToString());
                    obj.Add("ApprovalStatus", "待审批");
                    DataSet dt = _thirdPartyDisclosure.ThirdPartyDisclosureHospitBU(obj);
                    string Remarks = _context.UserName + "在" + DateTime.Now + "对" + dm.ChineseName + ":";
                    string hospital = dt.Tables[0].Rows[0]["HOS_HospitalName"].ToString();
                    string productline = dt.Tables[0].Rows[0]["TPD_ProductNameString"].ToString() != null ? dt.Tables[0].Rows[0]["TPD_ProductNameString"].ToString() : "";
                    Remarks += hospital + productline + "," + "做过批录";
                  
                    Hashtable logobj = new Hashtable();
                    logobj.Add("ContractUser", _context.User.Id);
                    logobj.Add("DMAId", this.hdDmaId.Value.ToString());
                    logobj.Add("Remarks", Remarks);
                    _thirdPartyDisclosure.InsertContractLog(logobj);
                    //类型为经销商指定公司要给经销商发送邮件
                    //obj.Add("Rsm", "经销商指定公司");
                    //obj.Add("Rsm2", "经销商指定公司");
                    //DataSet dsrm = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
                    DataSet dsrm = _thirdPartyDisclosure.GetThirdPartyDisclosureById(new Guid(hiddenWinThirdPartyDetailId.Text == "" ? Guid.Empty.ToString() : hiddenWinThirdPartyDetailId.Text));
                    if (dsrm.Tables[0].Rows.Count > 0)
                    {
                        if (dsrm.Tables[0].Rows[0]["Rsm"].ToString() == "经销商指定公司" || dsrm.Tables[0].Rows[0]["Rsm2"].ToString() == "经销商指定公司")
                        {
                            //如果有批录类型为经销商指定公司的
                            mailMessage = _messageBLL.GetMailMessageTemplate("EMAIL_ThirdParty_ChangeNotice_Delaer");
                            DealerMaster emds = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Text.ToString()));
                            IList<MailDeliveryAddress> Address = new List<MailDeliveryAddress>();
                            MailDeliveryAddress modle = new MailDeliveryAddress();
                            modle.MailAddress = emds.Email;
                            Address.Add(modle);
                            mailMessage.Body = mailMessage.Body.Replace("{#data}", DateTime.Now.ToString());
                            SendMailDelaer(mailMessage, Address);
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        private void SaveDate(string cmStatus)
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("DmaId", this.hdDmaId.Value.ToString());
                obj.Add("ThirdPartyUser", this.tdUserName.Text);
                obj.Add("ThirdPartyPosition", this.tfPosition.Text);
                obj.Add("ThirdPartyDate", this.dpSignature.SelectedDate.ToShortDateString());
                _dealers.UpdateThirdPartSignature(obj);

                Ext.Msg.Alert("Success", "保存成功").Show();

            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }

        #endregion

        #region 无披露确认
        [AjaxMethod]
        public void SetNoDisclosure(string param)
        {
            param = param.Substring(0, param.Length - 1);

            _thirdPartyDisclosure.SetHospitalNoDisclosure(param.Split(','));
            gpThirdPartyDisclosure.Reload();
        }
        #endregion

        #region 维护第三方信息

        [AjaxMethod]
        public void ShowThirdPartyWindow()
        {
            //Init vlaue within this window control
            InitThirdPartyWindow(true);
            this.TabPanel1.ActiveTabIndex = 0;
            //Show Window
            this.windowThirdParty.Show();
        }

        [AjaxMethod]
        public void SaveThirdParty()
        {
            string massage = "";
            ThirdPartyDisclosure ThirdParty = new ThirdPartyDisclosure();
            if (this.chNotTP.Checked)
            {
                ThirdParty.Id = new Guid(this.hiddenWinThirdPartyDetailId.Text);
                ThirdParty.DmaId = new Guid(this.hdDmaId.Value.ToString());
                ThirdParty.HosId = new Guid(this.hiddenHospitalId.Value.ToString());
                ThirdParty.Nottp = true;
                ThirdParty.ProductNameString = this.hiddenProductLineName.Text;

                _thirdPartyDisclosure.UpdateThirdPartyDisclosureById(ThirdParty);

                windowThirdParty.Hide();
                gpThirdPartyDisclosure.Reload();
            }
            else
            {
                if (String.IsNullOrEmpty(this.tfWinCompanyName.Text))
                {
                    massage += "请填写公司名称1<br/>";
                }
                if (String.IsNullOrEmpty(this.tfWinRsm.Text))
                {
                    massage += "请填写与贵司或医院关系1<br/>";
                }
                if (String.IsNullOrEmpty(this.hiddenProductLineName.Text))
                {
                    massage += "请选择合作的产品线<br/>";
                }
                try
                {
                    if (massage == "")
                    {
                        //Create
                        if (string.IsNullOrEmpty(this.hiddenWinThirdPartyDetailId.Text))
                        {
                            ThirdParty.Id = Guid.NewGuid();
                            ThirdParty.DmaId = new Guid(this.hdDmaId.Value.ToString());
                            //ThirdParty.ProductLineId = new Guid(this.hdProductLineId.Value.ToString());
                            ThirdParty.HosId = new Guid(this.hiddenHospitalId.Value.ToString());
                            ThirdParty.CompanyName = this.tfWinCompanyName.Text;
                            ThirdParty.Rsm = this.tfWinRsm.Text;
                            ThirdParty.CompanyName2 = this.tfWinCompanyName2.Text;
                            ThirdParty.Rsm2 = this.tfWinRsm2.Text;
                            ThirdParty.Nottp = false;
                            ThirdParty.CreatDate = DateTime.Now;
                            ThirdParty.ProductNameString = this.hiddenProductLineName.Text;
                            //ThirdParty.CreatUser = _context.User.Id;
                            //if (this.tfWinRsm.Text.Equals("医院指定公司") || this.tfWinRsm2.Text.Equals("医院指定公司"))
                            //{
                            //经销商指定公司也需要审批，LIJIE EDIT 20160816
                            ThirdParty.ApprovalStatus = "待审批";
                            //}

                            _thirdPartyDisclosure.SaveThirdPartyDisclosure(ThirdParty);
                        }
                        //Edit
                        else
                        {
                            ThirdParty.Id = new Guid(this.hiddenWinThirdPartyDetailId.Text);
                            ThirdParty.DmaId = new Guid(this.hdDmaId.Value.ToString());
                            //ThirdParty.ProductLineId = new Guid(this.hdProductLineId.Value.ToString());
                            ThirdParty.HosId = new Guid(this.hiddenHospitalId.Value.ToString());
                            ThirdParty.CompanyName = this.tfWinCompanyName.Text;
                            ThirdParty.Rsm = this.tfWinRsm.Text;
                            ThirdParty.CompanyName2 = this.tfWinCompanyName2.Text;
                            ThirdParty.Rsm2 = this.tfWinRsm2.Text;
                            ThirdParty.Nottp = false;
                            ThirdParty.CreatDate = DateTime.Now;
                            ThirdParty.ProductNameString = this.hiddenProductLineName.Text;
                            //if (this.tfWinRsm.Text.Equals("医院指定公司") || this.tfWinRsm2.Text.Equals("医院指定公司"))
                            //{
                            ThirdParty.ApprovalStatus = "待审批";
                            //}

                            _thirdPartyDisclosure.UpdateThirdPartyDisclosureById(ThirdParty);
                        }
                        windowThirdParty.Hide();
                        gpThirdPartyDisclosure.Reload();
                        if (ThirdParty.Rsm == "经销商指定公司" && ThirdParty.Rsm2 == "经销商指定公司")
                        {
                            massage = "'<b>保存成功</b>，<br/><font color=red>保存成功，请在一周内上传销售合同、合规附件、质量附件、合规及质量培训签到表和质量自检表</font>'";
                        }
                        else {
                            massage = "<b>保存成功</b>，<br/><font color=red>完成所有披露后，请务必点击披露主页面的提交键!</font>";
                        }
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
        }

        [AjaxMethod]
        public void DeleteThirdPartyDisclosureItem(string detailId)
        {
            if (!string.IsNullOrEmpty(detailId))
            {
                _thirdPartyDisclosure.DeleteThirdPartyDisclosureById(new Guid(detailId));
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        [AjaxMethod]
        public void EditThirdPartyDisclosureItem(string detailId)
        {
            InitThirdPartyWindow(true);

            if (!string.IsNullOrEmpty(detailId))
            {
                LoadThirdPartyWindow(new Guid(detailId));

                //Set Value
                this.hiddenWinThirdPartyDetailId.Text = detailId;

                //Show Window
                this.windowThirdParty.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        [AjaxMethod]
        public void Approval()
        {
            Hashtable obj = new Hashtable();
            obj.Add("Id", this.hiddenWinThirdPartyDetailId.Value.ToString());
            obj.Add("ApprovalStatus", "审批通过");
            obj.Add("ApprovalDate", DateTime.Now.ToShortDateString());
            obj.Add("ApprovalName", _context.User.Id);
            obj.Add("ApprovalRemark", this.taWinApprovalRemark.Text);
            _thirdPartyDisclosure.ApprovalThirdParty(obj);
            SandMailApproval("Approval");
            obj.Add("DmaId", this.hdDmaId.Value.ToString());
            DealerMaster dm = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));
            //DataSet dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
            DataSet dt = _thirdPartyDisclosure.ThirdPartyDisclosureHospitBU(obj);
            string Remarks = _context.UserName + "在" + DateTime.Now + "对" + dm.ChineseName + ":";
            string hospital=dt.Tables[0].Rows[0]["HOS_HospitalName"].ToString();
            string productline = dt.Tables[0].Rows[0]["TPD_ProductNameString"].ToString() != null ? dt.Tables[0].Rows[0]["TPD_ProductNameString"].ToString() : "";
            Remarks += hospital+ productline+ ","+ "审批通过";
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
            obj.Add("Id", this.hiddenWinThirdPartyDetailId.Value.ToString());
            obj.Add("ApprovalStatus", "审批拒绝");
            obj.Add("ApprovalDate", DateTime.Now.ToShortDateString());
            obj.Add("ApprovalName", _context.User.Id);
            obj.Add("ApprovalRemark", this.taWinApprovalRemark.Text);
            _thirdPartyDisclosure.ApprovalThirdParty(obj);
            SandMailApproval("Reject");
            obj.Add("DmaId", this.hdDmaId.Value.ToString());
            DealerMaster dm = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));
            //DataSet dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
            DataSet dt = _thirdPartyDisclosure.ThirdPartyDisclosureHospitBU(obj);
            string Remarks = _context.UserName + "在" + DateTime.Now + "对" + dm.ChineseName + ":";
            string hospital = dt.Tables[0].Rows[0]["HOS_HospitalName"].ToString();
            string productline = dt.Tables[0].Rows[0]["TPD_ProductNameString"].ToString() != null ? dt.Tables[0].Rows[0]["TPD_ProductNameString"].ToString() : "";
            Remarks += hospital  + productline + "," + "审批拒绝";
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
                //ThirdPartyDisclosure ThirdParty = new ThirdPartyDisclosure();
                //if (string.IsNullOrEmpty(this.hiddenWinThirdPartyDetailId.Text))
                //{
                //    ThirdParty.Id = Guid.NewGuid();
                //    ThirdParty.ProductNameString = ProductLineName;
                //}
                //else
                //{
                //    ThirdParty.Id = new Guid(this.hiddenWinThirdPartyDetailId.Text);
                //    ThirdParty.ProductNameString = ProductLineName;
                //}
                this.hiddenProductLineName.Text = ProductLineName.Substring(0,ProductLineName.Length-1);
                //_thirdPartyDisclosure.UpdateThirdPartyDisclosureById(ThirdParty);
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


        #endregion

        #region Init
        /// <summary>
        /// Init Control value and status of TrainingSignIn Window
        /// </summary>
        /// <param name="canSubmit"></param>
        private void InitThirdPartyWindow(bool canSubmit)
        {
            this.tfWinHospitalName.Clear();
            this.tfWinCompanyName.Clear();
            this.cbWinRs.SelectedItem.Value = "";
            this.tfWinRsm.Clear();
            this.tfWinCompanyName2.Clear();
            this.tfWinRsm2.Clear();
            this.cbWinRs2.SelectedItem.Value = "";
            this.lbWinRsmRemark.Text = "";
            this.lbWinRsmRemark2.Text = "";
            this.taWinApprovalRemark.Text = "";
            this.chNotTP.Checked = false;

            this.hiddenWinThirdPartyDetailId.Clear(); //Id
            this.hiddenCountAttachment.Clear();
            this.tfWinCompanyName.Enabled = true;
            this.tfWinCompanyName2.Enabled = true;
            this.cbWinRs.Enabled = true;
            this.cbWinRs2.Enabled = true;
            this.btnThirdPartyApproval.Hidden = true;
            this.btnThirdPartyReject.Hidden = true;
            this.taWinApprovalRemark.Hidden = true;
            if (canSubmit)
            {
                this.btnThirdPartySubmit.Visible = true;
            }
            else
            {
                this.btnThirdPartySubmit.Visible = false;
            }
        }

        private void LoadThirdPartyWindow(Guid detailId)
        {
            DataTable ThirdParty = _thirdPartyDisclosure.GetThirdPartyDisclosureById(detailId).Tables[0];
            if (ThirdParty.Rows.Count > 0)
            {
                this.hiddenHospitalId.Text = ThirdParty.Rows[0]["HosId"].ToString();
                this.tfWinHospitalName.Text = ThirdParty.Rows[0]["HospitalName"].ToString();
                this.tfWinCompanyName.Text = ThirdParty.Rows[0]["CompanyName"].ToString();
                this.tfWinRsm.Text = ThirdParty.Rows[0]["Rsm"].ToString();
                this.tfWinCompanyName2.Text = ThirdParty.Rows[0]["CompanyName2"].ToString();
                this.tfWinRsm2.Text = ThirdParty.Rows[0]["Rsm2"].ToString();
                this.chNotTP.Checked = Convert.ToBoolean(ThirdParty.Rows[0]["NotTP"]);
                if (Convert.ToBoolean(ThirdParty.Rows[0]["NotTP"].ToString()))
                {
                    this.tfWinCompanyName.Enabled = false;
                    this.tfWinCompanyName2.Enabled = false;
                    this.cbWinRs.Enabled = false;
                    this.cbWinRs2.Enabled = false;
                }
                if (ThirdParty.Rows[0]["ApprovalStatus"].ToString().Equals("待审批") && ThirdParty.Rows[0]["DealerType"].ToString().Equals("T2") && RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                {
                    this.btnThirdPartyApproval.Hidden = false;
                    this.btnThirdPartyReject.Hidden = false;
                }
                else if (ThirdParty.Rows[0]["ApprovalStatus"].ToString().Equals("待审批") && !ThirdParty.Rows[0]["DealerType"].ToString().Equals("T2") && !IsDealer)
                {
                    this.btnThirdPartyApproval.Hidden = false;
                    this.btnThirdPartyReject.Hidden = false;
                }
                if (ThirdParty.Rows[0]["ApprovalStatus"] != null && !ThirdParty.Rows[0]["ApprovalStatus"].ToString().Equals(""))
                {
                    this.taWinApprovalRemark.Hidden = false;
                    this.taWinApprovalRemark.Text = ThirdParty.Rows[0]["ApprovalRemark"].ToString();
                }
            }
        }

        #endregion

        #region 公用方法
        private bool PageCheck(ref string massage)
        {
            if (tdUserName.Text.Equals(""))
            {
                massage += "请填写签字代表名称<br/>";
            }
            if (tfPosition.Text.Equals(""))
            {
                massage += "请填写签字代表职位<br/>";
            }
            if (dpSignature.IsNull)
            {
                massage += "请填日期<br/>";
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

        private void BindPageDate()
        {
            DealerMaster dMaster = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));

            this.tfDealerNameCn.Text = dMaster.ChineseName;
            this.hdDealerType.Text = dMaster.DealerType.ToString();

            Hashtable objsign = new Hashtable();
            objsign.Add("DealerId", this.hdDmaId.Value.ToString());
            DataTable sign = _dealers.GetThirdPartSignature(objsign).Tables[0];
            if (sign.Rows.Count > 0)
            {
                if (sign.Rows[0]["ThirdPartyDate"] != null && !sign.Rows[0]["ThirdPartyDate"].ToString().Equals(""))
                {
                    this.dpSignature.SelectedDate = Convert.ToDateTime(sign.Rows[0]["ThirdPartyDate"].ToString());
                }
                this.tdUserName.Value = sign.Rows[0]["ThirdPartyUser"].ToString();
                this.tfPosition.Value = sign.Rows[0]["ThirdPartyPosition"].ToString();
            }
        }

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
            if (this.chNotTP.Checked)
            {
                this.tfWinCompanyName.Enabled = false;
                this.tfWinCompanyName2.Enabled = false;
                this.cbWinRs.Enabled = false;
                this.cbWinRs2.Enabled = false;
                this.tfWinCompanyName.Text = "";
                this.tfWinCompanyName2.Text = "";
                this.cbWinRs.SelectedItem.Value = "";
                this.cbWinRs2.SelectedItem.Value = "";
                this.tfWinRsm.Text = "";
                this.tfWinRsm2.Text = "";
                this.taWinApprovalRemark.Text = "";
            }
            else
            {
                this.tfWinCompanyName.Enabled = true;
                this.tfWinCompanyName2.Enabled = true;
                this.cbWinRs.Enabled = true;
                this.cbWinRs2.Enabled = true;
            }
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

        public void SandMailApproval(string Type)
        {
            MailMessageTemplate mailMessage = null;
            if (Type == "Reject")
            {
                mailMessage = _messageBLL.GetMailMessageTemplate("EMAIL_ThirdParty_Reject");
            }
            else if (Type == "Approval")
            {
                mailMessage = _messageBLL.GetMailMessageTemplate("EMAIL_ThirdParty_Approval");
            }
            string dealerNam = this.tfWinCompanyName.Value.ToString().Equals("") ? this.tfWinCompanyName2.Value.ToString() : (this.tfWinCompanyName2.Value.ToString().Equals("") ? this.tfWinCompanyName.Value.ToString() : (this.tfWinCompanyName.Value.ToString() + " 和 " + this.tfWinCompanyName2.Value.ToString()));

            DealerMaster dealermaster = _dealerMasters.GetDealerMaster(new Guid(this.hdDmaId.Value.ToString()));

            if (!dealermaster.Email.ToString().Equals(""))
            {
                MailMessageQueue mail = new MailMessageQueue();
                mail.Id = Guid.NewGuid();
                mail.QueueNo = "email";
                mail.From = "";
                mail.To = dealermaster.Email.ToString();
                mail.Subject = mailMessage.Subject;
                mail.Body = mailMessage.Body.Replace("{#DealerName}", dealerNam).Replace("{#Hospital}", this.tfWinHospitalName.Value.ToString());
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
            DataTable dtButype = _thirdPartyDisclosure.GetThirdPartyBuType(hasButype).Tables[0];
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
            obj.Add("DmaId", this.hdDmaId.Value.ToString());
            obj.Add("ApprovalStatus", "待审批");
            DataSet dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
            string bumessing = "医院BU信息:";
            foreach (DataRow row in dsb.Tables[0].Rows)
            {
                if (row["ProductNameString"] != DBNull.Value)
                {
                    bumessing += row["HospitalName"].ToString() + "对应产品线:" + row["ProductNameString"].ToString() + ";";
                }
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
                    mail.Subject = titalSubject;
                    mail.Body = mailMessage.Body.Replace("{#DealerName}", this.tfDealerNameCn.Value.ToString()) + ";" + bumessing;
                    mail.Status = "Waiting";
                    mail.CreateDate = DateTime.Now;
                    _messageBLL.AddToMailMessageQueue(mail);
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
                attach.MainId = new Guid(this.hiddenWinThirdPartyDetailId.Value.ToString());
                attach.Name = fileExtention;
                attach.Url = newFileName;
                attach.UploadDate = DateTime.Now;
                attach.UploadUser = new Guid(_context.User.Id);
                attach.Type = "HospitalThirdPart";
                //维护附件信息
                bool ckUpload = attachmentBLL.AddAttachment(attach);

                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = "上传成功",
                    Message = "附件上传成功，<br/><font color='red'>完成所有上传后，请务必点击披露主页面的提交键！</font>"
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

        #region Create IAF_ThirdParty File

        protected void CreatePdf(object sender, EventArgs e)
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
                DataSet ds = _thirdPartyDisclosure.GetThirdPartyDisclosureQuery(obj);

                PdfPTable bodyTable = new PdfPTable(5);
                bodyTable.SetWidths(new float[] { 26f, 19f, 18f, 19f, 18f });
                PdfHelper.InitPdfTableProperty(bodyTable);

                this.AddHeadTable(doc, 2, "第三方公司披露", "若贵公司通过其它第三方公司向医院进行开票和销售，请列出第三方公司的名称、涉及医院及关系描述。若贵公司直接向医院进行开票和销售，请在此填“无”");

                //Head
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("医院", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor, BorderColor = PdfHelper.blueColor, BorderColorRight = BaseColor.BLACK, BorderWidthLeft = 1f, BorderWidthTop = 1f, BorderWidthRight = 0f, BorderWidthBottom = 0f }
                    , bodyTable, null, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("第三方公司1", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor, BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthLeft = 0.6f, BorderWidthTop = 1f, BorderWidthRight = 0f, BorderWidthBottom = 0f }
                    , bodyTable, null, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("与贵司或医院关系1", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor, BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthTop = 1f, BorderWidthRight = 1f, BorderWidthLeft = 0.6f, BorderWidthBottom = 0f }
                    , bodyTable, null, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("第三方公司2", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor, BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthLeft = 0f, BorderWidthTop = 1f, BorderWidthRight = 0f, BorderWidthBottom = 0f }
                  , bodyTable, null, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("与贵司或医院关系2", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor, BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthTop = 1f, BorderWidthRight = 1f, BorderWidthLeft = 0.6f, BorderWidthBottom = 0f }
                    , bodyTable, null, null);

                PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Phrase("  1.  " + this.GetStringByDataRow(ds, 1, "HospitalName"), pdfFont.normalChineseFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 1, "CompanyName").Equals("") ? "N/A" : this.GetStringByDataRow(ds, 1, "CompanyName"), pdfFont.normalChineseFont)) { BorderColor = BaseColor.BLACK, BorderColorTop = PdfHelper.blueColor, BorderWidth = 0.3f, BorderWidthTop = 1.5f }, bodyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 1, "Rsm").Equals("") ? "N/A" : this.GetStringByDataRow(ds, 1, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 1, "CompanyName2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, 1, "CompanyName2"), pdfFont.normalChineseFont)) { BorderColor = BaseColor.BLACK, BorderColorTop = PdfHelper.blueColor, BorderWidth = 0.3f, BorderWidthTop = 1.5f }, bodyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 1, "Rsm2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, 1, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 20)
                {
                    for (int i = 2; i <= ds.Tables[0].Rows.Count - 1; i++)
                    {
                        PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Phrase("  " + i + ".  " + this.GetStringByDataRow(ds, i, "HospitalName"), pdfFont.normalChineseFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                        if (this.GetStringByDataRow(ds, i, "HospitalName").Equals(""))
                        {
                            PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        }
                        else
                        {
                            PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "CompanyName2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        }
                    }
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Phrase(" " + ds.Tables[0].Rows.Count.ToString() + ".  " + this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "HospitalName"), pdfFont.normalChineseFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "CompanyName").Equals("") ? "N/A" : this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "Rsm").Equals("") ? "N/A" : this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "CompanyName2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "Rsm2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
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
                            PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        }
                        else
                        {
                            PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "CompanyName2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        }
                    }
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Phrase("  20.  " + this.GetStringByDataRow(ds, 20, "HospitalName"), pdfFont.normalChineseFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                    if (this.GetStringByDataRow(ds, 20, "HospitalName").Equals(""))
                    {
                        PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 20, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 20, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 20, "CompanyName2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 20, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
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

                #region 3.	Signature
                PdfPTable signatureTable = new PdfPTable(4);
                signatureTable.SetWidths(new float[] { 15f, 40f, 25f, 20f });
                PdfHelper.InitPdfTableProperty(signatureTable);

                this.AddHeadTable(doc, 3, "签名", "本人已详读并充分明白上述通知，并确认在此提供的全部信息真实准确，本人经授权代表公司签字确认。");

                #region User One

                //Company/Date
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("打印名:", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor }
                        , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(sign.Rows[0]["ThirdPartyUser"] == null ? "" : sign.Rows[0]["ThirdPartyUser"].ToString(), pdfFont.normalChineseFont))
                        , signatureTable, Rectangle.ALIGN_LEFT, null, true, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("职位:", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor }
                        , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(sign.Rows[0]["ThirdPartyPosition"] == null ? "" : sign.Rows[0]["ThirdPartyPosition"].ToString(), pdfFont.normalChineseFont))
                        , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, false);

                //Date of Birth/Position
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("签名:", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor }
                        , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", pdfFont.normalChineseFont))
                        , signatureTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("日期", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor }
                        , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(sign.Rows[0]["ThirdPartyDate"].ToString() == "" ? "" : Convert.ToDateTime(sign.Rows[0]["ThirdPartyDate"]).ToShortDateString(), pdfFont.normalChineseFont))
                        , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);




                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, signatureTable, null, null);
                #endregion


                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, signatureTable, null, null);


                PdfHelper.AddPdfTable(doc, signatureTable);
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
    }
}
