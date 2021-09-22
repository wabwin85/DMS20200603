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
    public partial class AppointmentUpdate : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;

        ContractAmendmentService ContractBll = new ContractAmendmentService();
        ContractAppointmentService AppointmentBll = new ContractAppointmentService();
        private IAttachmentBLL _attachmentBLL = null;
        [Dependency]
        public IAttachmentBLL attachmentBLL
        {
            get { return _attachmentBLL; }
            set { _attachmentBLL = value; }
        }

        public string UpdateId
        {
            get
            {
                return this.hidUpdateId.Text;
            }
            set
            {
                this.hidUpdateId.Text = value.ToString();
            }
        }

        public string ContractId
        {
            get
            {
                return this.hidContractId.Text;
            }
            set
            {
                this.hidContractId.Text = value.ToString();
            }
        }
        public string ContractNo
        {
            get
            {
                return this.txtContractNo.Text;
            }
            set
            {
                this.txtContractNo.Text = value.ToString();
            }
        }
        public string ContractStatusCode
        {
            get
            {
                return this.hidContractStatus.Text;
            }
            set
            {
                this.hidContractStatus.Text = value.ToString();
            }
        }

        public string ContractStatus
        {
            get
            {
                return this.labContractStatus.Text;
            }
            set
            {
                this.labContractStatus.Text = value.ToString();
            }
        }
        public string DealerName
        {
            get
            {
                return this.labDealerName.Text;
            }
            set
            {
                this.labDealerName.Text = value.ToString();
            }
        }


        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.UpdateId = Guid.NewGuid().ToString();
                this.Bind_DealerList(this.DealerStore);
            }
        }

        #region StoreRefresh
        protected void Store_RefreshAttachment(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataTable dt = attachmentBLL.GetAttachmentByMainId(new Guid(this.UpdateId), AttachmentType.UpdateContractAdmin, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount).Tables[0];
            (this.AttachmentStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            AttachmentStore.DataSource = dt;
            AttachmentStore.DataBind();
        }
        protected void Store_Refreshlog(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataTable dt = ContractBll.GetUpdatelog(this.ContractId == "" ? "00000000-0000-0000-0000-000000000000" : this.ContractId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.logStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            logStore.DataSource = dt;
            logStore.DataBind();
        }
        protected void Store_RefreshContractAttachment(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable table = new Hashtable();
            table.Add("AttachmentList", this.hidContractAttachment.Text);
            DataTable dt = ContractBll.GetContractAttachmentAdmin(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount).Tables[0];
            (this.AttachmentStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            ContractAttachmentStore.DataSource = dt;
            ContractAttachmentStore.DataBind();
        }
        #endregion

        #region AjaxMethod
        [AjaxMethod]
        public void ContractQuery()
        {
            this.ContractId = "";
            Hashtable obj = new Hashtable();
            obj.Add("ContractNo", this.ContractNo);
            DataTable dt = AppointmentBll.SelectAppointmentMain(obj).Tables[0];
            if (dt.Rows.Count > 0)
            {
                DataRow dr = dt.Rows[0];
                this.ContractId = dr["ContractId"].ToString();
                this.ContractStatusCode = dr["ContractStatus"].ToString();
                this.ContractStatus = dr["ContractStatusName"].ToString();
                this.DealerName = dr["DealerCnName"].ToString();
                this.labProductLine.Text = dr["DepName"].ToString();
                this.labSubBu.Text = dr["SUBDEPNAME"].ToString();
                this.hidSubBuCode.Value = dr["SUBDEPID"].ToString();
                this.labEName.Text = dr["EName"].ToString();
                this.hidCompanyId.Value = dr["CompanyID"].ToString();
                this.ButtonEdit.Enabled = true;
            }
        }
        [AjaxMethod]
        public void ContractEdit()
        {
            //页面按钮状态
            this.txtContractNo.Enabled = false;
            this.ButtonQuery.Enabled = false;
            this.ButtonEdit.Enabled = false;
            this.ButtonAbandon.Enabled = true;

            this.BtnApprove.Enabled = true;
            this.btnAddAttachment.Enabled = true;
            this.btnAddContractAttachment.Enabled = true;
            this.gplog.Reload();
            //获取合同数据集
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.ContractId);
            DataTable dtMain = AppointmentBll.SelectAppointmentMain(obj).Tables[0];
            DataTable dtDealerMian = AppointmentBll.SelectAppointmentDealer(obj).Tables[0];
            DataTable dtProposals = AppointmentBll.SelectAppointmentProposals(obj).Tables[0];
            //绑定合同数据
            if (dtMain.Rows.Count > 0)
            {   //绑定主数据
                DataRow drMian = dtMain.Rows[0];

                this.cbIsEquipment.SelectedItem.Value = drMian["IsEquipment"].ToString();
                if (drMian["Assessment"] != DBNull.Value)
                    this.cbAssessment.SelectedItem.Value = drMian["Assessment"].ToString();
                if (drMian["AssessmentStart"] != DBNull.Value)
                    this.dfAssessmentStart.SelectedDate = Convert.ToDateTime(drMian["AssessmentStart"]);
                if (drMian["REASON"] != DBNull.Value)
                {
                    if (drMian["REASON"].ToString().Equals("1"))
                    {
                        this.rgReason1.Checked = true;
                    }
                    else if (drMian["REASON"].ToString().Equals("2"))
                    {
                        this.rgReason2.Checked = true;
                    }
                    else if (drMian["REASON"].ToString().Equals("3"))
                    {
                        this.rgReason3.Checked = true;
                    }
                    else if (drMian["REASON"].ToString().Equals("4"))
                    {
                        this.rgReason4.Checked = true;
                    }
                }
                if (drMian["FORMERNAME"] != DBNull.Value)
                    this.cbFormeRname.SelectedItem.Value = drMian["FORMERNAME"].ToString();
                if (drMian["IAF"] != DBNull.Value)
                    this.hidContractAttachment.Text = drMian["IAF"].ToString();
                this.gpContractAttachment.Reload();
            }
            if (dtDealerMian.Rows.Count > 0)
            {
                DataRow drDealerMian = dtDealerMian.Rows[0];
                if (drDealerMian["CompanyName"] != DBNull.Value)
                    this.tfCompanyName.Text = drDealerMian["CompanyName"].ToString();
                if (drDealerMian["Contact"] != DBNull.Value)
                    this.tfContact.Text = drDealerMian["Contact"].ToString();
                if (drDealerMian["OfficeNumber"] != DBNull.Value)
                    this.tfOfficeNumber.Text = drDealerMian["OfficeNumber"].ToString();
                if (drDealerMian["EstablishedTime"] != DBNull.Value)
                    this.tfEstablishedTime.Text = drDealerMian["EstablishedTime"].ToString();
                if (drDealerMian["LPSAPCode"] != DBNull.Value)
                    this.tfLPSAPCode.Text = drDealerMian["LPSAPCode"].ToString();
                if (drDealerMian["CompanyEName"] != DBNull.Value)
                    this.tfCompanyEName.Text = drDealerMian["CompanyEName"].ToString();
                if (drDealerMian["EMail"] != DBNull.Value)
                    this.tfEMail.Text = drDealerMian["EMail"].ToString();
                if (drDealerMian["Mobile"] != DBNull.Value)
                    this.tfMobile.Text = drDealerMian["Mobile"].ToString();
                if (drDealerMian["Capital"] != DBNull.Value)
                    this.tfCapital.Text = drDealerMian["Capital"].ToString();
                if (drDealerMian["SAPCode"] != DBNull.Value)
                    this.lbSAPCode.Text = drDealerMian["SAPCode"].ToString();
                if (drDealerMian["CompanyType"] != DBNull.Value)
                    this.tfCompanyType.Text = drDealerMian["CompanyType"].ToString();
                if (drDealerMian["Website"] != DBNull.Value)
                    this.tfWebsite.Text = drDealerMian["Website"].ToString();
                if (drDealerMian["OfficeAddress"] != DBNull.Value)
                    this.tfOfficeAddress.Text = drDealerMian["OfficeAddress"].ToString();
            }
            if (dtProposals.Rows.Count > 0)
            {   //绑定主数据
                DataRow drProposals = dtProposals.Rows[0];
                this.dfAgreementBegin.SelectedDate = Convert.ToDateTime(drProposals["AgreementBegin"]);
                this.dfAgreementEnd.SelectedDate = Convert.ToDateTime(drProposals["AgreementEnd"]);
                if (drProposals["Payment"] != DBNull.Value)
                {
                    if (drProposals["Payment"].ToString().Equals("Credit"))
                    {
                        this.rgCredit.Checked = true;
                    }
                    else if (drProposals["Payment"].ToString().Equals("COD"))
                    {
                        this.rgCOD.Checked = true;
                    }
                    else if (drProposals["Payment"].ToString().Equals("LC"))
                    {
                        this.rgLC.Checked = true;
                    }
                }
                //信用天数
                if (drProposals["CreditTerm"] != DBNull.Value)
                {
                    if (drProposals["CreditTerm"].ToString().Equals("30"))
                    {
                        this.rg30.Checked = true;
                    }
                    else if (drProposals["CreditTerm"].ToString().Equals("60"))
                    {
                        this.rg60.Checked = true;
                    }
                    else if (drProposals["CreditTerm"].ToString().Equals("90"))
                    {
                        this.rg90.Checked = true;
                    }
                    else if (drProposals["CreditTerm"].ToString().Equals("120"))
                    {
                        this.rg120.Checked = true;
                    }
                    else if (drProposals["CreditTerm"].ToString().Equals("150"))
                    {
                        this.rg150.Checked = true;
                    }
                }
                //信用额度
                if (drProposals["CreditLimit"] != DBNull.Value)
                    this.tfCreditLimit.Text = drProposals["CreditLimit"].ToString();

                //担保
                if (drProposals["IsDeposit"] != DBNull.Value)
                {
                    if (drProposals["IsDeposit"].ToString().Equals("1"))
                    {
                        this.rgDepositYear.Checked = true;
                    }
                    else if (drProposals["IsDeposit"].ToString().Equals("0"))
                    {
                        this.rgDepositNo.Checked = true;
                    }
                }
                if (drProposals["Deposit"] != DBNull.Value)
                    this.tfDeposit.Text = drProposals["Deposit"].ToString();
                if (drProposals["Inform"] != DBNull.Value)
                    this.tfInform.Text = drProposals["Inform"].ToString();
                //if (drProposals["Attachment"] != DBNull.Value)
                //    this.hidContractAttachment.Text = drProposals["Attachment"].ToString();
                //this.gpContractAttachment.Reload();
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
            this.btnAddContractAttachment.Enabled = false;

            ClearFormValue();
            this.gpAttachment.Reload();
            this.gpContractAttachment.Reload();
            this.gplog.Reload();
            //放弃修改
        }


        [AjaxMethod]
        public string checkAttachment()
        {
            string retMassage = "errey";
            Hashtable obj = new Hashtable();
            obj.Add("UpdateId", this.UpdateId);
            string retValue = ContractBll.CheckAttachmentUpload(obj);
            if (!retValue.Equals("0"))
            {
                retMassage = "success";
            }
            return retMassage;
        }
        [AjaxMethod]
        public string SaveSubmint()
        {
            //提交主修改
            Hashtable main = GetMainFormValue();
            Hashtable dealerMain = GetDealerFormValue();
            Hashtable proposals = GetProposalsFormValue();
            bool result = AppointmentBll.SaveAppointmentUpdate(main, dealerMain, proposals,this.UpdateId);

            if (result)
            {
                //完成修改后，清空修改主键ID，更新附件表
                this.UpdateId = Guid.NewGuid().ToString();
                this.gpAttachment.Reload();
                this.gplog.Reload();
                return "success";
            }
            else
            {
                return "error";
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
                    attach.MainId = new Guid(this.UpdateId);
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
        protected void ContractUploadClick(object sender, AjaxEventArgs e)
        {
            try
            {
                if (this.FileUploadContract.HasFile)
                {
                    bool error = false;

                    string fileName = FileUploadContract.PostedFile.FileName;
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
                    string newFileName = "Upload/Contract/" + DateTime.Now.ToString("yyyyMMdd") + "-" + Guid.NewGuid().ToString() + "." + fileExt;

                    //上传文件在Upload文件夹

                    string file = Server.MapPath("~") + newFileName;


                    //文件上传
                    FileUploadContract.PostedFile.SaveAs(file);

                    Hashtable obj = new Hashtable();
                    obj.Add("FileName", fileExtention);
                    obj.Add("FileUrl", newFileName);
                    obj.Add("CreateUser", _context.User.Id);
                    ContractBll.UploadContractAttachment(obj);

                    Hashtable table = new Hashtable();
                    table.Add("FileUrl", newFileName);
                    DataSet dsActId = ContractBll.GetContractAttachmentAdmin(table);
                    if (dsActId.Tables[0].Rows.Count > 0)
                    {
                        this.hidContractAttachment.Text = (this.hidContractAttachment.Text == "" ? dsActId.Tables[0].Rows[0]["AttId"].ToString() : (this.hidContractAttachment.Text + "," + dsActId.Tables[0].Rows[0]["AttId"].ToString()));
                    }

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
        public void DeleteContractAttachment(string attId)
        {
            string attachmentList = this.hidContractAttachment.Text;
            attachmentList = attachmentList.Replace(attId + ",", "").Replace("," + attId, "").Replace(attId, "");
            this.hidContractAttachment.Text = attachmentList;
        }
        #endregion

        #region PageInit
        private void ClearFormValue()
        {
            this.UpdateId = Guid.NewGuid().ToString();
            this.ContractNo = "";
            this.ContractId = "";
            this.ContractStatusCode = "";
            this.ContractStatus = "";
            this.DealerName = "";
            this.labProductLine.Text = "";
            this.labSubBu.Text = "";
            this.labEName.Text = "";
            this.hidSubBuCode.Clear();
            this.hidCompanyId.Clear();

            //合同主信息
            this.cbAssessment.SelectedItem.Value = "";
            this.dfAssessmentStart.Clear();
            foreach (var item in rgReason.CheckedItems)
            {
                item.Checked = false;
            }
            this.cbFormeRname.SelectedItem.Value = "";
            //新经销商基本信息
            this.tfCompanyName.Text = "";
            this.tfContact.Text = "";
            this.tfOfficeNumber.Text = "";
            this.tfEstablishedTime.Text = "";
            this.tfLPSAPCode.Text = "";
            this.tfCompanyEName.Text = "";
            this.tfEMail.Text = "";
            this.tfMobile.Text = "";
            this.tfCapital.Text = "";
            this.lbSAPCode.Text = "";
            this.cbIsEquipment.SelectedItem.Value = "";
            this.tfCompanyType.Text = "";
            this.tfOfficeAddress.Text = "";
            this.tfWebsite.Text = "";
            //合同信息
            this.dfAgreementBegin.Clear();
            this.dfAgreementEnd.Clear();
            this.hidContractAttachment.Clear();
            foreach (var item in rgPayment.CheckedItems)
            {
                item.Checked = false;
            }
            //this.rgIsDeposit.CheckedItems.Clear();
            foreach (var item in rgIsDeposit.CheckedItems)
            {
                item.Checked = false;
            }
            this.tfDeposit.Text = "";
            //this.rgCreditTerm.CheckedItems.Clear();
            foreach (var item in rgCreditTerm.CheckedItems)
            {
                item.Checked = false;
            }
            this.tfCreditLimit.Text = "";
            this.tfInform.Text = "";
        }
        private Hashtable GetMainFormValue()
        {
            Hashtable obj = new Hashtable();
            obj.Add("TempId", this.UpdateId);
            obj.Add("ContractId", this.ContractId);
            obj.Add("ContractNo", this.ContractNo);
            if (this.rgReason1.Checked)
            { obj.Add("REASON", "1");}
            else if (this.rgReason2.Checked)
            { obj.Add("REASON", "2"); }
            else if (this.rgReason3.Checked)
            { obj.Add("REASON", "3"); }
            else if (this.rgReason4.Checked)
            { obj.Add("REASON", "4"); }
            else { obj.Add("REASON", "0"); }
            if (!string.IsNullOrEmpty(cbFormeRname.SelectedItem.Value))
            {
                obj.Add("FORMERNAME", cbFormeRname.SelectedItem.Value);
            }
            else {
                obj.Add("FORMERNAME", "");
            }
            if (this.rgReason4.Checked)
            {
                obj.Add("TypeRemark", "曾用名经销商指标不会因为本申请而自动删除，若需修改曾用名经销商指标，请提交该经销商的修改或终止申请。");
            }
            else {
                obj.Add("TypeRemark", "");
            }
            obj.Add("Assessment", this.cbAssessment.SelectedItem.Value);
            if (!this.dfAssessmentStart.IsNull)
            {
                obj.Add("AssessmentStart", this.dfAssessmentStart.SelectedDate.ToShortDateString());
            }
            else
            {
                obj.Add("AssessmentStart", "");
            }
            obj.Add("IAF", this.hidContractAttachment.Text);
            obj.Add("UpdateUser", _context.User.Id);
            return obj;
        }
        private Hashtable GetDealerFormValue()
        {
            Hashtable obj = new Hashtable();
            obj.Add("TempId", this.UpdateId);
            obj.Add("ContractId", this.ContractId);
            obj.Add("CompanyName", this.tfCompanyName.Text);
            obj.Add("CompanyEName", this.tfCompanyEName.Text);
            obj.Add("Contact", this.tfContact.Text);
            obj.Add("EMail", this.tfEMail.Text);
            obj.Add("IsEquipment", this.cbIsEquipment.SelectedItem.Value);
            obj.Add("OfficeNumber", this.tfOfficeNumber.Text);
            obj.Add("Mobile", this.tfMobile.Text);
            obj.Add("OfficeAddress", this.tfOfficeAddress.Text);
            obj.Add("CompanyType", this.tfCompanyType.Text);
            obj.Add("EstablishedTime", this.tfEstablishedTime.Text);
            obj.Add("Capital", this.tfCapital.Text);
            obj.Add("Website", this.tfWebsite.Text);
            obj.Add("LPSAPCode", this.tfLPSAPCode.Text);
            obj.Add("SAPCode", this.lbSAPCode.Text);
            return obj;
        }
        private Hashtable GetProposalsFormValue()
        {
            Hashtable obj = new Hashtable();
            obj.Add("TempId", this.UpdateId);
            obj.Add("ContractId", this.ContractId);

            if (!this.dfAgreementBegin.IsNull) { obj.Add("AgreementBegin", this.dfAgreementBegin.SelectedDate.ToShortDateString()); }
            if (!this.dfAgreementEnd.IsNull) { obj.Add("AgreementEnd", this.dfAgreementEnd.SelectedDate.ToShortDateString()); }

            if (this.rgCOD.Checked) { obj.Add("Payment", "COD"); }
            else if (this.rgLC.Checked) { obj.Add("Payment", "LC"); }
            else if(this.rgCredit.Checked) { obj.Add("Payment", "Credit"); }
            else { obj.Add("Payment", ""); }
            if (this.rg30.Checked) { obj.Add("CreditTerm", "30"); }
            else if (this.rg60.Checked) { obj.Add("CreditTerm", "60"); }
            else if (this.rg90.Checked) { obj.Add("CreditTerm", "90"); }
            else if (this.rg120.Checked) { obj.Add("CreditTerm", "120"); }
            else if (this.rg150.Checked) { obj.Add("CreditTerm", "150"); }
            else { obj.Add("CreditTerm", ""); }
            if (!string.IsNullOrEmpty(this.tfCreditLimit.Text)) { obj.Add("CreditLimit", this.tfCreditLimit.Number); }
            obj.Add("CreditLimit", "0");
            if (this.rgDepositYear.Checked) { obj.Add("IsDeposit", 1); }
            else if (this.rgDepositNo.Checked) { obj.Add("IsDeposit", 0); }
            else {obj.Add("IsDeposit", 0); }
            if (!string.IsNullOrEmpty(this.tfDeposit.Text)) { obj.Add("Deposit", this.tfDeposit.Number); }
            else { obj.Add("Deposit", 0); }
            if (!string.IsNullOrEmpty(this.tfInform.Text)) { obj.Add("Inform", this.tfInform.Text); }
            else { obj.Add("Inform", ""); }
            if (!string.IsNullOrEmpty(this.hidContractAttachment.Text)) { obj.Add("Attachment",this.hidContractAttachment.Text); }
            else { obj.Add("Attachment", ""); }
            return obj;
        }
        #endregion
    }
}