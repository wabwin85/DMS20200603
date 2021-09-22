using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Model.Data;
using Coolite.Ext.Web;
using System.Collections;
using DMS.Model;
using DMS.Business;
using DMS.Business.Contract;
using Lafite.RoleModel.Security;
using DMS.Common;
using DMS.Website.Common;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.IO;
using System.Data;

namespace DMS.Website.Pages.Contract
{
    public partial class ContractDeatil : BasePage
    {
        private IContractMaster _contract = new DMS.Business.ContractMaster();
        private IContractMasterBLL _contractBll = new ContractMasterBLL();
        private IContractAmendmentService _contAmendment = new ContractAmendmentService();
        private IContractAppointmentService _contAppointment = new ContractAppointmentService();
        private IContractRenewalService _renewal = new ContractRenewalService();
        private IContractTerminationService _termination = new ContractTerminationService();
        private IMessageBLL _messageBLL = new MessageBLL();
        private IPurchaseOrderBLL _purchaseOrderBLL = new PurchaseOrderBLL();
        private IDealerMasters _dealerMasters = new DealerMasters();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["ContractID"] != null && Request.QueryString["ParmetType"] != null
                     && Request.QueryString["DealerType"] != null)
                {
                    Session["PageOperationType"] = null;
                    Session["conMast"] = null;

                    this.hidParmetType.Value = Request.QueryString["ParmetType"].ToString();//合同参数类型 
                    this.hidContractId.Value = Request.QueryString["ContractID"].ToString();//合同ID
                    this.hidDealerType.Value = Request.QueryString["DealerType"].ToString();//经销商类型
                    GetContractBase();
                    if (this.hidContStatus.Value.ToString().Equals(ContractStatus.Completed.ToString()))
                    {
                        this.tabContract.Hidden = false;
                    }
                    AccessControl();
                    PageControl();
                    BindIfUrl();
                    Session["From3"] = null;
                    Session["From4"] = null;
                    Session["From5"] = null;
                    Session["From6"] = null;
                    Session["From6-1"] = null;
                }
            }
        }

        [AjaxMethod]
        public void ShowReturnIAFWindow()
        {
            this.taRemark.Clear();
            //Show Window
            this.windowReturnIAF.Show();
        }

        [AjaxMethod]
        public string SubmintReturnIAF()
        {
            string Error = "";
            try
            {
                _purchaseOrderBLL.InsertPurchaseOrderLog(new Guid(this.hidContractId.Value.ToString()), new Guid(RoleModelContext.Current.User.Id), PurchaseOrderOperationType.Reject, this.taRemark.Text);
                MailMessageTemplate mailMessage = _messageBLL.GetMailMessageTemplate(MailMessageTemplateCode.EMAIL_CONTRACT_IAFUPDATE_TODEALER.ToString());
                Hashtable ht = new Hashtable();
                ht.Add("Cmid", this.hidCmid.Value);
                ht.Add("CmStatus", ContractMastreStatus.Draft.ToString());
                int i = _contract.UpdateContractMasterStatus(ht);

                #region 邮件通知经销商
                DealerMaster dMaster = _dealerMasters.GetDealerMaster(new Guid(this.hidDealerId.Value.ToString()));
                if (!String.IsNullOrEmpty(dMaster.Email))
                {
                    MailMessageQueue mail = new MailMessageQueue();
                    mail.Id = Guid.NewGuid();
                    mail.QueueNo = "email";
                    mail.From = "";
                    mail.To = dMaster.Email;
                    mail.Subject = mailMessage.Subject;
                    mail.Body = mailMessage.Body.Replace("{#DealerName}", this.hidDealerName.Value.ToString());
                    mail.Status = "Waiting";
                    mail.CreateDate = DateTime.Now;
                    _messageBLL.AddToMailMessageQueue(mail);
                }
                else
                {
                    Error = "经销商邮箱未维护，邮件发送失败!";
                }

                #endregion

                windowReturnIAF.Hide();
                return Error;

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }


        [AjaxMethod]
        public string SaveSubmit()
        {
            try
            {
                string Error = "";
                if (Session["From3"] == null)
                {
                    Error += "请先保存From3到草稿状态<br/>";
                }
                //if (Session["From4"] == null)
                //{
                //    Error += "请先保存From4到草稿状态<br/>";
                //}
                if (Session["From5"] == null)
                {
                    Error += "请先保存From5到草稿状态<br/>";
                }
                if (Session["From6-1"] == null)
                {
                    Error += "请先保存From6到草稿状态<br/>";
                }
                if (Session["From6"] == null || !Convert.ToBoolean(Session["From6"].ToString()))
                {
                    Error += "请确保From6列表不少于3条数据<br/>";
                }
               
                if (Error.Equals(""))
                {
                    Hashtable ht = new Hashtable();
                    ht.Add("Cmid", this.hidCmid.Value);
                    ht.Add("CmStatus", ContractMastreStatus.Submit.ToString());
                    int i = _contract.UpdateContractMasterStatus(ht);
                    if (i > 0)
                    {
                        //修改合同中CM_ID
                        if (this.hidParmetType.Value.ToString().Equals(ContractType.Appointment.ToString()))
                        {
                            Hashtable htCon = new Hashtable();
                            htCon.Add("CapId", this.hidContractId.Value);
                            htCon.Add("CapCmId", this.hidCmid.Value);
                            int n = _contAppointment.UpdateAppointmentCmidByConid(htCon);
                        }
                        else if (this.hidParmetType.Value.ToString().Equals(ContractType.Renewal.ToString()))
                        {
                            Hashtable htCon = new Hashtable();
                            htCon.Add("CreId", this.hidContractId.Value);
                            htCon.Add("CreCmId", this.hidCmid.Value);
                            int n = _renewal.UpdateRenewalCmidByConid(htCon);
                        }

                        //记录log信息
                        _purchaseOrderBLL.InsertPurchaseOrderLog(new Guid(this.hidContractId.Value.ToString()), new Guid(RoleModelContext.Current.User.Id), PurchaseOrderOperationType.Submit, this.taRemark.Text);

                        MailMessageTemplate mailMessage = _messageBLL.GetMailMessageTemplate(MailMessageTemplateCode.EMAIL_CONTRACT_IAFSUBMINT_TOCO.ToString());
                        //string co_email = System.Configuration.ConfigurationManager.AppSettings["co_email"].ToString();
                        Hashtable tbaddress = new Hashtable();
                        tbaddress.Add("MailType", "DCMS");
                        tbaddress.Add("MailTo", "CO");
                        IList<MailDeliveryAddress> Addresslist = _contractBll.GetMailDeliveryAddress(tbaddress);

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
                                mail.Subject = mailMessage.Subject.Replace("{#DealerName}", this.hidDealerName.Value.ToString());
                                mail.Body = mailMessage.Body.Replace("{#DealerName}", this.hidDealerName.Value.ToString());
                                mail.Status = "Waiting";
                                mail.CreateDate = DateTime.Now;
                                _messageBLL.AddToMailMessageQueue(mail);
                            }
                        }
                    }
                    else
                    {
                        Error += "请保存'草稿'状态后再提交<br/>";
                    }
                }
                if (!Error.Equals("")) Error = Error.Substring(0, Error.Length - 5);

                return Error;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        [AjaxMethod]
        public void SaveConfirm()
        {
            try
            {
                Hashtable table = new Hashtable();
                table.Add("CapId", this.hidContractId.Value);
                table.Add("COConfirm", true);
                int i = _contAppointment.UpdateAppointmentCOConfirmByConid(table);
                this.btnConfirm.Enabled = false;
                Ext.Msg.Alert("Success", "已完成确认").Show();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

        }

        [AjaxMethod]
        public void SaveLPConfirm()
        {
            try
            {
                Hashtable table = new Hashtable();
                table.Add("CteId", this.hidContractId.Value);
                table.Add("Status", ContractStatus.LPConfirm.ToString());
                int i = _termination.UpdateTerminationStatusByConid(table);
                this.btnLPConfirm.Enabled = false;
                Ext.Msg.Alert("Success", "已完成确认").Show();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        [AjaxMethod]
        public void ShowAuthorizationWindow()
        {
            this.tfAuthorizationCode.Clear();
            this.tfAuthorizationContacts.Clear();
            this.tfAuthorizationPhone.Clear();
            if (this.hidDealerType.Value.Equals(DealerType.T2.ToString()))
            {
                this.tfAuthorizationContacts.Hidden = false;
                this.tfAuthorizationPhone.Hidden = false;
            }
            else 
            {
                this.tfAuthorizationContacts.Hidden = true;
                this.tfAuthorizationPhone.Hidden = true;
            }
            //Show Window
            this.windowAuthorization.Show();
        }

        protected void CreatLetterAuthorizationpdf(object sender, EventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", new Guid(this.hidContractId.Value.ToString()));
            obj.Add("ParmetType", this.hidParmetType.Value.ToString());
            DataTable dtParmet = _contractBll.GetAuthorCodeAndDivName(obj).Tables[0];

            string fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
            string targetPath = Server.MapPath(PdfHelper.FILE_PATH + fileName);

            Document doc = new Document(iTextSharp.text.PageSize.A4, 60, 60, 22, 32);
            try
            {
                //注册中文字库
                PdfHelper.RegisterChineseFont();
                PdfHelper pdfFont = new PdfHelper();

                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));

                doc.Open();

                #region Pdf Title
                //Font heiBoldChineseFont = FontFactory.GetFont("黑体", BaseFont.IDENTITY_H, BaseFont.EMBEDDED, 22, Font.BOLD);
                Font heiBoldChineseFont = FontFactory.GetFont("PMingLiU", BaseFont.IDENTITY_H, BaseFont.EMBEDDED, 22, Font.BOLD);
                Font heiChineseFont = FontFactory.GetFont("PMingLiU", BaseFont.IDENTITY_H, BaseFont.EMBEDDED, 14);

                //设置Title Tabel 
                PdfPTable titleTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(titleTable);

                //PdfPCell contractNoCell = new PdfPCell(new Paragraph("【编号：" + dtParmet.Rows[0]["AuthorCode"].ToString() + "】", heiChineseFont));
                PdfPCell contractNoCell = new PdfPCell(new Paragraph("【编号：" + this.tfAuthorizationCode.Text + "】", heiChineseFont));
                contractNoCell.HorizontalAlignment = Rectangle.ALIGN_LEFT;
                contractNoCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                contractNoCell.PaddingBottom = 9f;
                contractNoCell.FixedHeight = 30f;
                contractNoCell.Border = 0;
                titleTable.AddCell(contractNoCell);

                //Pdf标题
                PdfPCell titleCell = new PdfPCell(new Paragraph("配送商授权书", heiBoldChineseFont));
                titleCell.HorizontalAlignment = Rectangle.ALIGN_CENTER;
                titleCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                titleCell.PaddingBottom = 9f;
                titleCell.FixedHeight = 100f;
                titleCell.Border = 0;
                titleTable.AddCell(titleCell);

                //添加至pdf中
                PdfHelper.AddPdfTable(doc, titleTable);

                #endregion

                Phrase phrase1 = new Phrase();
                if (!this.hidDealerType.Value.Equals(DealerType.T2.ToString()))
                {
                    phrase1.Add(Chunk.NEWLINE);
                    phrase1.Add(Chunk.NEWLINE);
                    phrase1.Add(new Chunk("本公司", heiChineseFont));
                    phrase1.Add(new Chunk("　蓝威医疗科技(上海)有限公司　", heiChineseFont).SetUnderline(1f, -2f));
                    phrase1.Add(new Chunk("为提高产品覆盖，向医疗机构提供更为优质高效的服务, 特授权", heiChineseFont));
                    phrase1.Add(new Chunk(" " + this.hidDealerName.Value.ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                    phrase1.Add(new Chunk("为本公司在", heiChineseFont));
                    phrase1.Add(new Chunk("（授权区域详见下述清单）", heiChineseFont).SetUnderline(1f, -2f));
                    phrase1.Add(new Chunk("的配送企业，负责承担在授权时限内对我司", heiChineseFont));
                    phrase1.Add(new Chunk("　" + dtParmet.Rows[0]["DivName"].ToString() + " " + (dtParmet.Rows[0]["AuthorNameString"].ToString() == "" ? "" : dtParmet.Rows[0]["AuthorNameString"].ToString()), heiChineseFont).SetUnderline(1f, -2f));
                    phrase1.Add(new Chunk("的配送和结算工作。", heiChineseFont));
                    phrase1.Add(new Chunk(" " + this.hidDealerName.Value.ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                    phrase1.Add(new Chunk("将保证及时供货并提供全面、完善的服务。", heiChineseFont));
                    phrase1.Add(Chunk.NEWLINE);
                    phrase1.Add(Chunk.NEWLINE);
                    phrase1.Add(new Chunk("授权医院清单如下：", heiChineseFont));
                    phrase1.Add(Chunk.NEWLINE);

                    DataTable dtTerritorynew = _contractBll.GetContractTerritoryByContractId(new Guid(this.hidContractId.Value.ToString())).Tables[0];
                    for (int i = 0; i < dtTerritorynew.Rows.Count; i++)
                    {
                        phrase1.Add(new Chunk((i + 1) + ". " + dtTerritorynew.Rows[i]["HospitalName"].ToString(), heiChineseFont));
                        phrase1.Add(Chunk.NEWLINE);
                    }

                    phrase1.Add(Chunk.NEWLINE);
                    phrase1.Add(Chunk.NEWLINE);
                    phrase1.Add(Chunk.NEWLINE);
                    if (this.hidDealerType.Value.Equals(DealerType.T1.ToString()))
                    {
                        phrase1.Add(new Chunk("本授权不得转让。", heiChineseFont));
                        phrase1.Add(Chunk.NEWLINE);
                        phrase1.Add(Chunk.NEWLINE);
                    }
                    DateTime dtEffectiveDate = Convert.ToDateTime(this.hidEffectiveDate.Value.ToString());
                    DateTime dtExpirationDate = Convert.ToDateTime(this.hidExpirationDate.Value.ToString());
                    phrase1.Add(new Chunk("本授权书授权期限为", heiChineseFont));
                    phrase1.Add(new Chunk(" " + dtEffectiveDate.Year.ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                    phrase1.Add(new Chunk("年", heiChineseFont));
                    phrase1.Add(new Chunk(" " + dtEffectiveDate.Month.ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                    phrase1.Add(new Chunk("月", heiChineseFont));
                    phrase1.Add(new Chunk(" " + dtEffectiveDate.Day.ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                    phrase1.Add(new Chunk("日至", heiChineseFont));
                    phrase1.Add(new Chunk(" " + dtExpirationDate.Year.ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                    phrase1.Add(new Chunk("年", heiChineseFont));
                    phrase1.Add(new Chunk(" " + dtExpirationDate.Month.ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                    phrase1.Add(new Chunk("月", heiChineseFont));
                    phrase1.Add(new Chunk(" " + dtExpirationDate.Day.ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                    phrase1.Add(new Chunk("日。", heiChineseFont));

                    phrase1.Add(Chunk.NEWLINE);
                    phrase1.Add(Chunk.NEWLINE);

                    phrase1.Add(new Chunk("　　　　　　　　　　蓝威医疗科技(上海)有限公司", heiChineseFont));
                    phrase1.Add(new Chunk(Chunk.NEWLINE));
                    phrase1.Add(Chunk.NEWLINE);
                    phrase1.Add(new Chunk("　　　　　　　　　　　　 " + DateTime.Now.Year.ToString() + " 年", heiChineseFont));
                    phrase1.Add(new Chunk(DateTime.Now.Month.ToString(), heiChineseFont).SetUnderline(1f, -2f));
                    phrase1.Add(new Chunk(" 月 ", heiChineseFont));
                    phrase1.Add(new Chunk(DateTime.Now.Day.ToString(), heiChineseFont).SetUnderline(1f, -2f));
                    phrase1.Add(new Chunk(" 日", heiChineseFont));
                }
                else 
                {
                    DataTable dtParent= _dealerMasters.GetParentDealer(new Guid(this.hidDealerId.Value.ToString())).Tables[0];
                    if (dtParent.Rows.Count > 0)
                    {
                        phrase1.Add(Chunk.NEWLINE);
                        phrase1.Add(Chunk.NEWLINE);
                        phrase1.Add(new Chunk("        本公司", heiChineseFont));
                        phrase1.Add(new Chunk("　" + dtParent.Rows[0]["ParentDealerName"].ToString() + "　", heiChineseFont).SetUnderline(1f, -2f));
                        phrase1.Add(new Chunk(" 特授权", heiChineseFont));
                        phrase1.Add(new Chunk(" " + dtParent.Rows[0]["DealerName"].ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                        phrase1.Add(new Chunk("为本公司在", heiChineseFont));
                        phrase1.Add(new Chunk("（授权医院详见清单）", heiChineseFont).SetUnderline(1f, -2f));
                        phrase1.Add(new Chunk("的配送企业，负责承担在授权时限内对我司销售的", heiChineseFont));
                        phrase1.Add(new Chunk("　蓝威医疗科技(上海)有限公司 " + dtParmet.Rows[0]["DivName"].ToString() + " " + (dtParmet.Rows[0]["AuthorNameString"].ToString() == "" ? "" : dtParmet.Rows[0]["AuthorNameString"].ToString()), heiChineseFont).SetUnderline(1f, -2f));
                        phrase1.Add(new Chunk("的配送和结算工作。", heiChineseFont));
                        phrase1.Add(new Chunk(" " + dtParent.Rows[0]["DealerName"].ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                        phrase1.Add(new Chunk("将保证及时供货并提供全面、完善的服务。", heiChineseFont));
                        phrase1.Add(Chunk.NEWLINE);
                        phrase1.Add(Chunk.NEWLINE);
                        phrase1.Add(new Chunk("授权医院清单如下：", heiChineseFont));
                        phrase1.Add(Chunk.NEWLINE);

                        DataTable dtTerritorynew = _contractBll.GetContractTerritoryByContractId(new Guid(this.hidContractId.Value.ToString())).Tables[0];
                        for (int i = 0; i < dtTerritorynew.Rows.Count; i++)
                        {
                            phrase1.Add(new Chunk((i + 1) + ". " + dtTerritorynew.Rows[i]["HospitalName"].ToString(), heiChineseFont));
                            phrase1.Add(Chunk.NEWLINE);
                        }

                        phrase1.Add(Chunk.NEWLINE);
                        phrase1.Add(Chunk.NEWLINE);
                        phrase1.Add(Chunk.NEWLINE);
                        phrase1.Add(new Chunk("本授权不得转让。", heiChineseFont));

                        phrase1.Add(Chunk.NEWLINE);
                        phrase1.Add(Chunk.NEWLINE);

                        DateTime dtEffectiveDate = Convert.ToDateTime(this.hidEffectiveDate.Value.ToString());
                        DateTime dtExpirationDate = Convert.ToDateTime(this.hidExpirationDate.Value.ToString());
                        phrase1.Add(new Chunk("        本授权书授权期限为", heiChineseFont));
                        phrase1.Add(new Chunk(" " + dtEffectiveDate.Year.ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                        phrase1.Add(new Chunk("年", heiChineseFont));
                        phrase1.Add(new Chunk(" " + dtEffectiveDate.Month.ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                        phrase1.Add(new Chunk("月", heiChineseFont));
                        phrase1.Add(new Chunk(" " + dtEffectiveDate.Day.ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                        phrase1.Add(new Chunk("日至", heiChineseFont));
                        phrase1.Add(new Chunk(" " + dtExpirationDate.Year.ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                        phrase1.Add(new Chunk("年", heiChineseFont));
                        phrase1.Add(new Chunk(" " + dtExpirationDate.Month.ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                        phrase1.Add(new Chunk("月", heiChineseFont));
                        phrase1.Add(new Chunk(" " + dtExpirationDate.Day.ToString() + " ", heiChineseFont).SetUnderline(1f, -2f));
                        phrase1.Add(new Chunk("日。 ", heiChineseFont));
                        if (!tfAuthorizationContacts.Text.Equals(""))
                        {
                            phrase1.Add(new Chunk(" " + dtParent.Rows[0]["ParentDealerName"].ToString() + " 联系人和方式：" + this.tfAuthorizationContacts.Text + "  电话：" + this.tfAuthorizationPhone.Text, heiChineseFont));
                        }

                        phrase1.Add(Chunk.NEWLINE);
                        phrase1.Add(Chunk.NEWLINE);

                        phrase1.Add(new Chunk("　　　　　　　　　　　　　　　　" + dtParent.Rows[0]["ParentDealerName"].ToString(), heiChineseFont));
                        phrase1.Add(new Chunk(Chunk.NEWLINE));
                        phrase1.Add(Chunk.NEWLINE);
                        phrase1.Add(new Chunk("　　　　　　　　　　　　　　　　　　    " + DateTime.Now.Year.ToString() + " 年", heiChineseFont));
                        phrase1.Add(new Chunk(" " +DateTime.Now.Month.ToString()+" ", heiChineseFont).SetUnderline(1f, -2f));
                        phrase1.Add(new Chunk(" 月 ", heiChineseFont));
                        phrase1.Add(new Chunk(" " +DateTime.Now.Day.ToString()+" ", heiChineseFont).SetUnderline(1f, -2f));
                        phrase1.Add(new Chunk(" 日", heiChineseFont));
                    }
                }

                Paragraph paragraph1 = new Paragraph();
                paragraph1.Add(phrase1);
                paragraph1.Alignment = Rectangle.ALIGN_JUSTIFIED;
                paragraph1.KeepTogether = true;
                paragraph1.Leading = 20f;

                doc.Add(paragraph1);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                doc.Close();
            }
            this.windowAuthorization.Hide();
            DownloadFileForDCMS(fileName, "授权书.pdf", "DCMS");

        }

        private void BindIfUrl()
        {
            this.tabForm1.AutoLoad.Url = "ContractForm1.aspx?ContId=" + this.hidContractId.Value + "&CmId=" + this.hidCmid.Value + "&ParmetType=" + this.hidParmetType.Value;
            this.tabForm2.AutoLoad.Url = "ContractForm2.aspx?CmId=" + this.hidCmid.Value + "&CmStatus=" + this.hidCmStatus.Value + "&DealerId=" + this.hidDealerId.Value + "&ContId=" + this.hidContractId.Value + "&ParmetType=" + this.hidParmetType.Value;
            this.tabForm3.AutoLoad.Url = "ContractForm3.aspx?CmId=" + this.hidCmid.Value + "&CmStatus=" + this.hidCmStatus.Value + "&DealerId=" + this.hidDealerId.Value + "&DealerCnName=" + this.hidDealerName.Value + "&ContStatus=" + this.hidContStatus.Value + "&ParmetType=" + this.hidParmetType.Value + "&ContId=" + this.hidContractId.Value;
            //设备经销商与耗材经销商From3保持一致
            this.tabForm3_Equipment.AutoLoad.Url = "ContractForm3.aspx?CmId=" + this.hidCmid.Value + "&CmStatus=" + this.hidCmStatus.Value + "&DealerId=" + this.hidDealerId.Value + "&DealerCnName=" + this.hidDealerName.Value + "&ContStatus=" + this.hidContStatus.Value + "&ParmetType=" + this.hidParmetType.Value + "&ContId=" + this.hidContractId.Value;
            this.tabForm4.AutoLoad.Url = "ContractForm4.aspx?CmId=" + this.hidCmid.Value + "&CmStatus=" + this.hidCmStatus.Value + "&DealerId=" + this.hidDealerId.Value + "&DealerCnName=" + this.hidDealerName.Value + "&ContStatus=" + this.hidContStatus.Value + "&ContId=" + this.hidContractId.Value; ;
            this.tabForm5.AutoLoad.Url = "ContractForm5.aspx?CmId=" + this.hidCmid.Value + "&CmStatus=" + this.hidCmStatus.Value + "&DealerId=" + this.hidDealerId.Value + "&DealerCnName=" + this.hidDealerName.Value + "&ContStatus=" + this.hidContStatus.Value + "&ContId=" + this.hidContractId.Value; ;
            this.tabForm6.AutoLoad.Url = "ContractForm6.aspx?CmId=" + this.hidCmid.Value + "&CmStatus=" + this.hidCmStatus.Value + "&DealerId=" + this.hidDealerId.Value + "&DealerCnName=" + this.hidDealerName.Value + "&ContStatus=" + this.hidContStatus.Value + "&ContId=" + this.hidContractId.Value; ;
            this.tabForm7.AutoLoad.Url = "ContractForm7.aspx?CmId=" + this.hidCmid.Value + "&CmStatus=" + this.hidCmStatus.Value + "&DealerId=" + this.hidDealerId.Value + "&ContId=" + this.hidContractId.Value;
            //this.tabThirdParty.AutoLoad.Url = "ContractThirdParty.aspx?ContId=" + this.hidContractId.Value + "&CmStatus=" + this.hidCmStatus.Value + "&DealerId=" + this.hidDealerId.Value + "&DealerCnName=" + this.hidDealerName.Value + "&ContStatus=" + this.hidContStatus.Value + "&DealerType=" + this.hidDealerType.Value + "&Division=" + this.hidDivision.Value;
            this.tabAnnex.AutoLoad.Url = "MergeAttachment.aspx?Cmid=" + this.hidCmid.Value + "&ParmetType=" + this.hidParmetType.Value + "&ContId=" + this.hidContractId.Value + "&DealerId=" + this.hidDealerId.Value + "&DealerType=" + this.hidDealerType.Value;

            if (this.hidParmetType.Value.ToString().Equals(ContractType.Appointment.ToString()))
            {
                this.tabContract.AutoLoad.Url = "ContractAppendix1.aspx?ContId=" + this.hidContractId.Value + "&CmId=" + this.hidCmid.Value + "&DealerLv=" + this.hidDealerType.Value;
            }
            else if (this.hidParmetType.Value.ToString().Equals(ContractType.Amendment.ToString()))
            {
                this.tabContract.AutoLoad.Url = "ContractAppendix2.aspx?ContId=" + this.hidContractId.Value + "&CmId=" + this.hidCmid.Value + "&DealerLv=" + this.hidDealerType.Value + "&ContStatus=" + this.hidContStatus.Value; ;
            }
            else if (this.hidParmetType.Value.ToString().Equals(ContractType.Renewal.ToString()))
            {
                this.tabContract.AutoLoad.Url = "ContractAppendix3.aspx?ContId=" + this.hidContractId.Value + "&CmId=" + this.hidCmid.Value + "&DealerLv=" + this.hidDealerType.Value + "&ContStatus=" + this.hidContStatus.Value; ;
            }
            else if (this.hidParmetType.Value.ToString().Equals(ContractType.Termination.ToString()))
            {
                this.tabContract.AutoLoad.Url = "ContractAppendix4.aspx?ContId=" + this.hidContractId.Value + "&CmId=" + this.hidCmid.Value + "&DealerLv=" + this.hidDealerType.Value;
            }

            this.tabIAFOperation.AutoLoad.Url = "ContractIAFOperation.aspx?ContId=" + this.hidContractId.Value;
        }

        private void GetContractBase()
        {
            if (this.hidParmetType.Value.ToString().Equals(ContractType.Appointment.ToString()))
            {
                ContractAppointment ConApm = _contAppointment.GetContractAppointmentByID(new Guid(this.hidContractId.Value.ToString()));
                if (ConApm != null)
                {
                    this.hidCmid.Value = ConApm.CapCmId;
                    this.hidDealerId.Value = ConApm.CapDmaId;
                    this.hidContStatus.Value = ConApm.CapStatus;
                    this.hidContractType.Value = ConApm.CapType;
                    this.hidDealerName.Value = ConApm.CapCompanyName;
                    this.hidEffectiveDate.Value = ConApm.CapEffectiveDate;
                    this.hidExpirationDate.Value = ConApm.CapExpirationDate;
                    this.hidDivision.Value = ConApm.CapDivision;
                    this.hidConfirm.Value = (ConApm.CapCoConfirm == null ? "0" : "1");
                    this.hidSuBU.Value = ConApm.CapSubdepId;

                }
            }
            if (this.hidParmetType.Value.ToString().Equals(ContractType.Amendment.ToString()))
            {
                ContractAmendment amendment = _contAmendment.GetContractAmendmentByID(new Guid(this.hidContractId.Value.ToString()));
                if (amendment != null)
                {
                    this.hidCmid.Value = amendment.CamCmId;
                    this.hidDealerId.Value = amendment.CamDmaId;
                    this.hidContStatus.Value = amendment.CamStatus;
                    this.hidContractType.Value = amendment.CamType;
                    this.hidDealerName.Value = amendment.CamDealerName;
                    this.hidEffectiveDate.Value = amendment.CamAmendmentEffectiveDate;
                    this.hidExpirationDate.Value = amendment.CamAgreementExpirationDate;
                    this.hidDivision.Value = amendment.CamDivision;
                    this.hidSuBU.Value = amendment.CamSubDepid;
                }
            }
            if (this.hidParmetType.Value.ToString().Equals(ContractType.Renewal.ToString()))
            {
                ContractRenewal renewal = _renewal.GetContractRenewalByID(new Guid(this.hidContractId.Value.ToString()));
                if (renewal != null)
                {
                    this.hidCmid.Value = renewal.CreCmId;
                    this.hidDealerId.Value = renewal.CreDmaId;
                    this.hidContStatus.Value = renewal.CreStatus;
                    this.hidContractType.Value = renewal.CreType;
                    this.hidDealerName.Value = renewal.CreDealerName;
                    this.hidEffectiveDate.Value = renewal.CreAgrmtEffectiveDateRenewal;
                    this.hidExpirationDate.Value = renewal.CreAgrmtExpirationDateRenewal;
                    this.hidDivision.Value = renewal.CreDivision;
                    this.hidSuBU.Value = renewal.CreSubDepid;
                }
            }
            if (this.hidParmetType.Value.ToString().Equals(ContractType.Termination.ToString()))
            {
                ContractTermination term = _termination.GetContractTerminationByID(new Guid(this.hidContractId.Value.ToString()));
                if (term != null)
                {
                    this.hidCmid.Value = term.CteCmId;
                    this.hidDealerId.Value = term.CteDmaId;
                    this.hidContStatus.Value = term.CteStatus;
                    this.hidContractType.Value = term.CteType;
                    this.hidDealerName.Value = term.CteDealerName;
                    this.hidDivision.Value = term.CteDivision;
                    this.hidSuBU.Value = term.CteSubDepid;
                }
            }
        }

        #region 页面数据绑定及操作方式
        private void AccessControl()
        {
            //if (!this.hidContractType.Value.ToString().Equals("1"))
            //{
                #region 非设备经销商
                if (this.hidDealerType.Value.ToString().Equals(DealerType.T1.ToString()) || this.hidDealerType.Value.ToString().Equals(DealerType.LP.ToString()) || this.hidDealerType.Value.ToString().Equals(DealerType.LS.ToString()))
                {
                    #region LP 、T1 绑定经销商表格信息
                    if (this.hidCmid.Value.ToString().Equals("00000000-0000-0000-0000-000000000000"))
                    {
                        this.hidCmid.Value = this.BindContractMasteId();
                    }
                   
                    //已经维护过经销商表格信息
                    Hashtable table = new Hashtable();
                    table.Add("CmId", this.hidCmid.Value);
                    ContractMasterDM conMast = _contract.GetContractMasterByCmID(table);
                    Session["conMast"] = conMast;
                    Session["PageOperationType"] = PageOperationType.EDIT.ToString();
                    if (conMast.CmStatus.Equals(ContractMastreStatus.Submit.ToString()))
                    {
                        this.btnSubmit.Hidden = true;
                        if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation)
                            && (this.hidParmetType.Value.ToString().Equals(ContractType.Appointment.ToString())
                            || this.hidParmetType.Value.ToString().Equals(ContractType.Renewal.ToString())))
                        {
                            if (this.hidContStatus.Value.ToString().Equals(ContractStatus.COApproved.ToString()))
                            {
                                this.btnIAFReturn.Hidden = false;
                            }
                            else
                            {
                                this.btnIAFReturn.Hidden = true; ;
                            }
                        }
                    }
                    this.hidCmStatus.Value = conMast.CmStatus;
                    
                    #endregion
                }
                else
                {
                    //二级经销商
                    this.btnIAFReturn.Hidden = true; //退回IAF不可用
                    this.btnSubmit.Hidden = true; // 提交IAF不可用
                }
                #endregion
            //}
            //else
            //{
            //    #region 设备经销商
            //    if (this.hidCmid.Value.ToString().Equals("00000000-0000-0000-0000-000000000000"))
            //    {
            //        this.hidCmid.Value= this.BindContractMasteId();
            //    }
               
            //    //已经维护过经销商表格信息
            //    Hashtable table = new Hashtable();
            //    table.Add("CmId", this.hidCmid.Value);
            //    ContractMasterDM conMast = _contract.GetContractMasterByCmID(table);
            //    Session["conMast"] = conMast;
            //    Session["PageOperationType"] = PageOperationType.EDIT.ToString();
            //    if (conMast.CmStatus.Equals(ContractMastreStatus.Submit.ToString()))
            //    {
            //        this.btnSubmit.Hidden = true;
            //        if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation)
            //            && (this.hidParmetType.Value.ToString().Equals(ContractType.Appointment.ToString())
            //            || this.hidParmetType.Value.ToString().Equals(ContractType.Renewal.ToString())))
            //        {
            //            if (this.hidContStatus.Value.ToString().Equals(ContractStatus.COApproved.ToString()))
            //            {
            //                this.btnIAFReturn.Hidden = false;
            //            }
            //            else
            //            {
            //                this.btnIAFReturn.Hidden = true; ;
            //            }
            //        }
            //    }
            //    this.hidCmStatus.Value = conMast.CmStatus;
                
            //    #endregion
            //}
        }

        private void PageControl()
        {
            //if (this.hidContStatus.Value.ToString().Equals(ContractStatus.Completed.ToString()))
            //{
            //    this.tabThirdParty.Hidden = false;
            //}
            //else {
            //    this.tabThirdParty.Hidden = true;
            //}
            //if (!this.hidContractType.Value.ToString().Equals("1"))
            //{
                #region 非设备经销商
                if (this.hidDealerType.Value.ToString().Equals(DealerType.T1.ToString()) || this.hidDealerType.Value.ToString().Equals(DealerType.LP.ToString()) || this.hidDealerType.Value.ToString().Equals(DealerType.LS.ToString()))
                {
                    #region T1 LP 合同查看
                    if (RoleModelContext.Current.User.CorpType != null && new Guid(RoleModelContext.Current.User.CorpId.Value.ToString()) == new Guid(this.hidDealerId.Value.ToString()))
                    {
                        //经销商自己查看
                        if (this.hidParmetType.Value.ToString().Equals(ContractType.Appointment.ToString()))
                        {
                            if (this.hidContStatus.Value.ToString().Equals(ContractStatus.COApproved.ToString()) ||
                                this.hidContStatus.Value.ToString().Equals(ContractStatus.COSubmitPDF.ToString()) ||
                                this.hidContStatus.Value.ToString().Equals(ContractStatus.Completed.ToString()))
                            {
                                this.tabForm3.Hidden = false;
                                //this.tabForm4.Hidden = false;
                                this.tabForm5.Hidden = false;
                                this.tabForm6.Hidden = false;
                                this.tabContract.Hidden = false;
                            }
                        }
                        else if (this.hidParmetType.Value.ToString().Equals(ContractType.Amendment.ToString()))
                        {
                            if (this.hidContStatus.Value.ToString().Equals(ContractStatus.COApproved.ToString()) ||
                                this.hidContStatus.Value.ToString().Equals(ContractStatus.COSubmitPDF.ToString()) ||
                                this.hidContStatus.Value.ToString().Equals(ContractStatus.Completed.ToString()))
                            {
                                this.tabContract.Hidden = false;
                            }
                            this.btnSubmit.Hidden = true;
                            this.tabIAFOperation.Hidden = true;
                        }
                        else if (this.hidParmetType.Value.ToString().Equals(ContractType.Renewal.ToString()))
                        {
                            if (this.hidContStatus.Value.ToString().Equals(ContractStatus.COApproved.ToString()) ||
                                this.hidContStatus.Value.ToString().Equals(ContractStatus.COSubmitPDF.ToString()) ||
                                this.hidContStatus.Value.ToString().Equals(ContractStatus.Completed.ToString()))
                            {
                                this.tabForm3.Hidden = false;
                                //this.tabForm4.Hidden = false;
                                this.tabForm5.Hidden = false;
                                this.tabForm6.Hidden = false;
                                this.tabContract.Hidden = false;
                            }
                        }
                        else if (this.hidParmetType.Value.ToString().Equals(ContractType.Termination.ToString()))
                        {
                            if (this.hidContStatus.Value.ToString().Equals(ContractStatus.COApproved.ToString()) ||
                                this.hidContStatus.Value.ToString().Equals(ContractStatus.COSubmitPDF.ToString()) ||
                                this.hidContStatus.Value.ToString().Equals(ContractStatus.Completed.ToString()))
                            {
                                this.tabForm7.Hidden = false;
                                this.tabContract.Hidden = false;
                            }
                            this.btnSubmit.Hidden = true;
                            this.tabIAFOperation.Hidden = true;
                        }
                    }
                    else if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation) || RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ContractQuery))
                    {
                        if (this.hidParmetType.Value.ToString().Equals(ContractType.Appointment.ToString()))
                        {
                            this.tabForm1.Hidden = false;
                            this.tabForm2.Hidden = false;
                            this.tabForm3.Hidden = false;
                            //this.tabForm4.Hidden = false;
                            this.tabForm5.Hidden = false;
                            this.tabForm6.Hidden = false;
                            this.tabContract.Hidden = false;
                            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                            {
                                this.btnAuthorization.Hidden = false;
                            }
                        }
                        else if (this.hidParmetType.Value.ToString().Equals(ContractType.Amendment.ToString()))
                        {
                            this.tabContract.Hidden = false;
                            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                            {
                                this.btnAuthorization.Hidden = false;
                            }
                            this.btnSubmit.Hidden = true;
                            this.tabIAFOperation.Hidden = true;
                        }
                        else if (this.hidParmetType.Value.ToString().Equals(ContractType.Renewal.ToString()))
                        {
                            this.tabForm1.Hidden = false;
                            this.tabForm2.Hidden = false;
                            this.tabForm3.Hidden = false;
                            //this.tabForm4.Hidden = false;
                            this.tabForm5.Hidden = false;
                            this.tabForm6.Hidden = false;
                            this.tabContract.Hidden = false;
                            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                            {
                                this.btnAuthorization.Hidden = false;
                            }
                        }
                        else if (this.hidParmetType.Value.ToString().Equals(ContractType.Termination.ToString()))
                        {
                            this.tabForm7.Hidden = false;
                            this.tabContract.Hidden = false;

                            this.btnAuthorization.Hidden = true;
                            this.btnSubmit.Hidden = true;
                            this.tabIAFOperation.Hidden = true;
                        }
                    }
                    #endregion
                }
                else if (this.hidDealerType.Value.ToString().Equals(DealerType.T2.ToString()))
                {
                    #region 二级经销商
                    this.tabIAFOperation.Hidden = true;
                    this.btnSubmit.Hidden = true;

                    this.tabContract.Hidden = false;

                    if (this.hidParmetType.Value.ToString().Equals(ContractType.Appointment.ToString()) && RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                    {
                        if (this.hidContStatus.Value.ToString().Equals(ContractStatus.Completed.ToString()))
                        {
                            this.btnConfirm.Hidden = false;
                            if (this.hidConfirm.Value.ToString().Equals("1"))
                            {
                                this.btnConfirm.Enabled = false;
                            }
                        }
                    }
                    if ((this.hidParmetType.Value.ToString().Equals(ContractType.Appointment.ToString())
                        || this.hidParmetType.Value.ToString().Equals(ContractType.Amendment.ToString())
                        || this.hidParmetType.Value.ToString().Equals(ContractType.Renewal.ToString()))
                        && RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                    {
                        this.btnAuthorization.Hidden = false;
                    }

                    if (this.hidParmetType.Value.ToString().Equals(ContractType.Termination.ToString()) && RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                    {
                        this.btnLPConfirm.Hidden = false;
                        if (!this.hidContStatus.Value.ToString().Equals(ContractStatus.WaitLPConfirm.ToString()))
                        {
                            this.btnLPConfirm.Enabled = false;
                        }
                    }

                    #endregion
                }
                #endregion
            //}
            //else
            //{
            //    #region 设备经销商
            //    if ( this.hidContStatus.Value.ToString().Equals(ContractStatus.COApproved.ToString()) ||
            //       this.hidContStatus.Value.ToString().Equals(ContractStatus.COSubmitPDF.ToString()) ||
            //       this.hidContStatus.Value.ToString().Equals(ContractStatus.Completed.ToString()))
            //    {
            //        this.tabForm3_Equipment.Hidden = false;
            //        //this.tabForm4.Hidden = false;
            //        this.tabForm5.Hidden = false;
            //        this.tabForm6.Hidden = false;
            //        this.tabContract.Hidden = false;
            //        if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation) || RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ContractQuery))
            //        {
            //            this.tabForm1.Hidden = false;
            //            this.tabForm2.Hidden = false;
            //            if (this.hidContStatus.Value.ToString().Equals(ContractStatus.Completed.ToString()))
            //            {
            //                if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
            //                {
            //                    this.btnAuthorization.Hidden = false;
            //                }
            //                if (RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString())) 
            //                {
            //                    this.btnAuthorization.Hidden = false;
            //                }

            //            }
            //        }
            //    }
            //    #endregion
            //}

            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ContractQuery.ToString()))
            {
                btnLPConfirm.Hidden = true;
                btnConfirm.Hidden = true;
                btnSubmit.Hidden = true;
                btnIAFReturn.Hidden = true;
                this.btnAuthorization.Hidden = true;
            }
        }

        private string BindContractMasteId()
        {
            return _contract.BindContractMasterId(new Guid(this.hidDealerId.Value.ToString()), this.hidContractId.Value.ToString(), this.hidParmetType.Value.ToString());
        }
        #endregion
        

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
    }
}
