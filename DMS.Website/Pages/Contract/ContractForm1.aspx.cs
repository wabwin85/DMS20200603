using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Model;
using DMS.Business.Contract;

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
    using DMS.Common;
    using System.Data;

    public partial class ContractForm1 : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IAttachmentBLL _attachmentBLL = null;
        [Dependency]
        public IAttachmentBLL attachmentBLL
        {
            get { return _attachmentBLL; }
            set { _attachmentBLL = value; }
        }
        private IContractAppointmentService _appointment = new ContractAppointmentService();
        private IContractRenewalService _renewal = new ContractRenewalService();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (Request.QueryString["ContId"] != null && Request.QueryString["ParmetType"] != null)
                {
                    this.hdContractID.Value = Request.QueryString["ContId"];
                    this.hdParmetType.Value = Request.QueryString["ParmetType"];
                    BindPageData();
                 
                }
                if (!RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation)) 
                {
                    btnCreatePdf.Enabled = false;
                }
            }
        }

        private void BindPageData()
        {
            if (this.hdParmetType.Value != null) 
            {
                Guid DealerID = Guid.Empty;
                if (this.hdParmetType.Value.Equals("Appointment")) 
                {
                    ContractAppointment ConApm = _appointment.GetContractAppointmentByID(new Guid(this.hdContractID.Value.ToString()));
                    if (ConApm.CapDivision != null)
                    {
                        DealerID = ConApm.CapDmaId;
                        this.hidDivision.Value = ConApm.CapDivision;
                    }
                    if (ConApm.CapDrmPrintName != null) 
                    {
                        this.hdDrmPrintName.Value = ConApm.CapDrmPrintName;
                        this.hdDrmPrintDate.Value = ConApm.CapDrmDate;
                    }
                }
                if (this.hdParmetType.Value.Equals("Renewal")) 
                {
                    ContractRenewal conRen = _renewal.GetContractRenewalByID(new Guid(this.hdContractID.Value.ToString()));
                    if (conRen != null) 
                    {
                        DealerID = conRen.CreDmaId;
                        this.hidDivision.Value = conRen.CreDivision;
                    }
                    this.radioConfirm6Yes.Checked = true;
                    this.radioConfirm7Yes.Checked = true;
                    if (conRen.CreDrmPrintName != null) 
                    {
                        this.hdDrmPrintName.Value = conRen.CreDrmPrintName;
                        this.hdDrmPrintDate.Value = conRen.CreDrmDate;
                    }
                }
                if (DealerID != Guid.Empty) 
                {
                    IDealerMasters bll = new DealerMasters();
                    DealerMaster dm = new DealerMaster();
                    dm.Id = DealerID;
                    IList<DealerMaster> listDm = bll.QueryForDealerMaster(dm);
                    if (listDm.Count > 0)
                    {
                        DealerMaster getDealerMaster = listDm[0];
                        this.tfFrom1DealerName.Text = String.IsNullOrEmpty(getDealerMaster.EnglishName) ? getDealerMaster.ChineseName : getDealerMaster.EnglishName;
                    }
                }
            }
           
        }

        #region Create IAF_Form_1 File

        protected void CreatePdf(object sender, EventArgs e)
        {
            PerformedUser Performed = GetPerformed();
            string fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
            string targetPath = Server.MapPath(PdfHelper.FILE_PATH + fileName);

            Document doc = new Document(iTextSharp.text.PageSize.A4, 36, 36, 12, 12);
            try
            {
                //注册中文字库
                PdfHelper.RegisterChineseFont();
                PdfHelper pdfFont= new PdfHelper();
                
                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
                //设置脚注，页码
                PdfPageEvent pdfPage = new PdfPageEvent(""
                                            , "044898 Form 1 – Third Party Appointment Renewal Checklist, Rev D"
                                            , true);
                writer.PageEvent = pdfPage;
                doc.Open();

                #region 
                //ContractAppointment ConNew = _appointment.GetContractAppointmentByID(new Guid(this.hdContractID.Value.ToString()));
                #endregion

                #region Public Element
                PdfPCell noSelectCell = PdfHelper.GetNoSelectImageCell();
                PdfPCell SelectCell = PdfHelper.GetYesSelectImageCell();
                #endregion

                #region Pdf Title

                //设置Title Tabel 
                PdfPTable titleTable = new PdfPTable(2);
                titleTable.SetWidths(new float[] { 25f, 75f });
                PdfHelper.InitPdfTableProperty(titleTable);

                titleTable.AddCell(PdfHelper.GetIAFBscLogoImageCell());

                //Pdf标题
                PdfPCell titleCell = new PdfPCell(new Paragraph("Form 1\r\nThird Party Appointment / Renewal Checklist", PdfHelper.iafTitleGrayFont));
                titleCell.HorizontalAlignment = Rectangle.ALIGN_CENTER;
                titleCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                titleCell.PaddingBottom = 9f;
                titleCell.FixedHeight = 65.5f;
                titleCell.Border = 0;
                titleTable.AddCell(titleCell);

                //添加至pdf中
                PdfHelper.AddPdfTable(doc, titleTable);

                #endregion

                #region 副标题
                PdfPTable thirdpartyTable = new PdfPTable(4);
                thirdpartyTable.SetWidths(new float[] { 4f, 26f, 60f, 10f });
                PdfHelper.InitPdfTableProperty(thirdpartyTable);

                PdfHelper.AddEmptyPdfCell(thirdpartyTable);
                PdfHelper.AddPdfCell("Country:", PdfHelper.normalFont, thirdpartyTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine("China", PdfHelper.iafAnswerFont, thirdpartyTable, null);
                PdfHelper.AddEmptyPdfCell(thirdpartyTable);

                PdfHelper.AddEmptyPdfCell(thirdpartyTable);
                PdfHelper.AddPdfCell("Proposed Third Party:", PdfHelper.normalFont, thirdpartyTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(this.tfFrom1DealerName.Text, pdfFont.normalChineseFont, thirdpartyTable, null);
                PdfHelper.AddEmptyPdfCell(thirdpartyTable);

                PdfHelper.AddPdfTable(doc, thirdpartyTable);

                #endregion

                #region Body

                PdfPTable bodyTable = new PdfPTable(4);
                bodyTable.SetWidths(new float[] { 5f, 65f, 15f, 15f });
                PdfHelper.InitPdfTableProperty(bodyTable);

                bodyTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 4 });

                //PERFORMED
                PdfHelper.AddEmptyPdfCell(bodyTable);
                PdfHelper.AddEmptyPdfCell(bodyTable);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("PERFORMED\r\n(YES / NO)", PdfHelper.normalFont)) { FixedHeight = 30f, BorderColor = PdfHelper.blueColor, BorderColorRight = BaseColor.BLACK, BorderWidthLeft = 1f, BorderWidthTop = 1f, BorderWidthRight = 0f, BorderWidthBottom = 0f }
                    , bodyTable, null, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(" \r\nPERFORMED BY\r\n ", PdfHelper.normalFont)) { BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthTop = 1f, BorderWidthRight = 1f, BorderWidthLeft = 0.6f, BorderWidthBottom = 0f }
                    , bodyTable, null, null);

                PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("1.", PdfHelper.smallFont)), bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("The Relationship Manager (RM) confirms completion of the Third Party Appointment/Renewal Checklist (Form 1), the Internal Approval Form (Form 2), the Third Party Disclosure Form (Form 3), the Quality Self-Assessment Checklist (Form 4), the delivery of a copy of the Conduct to the Third Party and any sub-contractors, the Anti-Corruption  Certification (Form 5), the Transacting Business with Integrity Attendance Sheet (Form 6) and Forms 1-6 sent to Corporate Third Party Management.", PdfHelper.normalFont)) { BorderWidth = 0f, BorderWidthTop = 1f, BorderWidthBottom = 0.6f, BorderColorTop = PdfHelper.blueColor }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);
                PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph("YES", PdfHelper.normalFont)) { BorderColor = BaseColor.BLACK, BorderColorTop = PdfHelper.blueColor, BorderWidth = 0.3f, BorderWidthTop = 1.5f }, bodyTable, null, null, false);
                PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph(Performed.PerformedUser1, PdfHelper.normalFont)), bodyTable, null, null, false);

                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("2.", PdfHelper.smallFont)), bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("RM is satisfied that the Third Party is qualified for the services to be performed and that there are no “red flag” issues or, alternatively, all “red flag” issues have been addressed by Regional Legal/Regional Compliance.", PdfHelper.normalFont)), bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("YES", PdfHelper.normalFont)), bodyTable, null, null, false);
                PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph(Performed.PerformedUser2, PdfHelper.normalFont)), bodyTable, null, null, false);

                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("3.", PdfHelper.smallFont)), bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("RM believes that the Third Party does not have any conflicts of interests involving Boston Scientific or its employees, including representation of competitive products.  If there are any, please elaborate on a separate attachment.", PdfHelper.normalFont)), bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("YES", PdfHelper.normalFont)), bodyTable, null, null, false);
                PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph(Performed.PerformedUser3, PdfHelper.normalFont)), bodyTable, null, null, false);

                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("4.", PdfHelper.smallFont)), bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("RM confirms that Third Party was not initially identified or recommended by a representative or employee of a non-U.S. government or governmental entity, such as a state-owned or controlled hospital or clinic, or any other foreign official.", PdfHelper.normalFont)), bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("YES", PdfHelper.normalFont)), bodyTable, null, null, false);
                PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph(Performed.PerformedUser4, PdfHelper.normalFont)), bodyTable, null, null, false);

                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("5.", PdfHelper.smallFont)), bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("The RM believes that the Third Party is reputable and honest and has a strong reputation for quality and honesty in the business community, that the Third Party will comply with Boston Scientific’s requirement that all product be promoted and sold only on the basis of quality, service, price and other legitimate clinical attributes, and that the Third Party understands that the payment of inducements for any purpose is strictly prohibited.", PdfHelper.normalFont)), bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("YES", PdfHelper.normalFont)), bodyTable, null, null, false);
                PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph(Performed.PerformedUser5, PdfHelper.normalFont)), bodyTable, null, null, false);

                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("6.", PdfHelper.smallFont)), bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("If a renewal, RM has discussed with the Dealer or Distributor the Dealer or Distributor’s sponsorship activities and any other financial arrangements with health care professionals (HCPs), including gifts, donations or other financial contributions during the course of their current agreement term and the RM has reported any sponsorship activities or other financial arrangements with HCPs he/she is aware of that are not in compliance with the requirements outlined in the Transacting Business with Integrity presentation to Global Compliance or the Legal Department.", PdfHelper.normalFont)), bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(this.hdParmetType.Value.Equals("Renewal")?"YES":"", PdfHelper.normalFont)), bodyTable, null, null, false);
                PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph(this.hdParmetType.Value.Equals("Renewal")?Performed.PerformedUser6:"", PdfHelper.normalFont)), bodyTable, null, null, false);

                PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph("7.", PdfHelper.smallFont)), bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("If a renewal, RM has discussed with the Third Party the Third Party’s sales or financial arrangements with customers, sub-contractors and other third parties, including rebates, discounts and other financial arrangements that benefit the customer, sub-contractor or third party, and the RM has reported any financial arrangements he/she is aware of that are not in compliance with the requirements outlined in the Transacting Business with Integrity presentation to Global Compliance or the Legal Department.", PdfHelper.normalFont)), bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, true);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph(this.hdParmetType.Value.Equals("Renewal")?"YES":"", PdfHelper.normalFont)), bodyTable, null, null, false);
                PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph(this.hdParmetType.Value.Equals("Renewal")?Performed.PerformedUser7:"", PdfHelper.normalFont)), bodyTable, null, null, false);

                PdfHelper.AddPdfTable(doc, bodyTable);
                #endregion

                #region Approve
                PdfPTable approveTable = new PdfPTable(6);
                approveTable.SetWidths(new float[] { 10f, 10f, 35f, 3f, 27f, 15f });
                PdfHelper.InitPdfTableProperty(approveTable);
                //间距
                approveTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 6 });

                #region NOTE
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("NOTE:", PdfHelper.descFont)) { BackgroundColor = PdfHelper.remarkBgColor, Rowspan=2 }, approveTable, Rectangle.ALIGN_RIGHT, null);
                PdfHelper.AddPdfCell(new PdfPCell(new Phrase("All activities listed above should be documented and filed separately as part of the appointment file.  Files are responsibility of Third Party Management and should be available for review at any time.", PdfHelper.descFont) { Leading = 3f }) { Colspan = 4, Rowspan = 2, BackgroundColor = PdfHelper.remarkBgColor }, approveTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { BackgroundColor = PdfHelper.remarkBgColor, Rowspan = 2 }, approveTable, null, null);
                
                #endregion

                //间距
                approveTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 5f, Border = 0, Colspan = 6 });

                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("\r\n\r\nRelationship\r\nManager", PdfHelper.descFont)) { BackgroundColor = PdfHelper.grayColor, FixedHeight = 60f, Colspan = 2, Rowspan = 2, BorderColor = PdfHelper.blueColor, BorderWidth = 1f, BorderWidthRight = 0f }, approveTable, null, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(GetObjectDate(this.hdDrmPrintName.Value.ToString()), PdfHelper.iafAnswerFont)) { FixedHeight = 39f, BorderColor = PdfHelper.blueColor, BorderColorBottom = BaseColor.BLACK, BorderWidthTop = 1f, BorderWidthRight = 0f, BorderWidthLeft = 0f, BorderWidthBottom = 1f }, approveTable, null, Rectangle.ALIGN_BOTTOM);
            
                PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(), approveTable, null, null, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase(GetObjectDate(this.hdDrmPrintDate.Value.ToString()), PdfHelper.iafAnswerFont)) { BorderColor = PdfHelper.blueColor, BorderColorBottom = BaseColor.BLACK, BorderWidth = 1f, BorderWidthLeft = 0f, BorderWidthBottom = 1f, Colspan = 2 }, approveTable, null, Rectangle.ALIGN_BOTTOM);
                


                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("RM SIGNATURE", PdfHelper.normalFont)), approveTable, null, null, true);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(), approveTable, null, null, true);
                PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph("Date", PdfHelper.normalFont)) { Colspan=2}, approveTable, null, null, true);
                

                PdfHelper.AddPdfTable(doc, approveTable);

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

            DownloadFileForDCMS(fileName, "IAF_Form_1.pdf", "DCMS");
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

        private PerformedUser GetPerformed()
        {
            PerformedUser getPerformedUser = new PerformedUser();
            if (this.hidDivision.Value.Equals("Cardio")) 
            {
                getPerformedUser.PerformedUser1 = "S.Zhao";
                getPerformedUser.PerformedUser2 = "YF.Chen";
                getPerformedUser.PerformedUser3 = "S.Zhao";
                getPerformedUser.PerformedUser4 = "S.Zhao";
                getPerformedUser.PerformedUser5 = "K.Jin";
                getPerformedUser.PerformedUser6 = "S.Zhao";
                getPerformedUser.PerformedUser7 = "S.Zhao";
            }
            if (this.hidDivision.Value.Equals("CRM"))
            {
                getPerformedUser.PerformedUser1 = "P.Liu";
                getPerformedUser.PerformedUser2 = "YF.Chen";
                getPerformedUser.PerformedUser3 = "P.Liu";
                getPerformedUser.PerformedUser4 = "P.Liu";
                getPerformedUser.PerformedUser5 = "K.Jin";
                getPerformedUser.PerformedUser6 = "N/A";
                getPerformedUser.PerformedUser7 = "N/A";
            }
            if (this.hidDivision.Value.Equals("Endo"))
            {
                getPerformedUser.PerformedUser1 = "H.Gao";
                getPerformedUser.PerformedUser2 = "YF.Chen";
                getPerformedUser.PerformedUser3 = "H.Gao";
                getPerformedUser.PerformedUser4 = "H.Gao";
                getPerformedUser.PerformedUser5 = "K.Jin";
                getPerformedUser.PerformedUser6 = "H.Gao";
                getPerformedUser.PerformedUser7 = "H.Gao";
            }
            if (this.hidDivision.Value.Equals("EP"))
            {
                getPerformedUser.PerformedUser1 = "P.Liu";
                getPerformedUser.PerformedUser2 = "YF.Chen";
                getPerformedUser.PerformedUser3 = "P.Liu";
                getPerformedUser.PerformedUser4 = "P.Liu";
                getPerformedUser.PerformedUser5 = "K.Jin";
                getPerformedUser.PerformedUser6 = "P.Liu";
                getPerformedUser.PerformedUser7 = "P.Liu";
            }
            if (this.hidDivision.Value.Equals("PI"))
            {
                getPerformedUser.PerformedUser1 = "Zhang Ruibo";
                getPerformedUser.PerformedUser2 = "YF.Chen";
                getPerformedUser.PerformedUser3 = "Zhang Ruibo";
                getPerformedUser.PerformedUser4 = "Zhang Ruibo";
                getPerformedUser.PerformedUser5 = "K.Jin";
                getPerformedUser.PerformedUser6 = "Zhang Ruibo";
                getPerformedUser.PerformedUser7 = "Zhang Ruibo";
            }
            if (this.hidDivision.Value.Equals("Uro"))
            {
                getPerformedUser.PerformedUser1 = "H.Gao";
                getPerformedUser.PerformedUser2 = "YF.Chen";
                getPerformedUser.PerformedUser3 = "H.Gao";
                getPerformedUser.PerformedUser4 = "H.Gao";
                getPerformedUser.PerformedUser5 = "K.Jin";
                getPerformedUser.PerformedUser6 = "N/A";
                getPerformedUser.PerformedUser7 = "N/A";
            }
            if (this.hidDivision.Value.Equals("AS"))
            {
                getPerformedUser.PerformedUser1 = "H.Gao";
                getPerformedUser.PerformedUser2 = "YF.Chen";
                getPerformedUser.PerformedUser3 = "H.Gao";
                getPerformedUser.PerformedUser4 = "H.Gao";
                getPerformedUser.PerformedUser5 = "K.Jin";
                getPerformedUser.PerformedUser6 = "N/A";
                getPerformedUser.PerformedUser7 = "N/A";
            }
            if (this.hidDivision.Value.Equals("SH"))
            {
                getPerformedUser.PerformedUser1 = "S.Zhao";
                getPerformedUser.PerformedUser2 = "YF.Chen";
                getPerformedUser.PerformedUser3 = "S.Zhao";
                getPerformedUser.PerformedUser4 = "S.Zhao";
                getPerformedUser.PerformedUser5 = "K.Jin";
                getPerformedUser.PerformedUser6 = "N/A";
                getPerformedUser.PerformedUser7 = "N/A";
            }
            return getPerformedUser;
        }

        #endregion
    }
}
