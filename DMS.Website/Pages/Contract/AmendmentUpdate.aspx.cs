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
    public partial class AmendmentUpdate : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;

        ContractAmendmentService ContractBll = new ContractAmendmentService();
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
            DataTable dt = ContractBll.GetUpdatelog(this.ContractId==""? "00000000-0000-0000-0000-000000000000" : this.ContractId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
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
            DataTable dt = ContractBll.SelectAmendmentMain(obj).Tables[0];
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
            DataTable dtMain = ContractBll.SelectAmendmentMain(obj).Tables[0];
            DataTable dtProposals = ContractBll.SelectAmendmentProposals(obj).Tables[0];


            //绑定合同数据
            if (dtMain.Rows.Count > 0)
            {   //绑定主数据
                DataRow drMian = dtMain.Rows[0];
                this.labDealerBeginDate.Text = drMian["DealerBeginDate"] != DBNull.Value ? Convert.ToDateTime(drMian["DealerBeginDate"]).ToShortDateString() : "";
                this.labDealerEndDate.Text = drMian["DealerEndDate"] != DBNull.Value ? Convert.ToDateTime(drMian["DealerEndDate"]).ToShortDateString() : "";
                this.dfAmendEffectiveDate.SelectedDate = Convert.ToDateTime(drMian["AmendEffectiveDate"]);
                this.cbIsEquipment.SelectedItem.Value = drMian["IsEquipment"].ToString();
                if (drMian["Assessment"] != DBNull.Value)
                    this.cbAssessment.SelectedItem.Value = drMian["Assessment"].ToString();
                if (drMian["AssessmentStart"] != DBNull.Value)
                    this.dfAssessmentStart.SelectedDate = Convert.ToDateTime(drMian["AssessmentStart"]);
                if (drMian["Purpose"] != DBNull.Value)
                    this.taPurpose.Text = drMian["Purpose"].ToString();
            }
            //绑定修改数据
            if (dtProposals.Rows.Count > 0)
            {   //绑定主数据
                DataRow drProposals = dtProposals.Rows[0];
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
                if(drProposals["Attachment"]!= DBNull.Value)
                    this.hidContractAttachment.Text= drProposals["Attachment"].ToString();
                this.gpContractAttachment.Reload();
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
            AmendmentMainTemp main = GetMainFormValue();
            AmendmentProposalsTemp proposals = GetProposalsFormValue();
            bool result = ContractBll.SaveAmendmentUpdate(main, proposals);

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
                    string newFileName = "Upload/Contract/" + DateTime.Now.ToString("yyyyMMdd")+"-"+ Guid.NewGuid().ToString() + "." + fileExt;

                    //上传文件在Upload文件夹

                    string file = Server.MapPath("~") +  newFileName;


                    //文件上传
                    FileUploadContract.PostedFile.SaveAs(file);

                    Hashtable obj = new Hashtable();
                    obj.Add("FileName", fileExtention);
                    obj.Add("FileUrl", newFileName);
                    obj.Add("CreateUser", _context.User.Id);
                    ContractBll.UploadContractAttachment(obj);

                    Hashtable table = new Hashtable();
                    table.Add("FileUrl", newFileName);
                    DataSet dsActId= ContractBll.GetContractAttachmentAdmin(table);
                    if (dsActId.Tables[0].Rows.Count > 0)
                    {
                        this.hidContractAttachment.Text = (this.hidContractAttachment.Text == "" ? dsActId.Tables[0].Rows[0]["AttId"].ToString() : (this.hidContractAttachment.Text+"," + dsActId.Tables[0].Rows[0]["AttId"].ToString()));
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
            attachmentList = attachmentList.Replace(attId+",", "").Replace(","+ attId,"").Replace(attId,"");
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
            this.labDealerBeginDate.Text = "";
            this.cbAssessment.SelectedItem.Value = "";
            this.taPurpose.Text = "";
            this.labDealerEndDate.Text = "";
            this.dfAssessmentStart.Clear();
            this.dfAmendEffectiveDate.Clear();
            this.cbIsEquipment.SelectedItem.Value = "";
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
        private AmendmentMainTemp GetMainFormValue()
        {
            AmendmentMainTemp main = new AmendmentMainTemp();
            main.TempId = new Guid(this.UpdateId);
            main.ContractId = new Guid(this.ContractId);
            main.AmendEffectiveDate = this.dfAmendEffectiveDate.SelectedDate;
            if (!string.IsNullOrEmpty(this.taPurpose.Text)) { main.Purpose = this.taPurpose.Text; }
            if (!string.IsNullOrEmpty(this.cbIsEquipment.SelectedItem.Value)) { main.IsEquipment = Convert.ToInt32(this.cbIsEquipment.SelectedItem.Value); }
            if (!string.IsNullOrEmpty(this.cbAssessment.SelectedItem.Value)) { main.Assessment = this.cbAssessment.SelectedItem.Value; }
            if (!this.dfAssessmentStart.IsNull) { main.AssessmentStart = this.dfAssessmentStart.SelectedDate; }
            main.UpdateUser = new Guid(_context.User.Id);
            main.UpdateDate = DateTime.Now;
            return main;
        }
        private AmendmentProposalsTemp GetProposalsFormValue()
        {
            AmendmentProposalsTemp proposals = new AmendmentProposalsTemp();
            proposals.TempId = new Guid(this.UpdateId);
            proposals.ContractId = new Guid(this.ContractId);
            if (this.rgCOD.Checked) { proposals.Payment = "COD"; }
            else if (this.rgLC.Checked) { proposals.Payment = "LC"; }
            else if (this.rgCredit.Checked) { proposals.Payment = "Credit"; }

            if (this.rg30.Checked) { proposals.CreditTerm = "30"; }
            else if (this.rg60.Checked) { proposals.CreditTerm = "60"; }
            else if (this.rg90.Checked) { proposals.CreditTerm = "90"; }
            else if (this.rg120.Checked) { proposals.CreditTerm = "120"; }
            else if (this.rg150.Checked) { proposals.CreditTerm = "150"; }
            if (!string.IsNullOrEmpty(this.tfCreditLimit.Text)) { proposals.CreditLimit = Convert.ToInt32(this.tfCreditLimit.Number); }
            if (this.rgDepositYear.Checked) { proposals.IsDeposit = 1; }
            else if(this.rgDepositNo.Checked) { proposals.IsDeposit = 0; }
            if (!string.IsNullOrEmpty(this.tfDeposit.Text)) { proposals.Deposit = Convert.ToInt32(this.tfDeposit.Number); }
            if (!string.IsNullOrEmpty(this.tfInform.Text)) { proposals.Inform = this.tfInform.Text; }
            if (!string.IsNullOrEmpty(this.hidContractAttachment.Text)) { proposals.Attachment = this.hidContractAttachment.Text; }
            else { proposals.Attachment = ""; }
            return proposals;
        }
        #endregion
    }
}