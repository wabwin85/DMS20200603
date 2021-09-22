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
using System.Text.RegularExpressions;
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
    using DMS.Business.Contract;

    public partial class ContractForm5 : BasePage
    {
        #region Definition
        IRoleModelContext _context = RoleModelContext.Current;
        private IContractMaster _contract = new DMS.Business.ContractMaster();
        private ContractMasterDM conMast = null;
        private IContractMasterBLL masterBll = new ContractMasterBLL();
        private IContractAppointmentService _appointment = new ContractAppointmentService();
        private IContractRenewalService _Renewal = new DMS.Business.ContractRenewalService();
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
                    this.spanDetail.InnerHtml = GetLocalResourceObject("From5.Information3").ToString();
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
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        [AjaxMethod]
        public void SaveSubmit()
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
                    SaveDate(ContractMastreStatus.Submit.ToString());
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
                ContractMasterDM contract = new ContractMasterDM();
                contract.CmId = new Guid(this.hdCmId.Value.ToString());
                contract.CmForm5UserName = this.tfAntiCorruptionName.Text;
                contract.CmForm5DealerName = this.tfAntiCorruptionDealer.Text;
                contract.CmStatus = cmStatus;
                contract.CmDmaId = new Guid(this.hdDealerId.Value.ToString());//new Guid(RoleModelContext.Current.User.CorpId.Value.ToString());

                DealeriafSign sign = new DealeriafSign();
                sign.CmId = new Guid(this.hdCmId.Value.ToString());
                sign.From5ThirdParty = this.lbThirdParty.Text;
                sign.From5Name = this.tfName.Text;
                sign.From5Title = this.tfTital.Text;
                sign.From5Date = this.dfSingeDate.SelectedDate;

                if (Session["PageOperationType"] != null && (string)Session["PageOperationType"] == PageOperationType.EDIT.ToString())
                {
                    _contract.UpdateContractFrom5(contract);
                    
                    DealeriafSign dtSign = masterBll.GetDealerIAFSign(sign.CmId);
                    if (dtSign == null)
                    {
                        masterBll.SaveDealerIAFSign(sign);
                    }
                    else
                    {
                        masterBll.UpdateDealerIAFSignFrom5(sign);
                    }

                    Hashtable htCon = new Hashtable();
                    htCon.Add("CapId", this.hdContId.Value);
                    htCon.Add("CapCmId", this.hdCmId.Value);
                    _appointment.UpdateAppointmentCmidByConid(htCon);

                    htCon.Add("CreId", this.hdContId.Value);
                    htCon.Add("CreCmId", this.hdCmId.Value);
                    _Renewal.UpdateRenewalCmidByConid(htCon);


                    if (cmStatus.Equals(ContractMastreStatus.Draft.ToString()))
                    {
                        Ext.Msg.Alert("Success", "保存草稿成功").Show();
                    }
                    else 
                    {
                        Ext.Msg.Alert("Success", "保存成功").Show();
                    }
                    Session["From5"] = true;
                }
                else if (Session["PageOperationType"] != null && (string)Session["PageOperationType"] == PageOperationType.INSERT.ToString())
                {
                    Ext.Msg.Alert("Error", "请先维护好From3中“公司名称”").Show();
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
            DealerMaster getDealerMaster = listDm[0];

            if (conMast != null)
            {
                this.tfAntiCorruptionName.Text = conMast.CmForm5UserName;
                DealeriafSign sign = masterBll.GetDealerIAFSign(conMast.CmId);
                if (sign != null) 
                {
                    tfName.Value = sign.From5Name;
                    tfTital.Value = sign.From5Title;
                    if (sign.From5Date != null)
                    {
                        dfSingeDate.SelectedDate = sign.From5Date.Value;
                    }
                }
            }
            if (listDm.Count > 0)
            {
                this.tfAntiCorruptionDealer.Text = getDealerMaster.EnglishName;
                this.lbThirdParty.Text = getDealerMaster.EnglishName;
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
                    && !this.hdContStatus.Value.Equals(ContractStatus.Reject.ToString()))
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

        private bool PageCheck(ref string massage)
        {
            //Regex regEnglish = new Regex("^[a-zA-Z]+$");
            Regex regEnglish = new Regex("[\u4e00-\u9fa5]");
            if (this.tfAntiCorruptionName.Text.Equals("")) 
            {
                massage += "请填写担保人姓名<br/>";
            }
            else if (regEnglish.IsMatch(this.tfAntiCorruptionName.Text))
            {
                massage += "请在姓名栏输入汉语拼音<br/>";
            }
            if (tfName.Text.Equals("")) 
            {
                massage += "请填写签名人名称<br/>";
            }
            if (tfTital.Text.Equals(""))
            {
                massage += "请填写签名人头衔<br/>";
            }
            if (tfName.Text.Equals(""))
            {
                massage += "请填写签名时间<br/>";
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

        #region Create IAF_Form_5 File

        protected void CreatePdf(object sender, EventArgs e)
        {
            string fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
            string targetPath = Server.MapPath(PdfHelper.FILE_PATH + fileName);

            Document doc = new Document(iTextSharp.text.PageSize.A4, 60, 60, 12, 12);
            try
            {
                //注册中文字库
                //PdfHelper.RegisterChineseFont();

                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
                //设置脚注，页码
                PdfPageEvent pdfPage = new PdfPageEvent("044904 Form 5 Anti-Corruption Certification Rev. F");
                writer.PageEvent = pdfPage;

                doc.Open();

                #region Pdf Title

                //设置Title Tabel 
                PdfPTable titleTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(titleTable);

                //Pdf标题
                PdfPCell titleCell = new PdfPCell(new Paragraph("Form 5\r\nANTI-CORRUPTION CERTIFICATION", PdfHelper.boldFont));
                titleCell.HorizontalAlignment = Rectangle.ALIGN_CENTER;
                titleCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                titleCell.PaddingBottom = 9f;
                titleCell.FixedHeight = 60f;
                titleCell.Border = 0;
                titleTable.AddCell(titleCell);

                //添加至pdf中
                PdfHelper.AddPdfTable(doc, titleTable);

                #endregion

                #region Content
                Hashtable table = new Hashtable();
                table.Add("CmId", this.hdCmId.Value);
                conMast = _contract.GetContractMasterByCmID(table);

                string DealerEnName="";
                if (conMast.CmDealerEnName != null) DealerEnName = conMast.CmDealerEnName;

                Paragraph EmptyParagragh = new Paragraph(" ", FontFactory.GetFont("Georgia", 7f));

                string content = @"(the “Third Party”) do hereby certify for and on behalf of the Third Party, that neither I, "
                                + "nor any other person associated with the Third Party, including but not limited to every officer, "
                                + "director, stockholder, employee, representative and agent of Third Party, has made, offered to make, "
                                + "or agreed to make any loan, gift, donation or payment, or transfer of any other thing of value directly "
                                + "or indirectly, whether in cash or in kind, to or for the benefit of any “Government Official,” or "
                                + "political party to obtain or retain business or to secure any improper advantage for Boston Scientific "
                                + "Corporation or any of its affiliated or subsidiary companies.  “Government Official” is defined as:";
                //content = content.Replace(Environment.NewLine, String.Empty).Replace("  ", String.Empty);
                Font georgia = FontFactory.GetFont("Georgia", 11f);
                Chunk chunk1 = new Chunk("I ", georgia);
                Chunk chunk2 = new Chunk("                    " + this.tfAntiCorruptionName.Text + "                    ", georgia).SetUnderline(1f, -2f);
                Chunk chunk3 = new Chunk(" [name] a duly authorized representative of ", georgia);
                Chunk chunk4 = new Chunk("   " + DealerEnName + "   ", georgia).SetUnderline(1f, -2f);
                Chunk chunk5 = new Chunk(content, georgia);
                Phrase phrase1 = new Phrase();
                phrase1.Add(chunk1);
                phrase1.Add(chunk2);
                phrase1.Add(chunk3);
                phrase1.Add(chunk4);
                phrase1.Add(chunk5);
                Paragraph paragraph1 = new Paragraph();
                paragraph1.FirstLineIndent = 34f;
                paragraph1.KeepTogether = true;
                paragraph1.Alignment = Element.ALIGN_JUSTIFIED;

                paragraph1.Add(phrase1);
                doc.Add(paragraph1);

                content = @"1.  any employee or officer of a government, including any federal, regional or local "
                           + "department, agency, or enterprise owned or controlled by the foreign government, ";
                Chunk chunk1_1 = new Chunk(content, georgia);
                Phrase phrase1_1 = new Phrase();
                phrase1_1.Add(chunk1_1);
                Paragraph paragraph1_1 = new Paragraph();
                paragraph1_1.IndentationLeft = 32f;
                paragraph1_1.KeepTogether = true;
                paragraph1_1.Alignment = Element.ALIGN_JUSTIFIED;

                paragraph1_1.Add(phrase1_1);
                doc.Add(EmptyParagragh);
                doc.Add(paragraph1_1);

                content = "2.  any official of a political party,";
                Chunk chunk1_2 = new Chunk(content, georgia);
                Phrase phrase1_2 = new Phrase();
                phrase1_2.Add(chunk1_2);
                Paragraph paragraph1_2 = new Paragraph();
                paragraph1_2.IndentationLeft = 32f;
                paragraph1_2.KeepTogether = true;
                paragraph1_2.Alignment = Element.ALIGN_JUSTIFIED;

                paragraph1_2.Add(phrase1_2);
                doc.Add(EmptyParagragh);
                doc.Add(paragraph1_2);


                content = "3.  any employees or officials of public international organization(s),";
                Chunk chunk1_3 = new Chunk(content, georgia);
                Phrase phrase1_3 = new Phrase();
                phrase1_3.Add(chunk1_3);
                Paragraph paragraph1_3 = new Paragraph();
                paragraph1_3.IndentationLeft = 32f;
                paragraph1_3.KeepTogether = true;
                paragraph1_3.Alignment = Element.ALIGN_JUSTIFIED;

                paragraph1_3.Add(phrase1_3);
                doc.Add(EmptyParagragh);
                doc.Add(paragraph1_3);


                content = "4.  any person acting in an official capacity for, or on behalf of, such entities, and";
                Chunk chunk1_4 = new Chunk(content, georgia);
                Phrase phrase1_4 = new Phrase();
                phrase1_4.Add(chunk1_4);
                Paragraph paragraph1_4 = new Paragraph();
                paragraph1_4.IndentationLeft = 32f;
                paragraph1_4.KeepTogether = true;
                paragraph1_4.Alignment = Element.ALIGN_JUSTIFIED;

                paragraph1_4.Add(phrase1_4);
                doc.Add(EmptyParagragh);
                doc.Add(paragraph1_4);

                content = "5.  any candidate for political office.";
                Chunk chunk1_5 = new Chunk(content, georgia);
                Phrase phrase1_5 = new Phrase();
                phrase1_5.Add(chunk1_5);
                Paragraph paragraph1_5 = new Paragraph();
                paragraph1_5.IndentationLeft = 32f;
                paragraph1_5.KeepTogether = true;
                paragraph1_5.Alignment = Element.ALIGN_JUSTIFIED;

                paragraph1_5.Add(phrase1_5);
                doc.Add(EmptyParagragh);
                doc.Add(paragraph1_5);

                content = @"I further certify that neither I, nor any other person associated with the Third "
                        + "Party, including but not limited to every officer, director, stockholder, employee, "
                        + "representative and agent of Third Party, will make, offer to make, or agree to make any "
                        + "loan, gift, donation or payment, or transfer of any other thing of value directly or "
                        + "indirectly, whether in cash or in kind, to or for the benefit of any “Government Official,” "
                        + "or political party to obtain or retain business or to secure any improper advantage for "
                        + "Boston Scientific Corporation or any of its affiliated or subsidiary companies.";
                Chunk chunk6 = new Chunk(content, georgia);
                Phrase phrase2 = new Phrase();
                phrase2.Add(chunk6);
                Paragraph paragraph2 = new Paragraph();
                paragraph2.FirstLineIndent = 34f;
                paragraph2.KeepTogether = true;
                paragraph2.Alignment = Element.ALIGN_JUSTIFIED;

                paragraph2.Add(phrase2);
                doc.Add(EmptyParagragh);
                doc.Add(paragraph2);

                content = @"I hereby confirm that should I learn of any of the prohibited activities described "
                        + "above, or if there are any changes in the ownership or control of the Third Party, I will "
                        + "immediately advise Boston Scientific.";
                Chunk chunk7 = new Chunk(content, georgia);
                Phrase phrase3 = new Phrase();
                phrase3.Add(chunk7);
                Paragraph paragraph3 = new Paragraph();
                paragraph3.FirstLineIndent = 34f;
                paragraph3.KeepTogether = true;
                paragraph3.Alignment = Element.ALIGN_JUSTIFIED;

                paragraph3.Add(phrase3);
                doc.Add(EmptyParagragh);
                doc.Add(paragraph3);

                content = @"I hereby confirm that neither I, nor any officer, director, stockholder, employee, "
                        + "representative or agent of the Third Party, is a Government Official within any country "
                        + "for which the Third Party is being granted rights to promote, sell or deliver Boston "
                        + "Scientific products. ";
                Chunk chunk8 = new Chunk(content, georgia);
                Phrase phrase4 = new Phrase();
                phrase4.Add(chunk8);
                Paragraph paragraph4 = new Paragraph();
                paragraph4.FirstLineIndent = 34f;
                paragraph4.KeepTogether = true;
                paragraph4.Alignment = Element.ALIGN_JUSTIFIED;

                paragraph4.Add(phrase4);
                doc.Add(EmptyParagragh);
                doc.Add(paragraph4);

                content = @"I hereby confirm that I or my appropriately-trained designee will deliver "
                        + "Transacting Business with Integrity training to all customer- and government-facing "
                        + "employees who were not present for the initial Transacting Business with Integrity "
                        + "training that is required by Boston Scientific or who is hired after the initial training and "
                        + "during the term of our Agreement with Boston Scientific, such training to occur before "
                        + "such employees begin promoting or selling Boston Scientific products.  Signed "
                        + "attendance sheets containing the names of all parties who receive such training will be "
                        + "returned to Boston Scientific as soon as reasonably possible after the training takes place. ";
                Chunk chunk9 = new Chunk(content, georgia);
                Phrase phrase5 = new Phrase();
                phrase5.Add(chunk9);
                Paragraph paragraph5 = new Paragraph();
                paragraph5.FirstLineIndent = 34f;
                paragraph5.KeepTogether = true;
                paragraph5.Alignment = Element.ALIGN_JUSTIFIED;

                paragraph5.Add(phrase5);
                doc.Add(EmptyParagragh);
                doc.Add(paragraph5);
                #endregion

                #region Signature
                doc.NewPage();

                PdfPTable signatureTable = new PdfPTable(3);
                signatureTable.SetWidths(new float[] { 20f, 50f, 30f });
                PdfHelper.InitPdfTableProperty(signatureTable);

                DealeriafSign sign = masterBll.GetDealerIAFSign(new Guid(this.hdCmId.Value.ToString()));
                if (sign != null)
                {
                    PdfHelper.AddEmptyPdfCell(signatureTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", georgia)) { FixedHeight = 60f }, signatureTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell(new PdfPCell() { Rowspan = 9 }, signatureTable, null, null);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph(" ")) { Colspan = 2 }, signatureTable, null, null);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Third Party:", georgia)) { FixedHeight = 30 }, signatureTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(sign.From5ThirdParty, georgia, signatureTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("By:", georgia)) { FixedHeight = 30 }, signatureTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine("", georgia, signatureTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(signatureTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(Signature)", georgia)), signatureTable, null, null);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Name:", georgia)) { FixedHeight = 30 }, signatureTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(sign.From5Name, georgia, signatureTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Title:", georgia)) { FixedHeight = 30 }, signatureTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(sign.From5Title, georgia, signatureTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", georgia)) { FixedHeight = 30 }, signatureTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(sign.From5Date.Value.ToShortDateString(), georgia, signatureTable, null, Rectangle.ALIGN_BOTTOM);
                }
                //添加至pdf中
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

            DownloadFileForDCMS(fileName, "IAF_Form_5.pdf", "DCMS");
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
