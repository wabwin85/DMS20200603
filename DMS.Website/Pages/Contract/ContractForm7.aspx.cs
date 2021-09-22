using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business;
using DMS.Model;

namespace DMS.Website.Pages.Contract
{
    using iTextSharp.text.pdf;
    using iTextSharp.text;
    using System.IO;
    using System.Reflection;
    using Lafite.RoleModel.Security;
    using Microsoft.Practices.Unity;
    using DMS.Model.Data;
    using DMS.Common;
    using System.Collections;

    public partial class ContractForm7 : BasePage
    {
        private IContractTerminationService _termination = new ContractTerminationService();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (Request.QueryString["DealerId"] != null && Request.QueryString["ContId"] !=null)
                {
                    this.hdDealerId.Value = Request.QueryString["DealerId"];
                    this.hdContId.Value = Request.QueryString["ContId"];
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
            Hashtable obj = new Hashtable();
            obj.Add("Id", this.hdContId.Value);
            TerminationForm from = _termination.GetTerminationFormByObj(obj);
            if (from != null)
            {
                if (from.TfHeadParm1 != null)
                {
                    if (Convert.ToBoolean(from.TfHeadParm1))
                    {
                        radioHeadParm1Yes.Checked = true;
                    }
                    else
                    {
                        radioHeadParm1No.Checked = true;
                    }
                }
                if (from.TfHeadParm2 != null)
                {
                    if (Convert.ToBoolean(from.TfHeadParm2))
                    {
                        radioHeadParm2Yes.Checked = true;
                    }
                    else
                    {
                        radioHeadParm2No.Checked = true;
                    }
                }
                if (from.TfHeadParm3 != null)
                {
                    if (Convert.ToBoolean(from.TfHeadParm3))
                    {
                        radioHeadParm3Yes.Checked = true;
                    }
                    else
                    {
                        radioHeadParm3No.Checked = true;
                    }
                }
                if (from.TfHeadParm4 != null)
                {
                    if (Convert.ToBoolean(from.TfHeadParm4))
                    {
                        radioHeadParm4Yes.Checked = true;
                    }
                    else
                    {
                        radioHeadParm4No.Checked = true;
                    }
                }
                if (from.TfHeadParm5 != null)
                {
                    if (Convert.ToBoolean(from.TfHeadParm5))
                    {
                        radioHeadParm5Yes.Checked = true;
                    }
                    else
                    {
                        radioHeadParm5No.Checked = true;
                    }
                }
                this.tfFrom7DealerName.Text = from.TfCompanyName;
                this.tfFrom7Country.Text = from.TfCountry;
                if (from.TfIsExclusive != null)
                {
                    if (from.TfIsExclusive.ToString().Equals("Exclusive"))
                    {
                        radioExclusiveYes.Checked = true;
                    }
                    else
                    {
                        radioExclusiveNo.Checked = true;
                    }
                }
                if (from.TfExpirationDate != null)
                {
                    this.tfContractDate.Text = Convert.ToDateTime(from.TfExpirationDate).ToShortDateString();
                }
                if (from.TfTerminationEffectiveDate != null)
                {
                    this.tfTerminationDate.Text = Convert.ToDateTime(from.TfTerminationEffectiveDate).ToShortDateString();
                }

                //if (from.TfReasonAccRec != null) 
                //{
                //    this.cbReason1.Checked = Convert.ToBoolean(from.TfReasonAccRec);
                //}
                //if (from.TfReasonNotQuota != null)
                //{
                //    this.cbReason2.Checked = Convert.ToBoolean(from.TfReasonNotQuota);
                //}
                //if (from.TfReasonPlDis != null)
                //{
                //    this.cbReason3.Checked = Convert.ToBoolean(from.TfReasonPlDis);
                //}
                //if (from.TfReasonOther != null)
                //{
                //    this.cbReason4.Checked = Convert.ToBoolean(from.TfReasonOther);
                //}
                if (from.TfReasons != null)
                {
                    if (from.TfReasons.ToString().Equals("Accounts Receivable Issues"))
                    {
                        this.cbReason1.Checked = true;
                    }
                    else if (from.TfReasons.ToString().Equals("Not Meeting Quota"))
                    {
                        this.cbReason2.Checked = true;
                    }
                    else if (from.TfReasons.ToString().Equals("Product Line Discontinued"))
                    {
                        this.cbReason3.Checked = true;
                    }
                    else
                    {
                        this.cbReason4.Checked = true;
                    }
                }
                this.tfOtherRes.Text = from.TfReasonOtherReasons;
                this.tfOutstandingAmount.Text = from.TfOutstandingAmount == null ? "" : base.GetStringByDecimal(from.TfOutstandingAmount);
                this.tfQuotaAmount.Text = from.TfQuotaAmount == null ? "" : base.GetStringByDecimal(from.TfQuotaAmount);
                this.tfActualSales.Text = from.TfActualSales == null ? "" : base.GetStringByDecimal(from.TfActualSales);
                this.tfGoodsAmount.Text = from.TfGoodsAmount == null ? "" : base.GetStringByDecimal(from.TfGoodsAmount);
                if (from.TfHasrgaAttached != null)
                {
                    if (Convert.ToBoolean(from.TfHasrgaAttached))
                    {
                        this.radioRGAAttachedYes.Checked = true;
                    }
                    else
                    {
                        this.radioRGAAttachedNo.Checked = true;
                    }
                }
                if (from.TfIsOutstandingTenders != null)
                {
                    if (Convert.ToBoolean(from.TfIsOutstandingTenders))
                    {
                        this.radioOuttenderYes.Checked = true;
                    }
                    else
                    {
                        this.radioOuttenderNo.Checked = true;
                    }
                }
                this.tfPostTermination.Text = from.TfPostTermination;
                if (from.TfDuePayment != null)
                {
                    if (Convert.ToBoolean(from.TfDuePayment))
                    {
                        this.radioDuePaymentYes.Checked = true;
                    }
                    else
                    {
                        this.radioDuePaymentNo.Checked = true;
                    }
                }
                this.tfCreditAmount.Text = from.TfCreditAmount == null ? "" : base.GetStringByDecimal(from.TfCreditAmount);
                if (from.TfIsBankGuarantee != null)
                {
                    if (Convert.ToBoolean(from.TfIsBankGuarantee))
                    {
                        this.radioBankGuaranteeYes.Checked = true;
                    }
                    else
                    {
                        this.radioBankGuaranteeNo.Checked = true;
                    }
                }
                this.tfGuaranteeAmount.Text = from.TfGuaranteeAmount == null ? "" : base.GetStringByDecimal(from.TfGuaranteeAmount);
                if (from.TfIsReserve != null)
                {
                    if (Convert.ToBoolean(from.TfIsReserve))
                    {
                        this.radioReserveYes.Checked = true;
                    }
                    else
                    {
                        this.radioReserveNo.Checked = true;
                    }
                }
                this.tfReserveAmount.Text = from.TfReserveAmount == null ? "" : base.GetStringByDecimal(from.TfReserveAmount);
                this.tfSettlement.Text = from.TfSettlement == null ? "" : base.GetStringByDecimal(from.TfSettlement);
                this.tfWriteOff.Text = from.TfWriteOff == null ? "" : base.GetStringByDecimal(from.TfWriteOff);
                //if (from.TfReserveType != null) 
                //{
                //    if (from.TfReserveType.ToString().Equals("1")) 
                //    {
                //        this.radioReserveDebt.Checked = true;
                //    }
                //    if (from.TfReserveType.ToString().Equals("2"))
                //    {
                //        this.radioReserveSettlement.Checked = true;
                //    }
                //    if (from.TfReserveType.ToString().Equals("3"))
                //    {
                //        this.radioReserveReturn.Checked = true;
                //    }
                //    if (from.TfReserveType.ToString().Equals("4"))
                //    {
                //        this.radioReserveOther.Checked = true;
                //    }
                //}
                string strGuarantee = GetObjectDate(from.TfReserveType).ToLower().Replace(" ", "");

                if (!strGuarantee.Equals(""))
                {
                    string[] temp = strGuarantee.Split(',');
                    for (int i = 0; i < temp.Length; i++)
                    {
                        string tempValue = temp[i].ToString();
                        if (tempValue.Equals("baddebt"))
                        {
                            cbReserveDebt.Checked = true;
                        }
                        if (tempValue.Equals("settlement"))
                        {
                            cbReserveSettlement.Checked = true;
                        }
                        if (tempValue.Equals("salesreturn"))
                        {
                            cbReserveReturn.Checked = true;
                        }
                        if (tempValue.Equals("other"))
                        {
                            cbReserveOther.Checked = true;
                        }
                    }
                }
            }
        }

        #region Create IAF_Form_7 File
        protected void CreatePdf(object sender, EventArgs e)
        {
            string fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
            string targetPath = Server.MapPath(PdfHelper.FILE_PATH + fileName);
            Document doc = new Document(iTextSharp.text.PageSize.A4, 16, 16, 55, 12);
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("Id", this.hdContId.Value);
                TerminationForm terminationFrom = _termination.GetTerminationFormByObj(obj);

                //注册中文字库
                PdfHelper.RegisterChineseFont();
                PdfHelper pdfFont = new PdfHelper();

                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
                //设置脚注，页码
                PdfPageEvent pdfPage = new PdfPageEvent("Form 7\r\nThird Party Non-Renewal / Termination Form"
                                            , "044906 Form 7 – Third Party Non-Renewal Termination, Rev AE"
                                            , true);
                writer.PageEvent = pdfPage;

                doc.Open();

                #region Public Element
                PdfPCell noSelectCell = PdfHelper.GetNoSelectImageCell();
                PdfPCell SelectCell = PdfHelper.GetYesSelectImageCell();
                #endregion

                #region Head

                PdfPTable headTable = new PdfPTable(3);
                headTable.SetWidths(new float[] { 86f, 7f, 7f });
                PdfHelper.InitPdfTableProperty(headTable);

                headTable.AddCell(new PdfPCell(new Paragraph("")) { Border = 0, Colspan = 3 });

                //COMPLETED
                PdfHelper.AddPdfCell(new PdfPCell() { Rowspan = 2 }, headTable, null, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("COMPLETED", PdfHelper.normalFont)) { Colspan = 2, BackgroundColor = PdfHelper.remarkBgColor, BorderColor = PdfHelper.blueColor, BorderWidth = 1f, BorderWidthBottom = 0f }
                    , headTable, null, null);
                //YES/ON
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("YES", PdfHelper.normalFont)) { BackgroundColor = PdfHelper.remarkBgColor, BorderColor = PdfHelper.blueColor, BorderWidthTop = 1f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderWidthBottom = 0f }
                    , headTable, null, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("NO", PdfHelper.normalFont)) { BackgroundColor = PdfHelper.remarkBgColor, BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthTop = 1f, BorderWidthRight = 1f, BorderWidthLeft = 0.6f, BorderWidthBottom = 0f }
                    , headTable, null, null);

                PdfHelper.AddPdfTable(doc, headTable);

                #endregion

                #region Body

                PdfPTable bodyTable = new PdfPTable(3);
                bodyTable.SetWidths(new float[] { 86f, 7f, 7f });
                PdfHelper.InitPdfTableProperty(bodyTable);

                //1
                PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("1.	Non-Renewal/Termination Internal Approval Form (Section 9) prepared and routed for signature?", PdfHelper.youngFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT }
                        , bodyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderTop(this.AddCheckBox(terminationFrom.TfHeadParm1)
                        , bodyTable, null, null, false);
                PdfHelper.AddPdfCellHasBorderTopRight(this.AddCheckBox(!terminationFrom.TfHeadParm1)
                        , bodyTable, null, null, false);

                //2
                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("2.	Have you notified Global Compliance and your Legal Department of proposed severance of relationship?", PdfHelper.youngFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT }
                        , bodyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderCenter(this.AddCheckBox(terminationFrom.TfHeadParm2)
                        , bodyTable, null, null, false);
                PdfHelper.AddPdfCellHasBorderRight(this.AddCheckBox(!terminationFrom.TfHeadParm2)
                        , bodyTable, null, null, false);

                //3
                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("3.	Confirm if Oral or Written Notice of Non-renewal or termination has been provided to Third Party?", PdfHelper.youngFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT }
                        , bodyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderCenter(this.AddCheckBox(terminationFrom.TfHeadParm3)
                        , bodyTable, null, null, false);
                PdfHelper.AddPdfCellHasBorderRight(this.AddCheckBox(!terminationFrom.TfHeadParm3)
                        , bodyTable, null, null, false);

                //4
                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("4.	Will a Settlement Agreement be required?", PdfHelper.youngFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT }
                        , bodyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderCenter(this.AddCheckBox(terminationFrom.TfHeadParm4)
                        , bodyTable, null, null, false);
                PdfHelper.AddPdfCellHasBorderRight(this.AddCheckBox(!terminationFrom.TfHeadParm4)
                        , bodyTable, null, null, false);

                //5
                PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph("5.	Will there be any Payments to Third Party (settlement amounts )or write-off of debt booked to reserve?", PdfHelper.youngFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT }
                        , bodyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderBottom(this.AddCheckBox(terminationFrom.TfHeadParm5)
                        , bodyTable, null, null, false);
                PdfHelper.AddPdfCellHasBorderBottomRight(this.AddCheckBox(!terminationFrom.TfHeadParm5)
                        , bodyTable, null, null, false);

                PdfHelper.AddPdfTable(doc, bodyTable);

                #endregion

                #region Third Party

                PdfPTable thirdPartyTable = new PdfPTable(4);
                thirdPartyTable.SetWidths(new float[] { 20f, 60f, 5f, 15f });
                PdfHelper.InitPdfTableProperty(thirdPartyTable);

                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, thirdPartyTable, null, null);

                //Third Party Name:
                PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("Third Party Name:", PdfHelper.youngFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT, BackgroundColor = PdfHelper.remarkBgColor }
                        , thirdPartyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph(terminationFrom.TfCompanyName, PdfHelper.youngFont))
                        , thirdPartyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(this.AddCheckBox(terminationFrom.TfIsExclusive.ToString().Equals("Exclusive"))) { BorderWidth = 0f, BorderWidthTop = 1f, BorderWidthLeft = 0.6f, BorderColorTop = PdfHelper.blueColor }
                        , thirdPartyTable, null, null);
                PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph("Exclusive", PdfHelper.youngFont))
                        , thirdPartyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true);

                //Country
                PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph("Country:", PdfHelper.youngFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT, BackgroundColor = PdfHelper.remarkBgColor }
                        , thirdPartyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph(terminationFrom.TfCountry, PdfHelper.youngFont))
                        , thirdPartyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(this.AddCheckBox(!terminationFrom.TfIsExclusive.ToString().Equals("Exclusive"))) { BorderWidth = 0f, BorderWidthBottom = 1f, BorderWidthLeft = 0.6f, BorderColorBottom = PdfHelper.blueColor }
                        , thirdPartyTable, null, null);
                PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph("Non-Exclusive", PdfHelper.youngFont))
                        , thirdPartyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true);

                PdfHelper.AddPdfTable(doc, thirdPartyTable);

                #endregion

                #region Contract Information
                #region Expiration Date
                PdfPTable contractEffectiveTable = new PdfPTable(4);
                contractEffectiveTable.SetWidths(new float[] { 29f, 21f, 23f, 27f });
                PdfHelper.InitPdfTableProperty(contractEffectiveTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, contractEffectiveTable, null, null);

                PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("Contract Expiration Date: ", PdfHelper.youngFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT, BackgroundColor = PdfHelper.remarkBgColor }
                        , contractEffectiveTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph(base.GetStringByDate(terminationFrom.TfExpirationDate, null), PdfHelper.youngFont))
                        , contractEffectiveTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph("Effective Date of Termination:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.remarkBgColor }
                        , contractEffectiveTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph(base.GetStringByDate(terminationFrom.TfTerminationEffectiveDate, null), PdfHelper.youngFont))
                        , contractEffectiveTable, Rectangle.ALIGN_LEFT, null, false);

                PdfHelper.AddPdfTable(doc, contractEffectiveTable);
                #endregion

                #region Reason
                PdfPTable reasonTable = new PdfPTable(7);
                reasonTable.SetWidths(new float[] { 29f, 5f, 21f, 5f, 15f, 5f, 20f });
                PdfHelper.InitPdfTableProperty(reasonTable);

                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("Reason for Non-Renewal or Termination:\r\n(please check all that apply)", PdfHelper.youngFont)) { Rowspan = 3, BackgroundColor = PdfHelper.remarkBgColor }
                        , reasonTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(terminationFrom.TfReasons != null ? (terminationFrom.TfReasons.ToString().Equals("Accounts Receivable Issues") ? true : false) : false)
                        , reasonTable, null, null, false, false, false, true);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Accounts Receivable Problems", PdfHelper.youngFont))
                        , reasonTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(this.AddCheckBox(terminationFrom.TfReasons != null ? (terminationFrom.TfReasons.ToString().Equals("Not Meeting Quota") ? true : false) : false)
                        , reasonTable, null, null);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Not Meeting Quota", PdfHelper.youngFont))
                        , reasonTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(this.AddCheckBox(terminationFrom.TfReasons != null ? (terminationFrom.TfReasons.ToString().Equals("Product Line Discontinued") ? true : false) : false)
                        , reasonTable, null, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Product Line Discontinued", PdfHelper.youngFont)) { BorderWidth = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                        , reasonTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(terminationFrom.TfReasons != null ? (terminationFrom.TfReasons.ToString().Equals("Others") ? true : false) : false)
                        , reasonTable, null, null, false, false, false, true);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Other (please explain):", PdfHelper.youngFont))
                        , reasonTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(terminationFrom.TfReasonOtherReasons, pdfFont.normalChineseFont)) { Colspan = 4, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                        , reasonTable, null, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddPdfCellHasBorder(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                        , reasonTable, null, null);

                PdfHelper.AddPdfTable(doc, reasonTable);
                #endregion

                #region Amount
                PdfPTable amountTable = new PdfPTable(10);
                amountTable.SetWidths(new float[] { 29f, 3.5f, 7f, 3.5f, 7f, 23f, 3.5f, 10f, 3.5f, 10f });
                PdfHelper.InitPdfTableProperty(amountTable);

                //Current Outstanding A/R Amount:
                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("Current Outstanding A/R Amount:", PdfHelper.youngFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT, BackgroundColor = PdfHelper.remarkBgColor }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph("$" + base.GetStringByDecimalToUSD(terminationFrom.TfOutstandingAmount), PdfHelper.youngFont)) { Colspan = 9 }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);

                //Current Quota Amount:
                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("Current Quota Amount:", PdfHelper.youngFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT, BackgroundColor = PdfHelper.remarkBgColor }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("$" + base.GetStringByDecimalToUSD(terminationFrom.TfQuotaAmount) + "(CNY" + base.GetStringByDecimal(terminationFrom.TfQuotaAmount) + ")", PdfHelper.youngFont)) { Colspan = 4 }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                //Actual Sales:
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Actual Sales:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.remarkBgColor }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph("$" + base.GetStringByDecimalToUSD(terminationFrom.TfActualSales), PdfHelper.youngFont)) { Colspan = 4 }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);

                //Return of Goods Amount:
                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("Return of Goods Amount:", PdfHelper.youngFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT, BackgroundColor = PdfHelper.remarkBgColor }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("$" + base.GetStringByDecimalToUSD(terminationFrom.TfGoodsAmount), PdfHelper.youngFont)) { Colspan = 4 }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                //List of RGA Products Attached:
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("List of RGA Products Attached:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.remarkBgColor }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(terminationFrom.TfHasrgaAttached)
                        , amountTable, null, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Yes", PdfHelper.youngFont))
                        , amountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, false, true, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!terminationFrom.TfHasrgaAttached)
                        , amountTable, null, null, false, false, true, false);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("No", PdfHelper.youngFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                        , amountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                //Does the Third Party have any outstanding tenders?
                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("Does the Third Party have any outstanding tenders?", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.remarkBgColor }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(terminationFrom.TfIsOutstandingTenders)
                        , amountTable, null, Rectangle.ALIGN_BOTTOM, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Yes", PdfHelper.youngFont))
                        , amountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!terminationFrom.TfIsOutstandingTenders)
                        , amountTable, null, Rectangle.ALIGN_BOTTOM, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("No", PdfHelper.youngFont))
                        , amountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, false, false, true, false);

                //Tender Details:If BSC will need to honor tenders post-termination, provide details.
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Tender Details:If BSC will need to honor tenders post-termination, provide details.", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.remarkBgColor }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph(terminationFrom.TfPostTermination, pdfFont.normalChineseFont)) { Colspan = 4 }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);

                //Will a Payment be Due to the Third Party?
                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("Will a Payment be Due to the Third Party?", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.remarkBgColor }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(terminationFrom.TfDuePayment)
                        , amountTable, null, Rectangle.ALIGN_BOTTOM, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Yes", PdfHelper.youngFont))
                        , amountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!terminationFrom.TfDuePayment)
                        , amountTable, null, Rectangle.ALIGN_BOTTOM, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("No", PdfHelper.youngFont))
                        , amountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, false, false, true, false);

                //Credit Amount: 
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Credit Amount: ", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.remarkBgColor }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph("$" + base.GetStringByDecimalToUSD(terminationFrom.TfCreditAmount), PdfHelper.youngFont)) { Colspan = 4 }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);

                //Is a bank guarantee posted to Boston Scientific?
                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("Is a bank guarantee posted to Boston Scientific?", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.remarkBgColor }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(terminationFrom.TfIsBankGuarantee)
                        , amountTable, null, Rectangle.ALIGN_BOTTOM, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Yes", PdfHelper.youngFont))
                        , amountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!terminationFrom.TfIsBankGuarantee)
                        , amountTable, null, Rectangle.ALIGN_BOTTOM, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("No", PdfHelper.youngFont))
                        , amountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, false, false, true, false);
                //Guarantee Amount:
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Guarantee Amount:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.remarkBgColor }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph("$" + base.GetStringByDecimalToUSD(terminationFrom.TfGuaranteeAmount), PdfHelper.youngFont)) { Colspan = 4 }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);

                //Is a reserve already posted on the books?
                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("Is a reserve already posted on the books?", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.remarkBgColor }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(terminationFrom.TfIsReserve)
                        , amountTable, null, Rectangle.ALIGN_BOTTOM, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Yes", PdfHelper.youngFont))
                        , amountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!terminationFrom.TfIsReserve)
                        , amountTable, null, Rectangle.ALIGN_BOTTOM, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("No", PdfHelper.youngFont))
                        , amountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, false, false, true, false);

                //Reserve Amount:
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Reserve Amount:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.remarkBgColor }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph("$" + base.GetStringByDecimalToUSD(terminationFrom.TfReserveAmount), PdfHelper.youngFont)) { Colspan = 4 }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);


                //Proposed Total Amount of Settlement Offer to Third Party:(include all proposed write offs)
                PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph("Proposed Total Amount of Settlement Offer to Third Party:(include all proposed write offs)", PdfHelper.youngFont)) { Rowspan = 2, BackgroundColor = PdfHelper.remarkBgColor }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Settlement", PdfHelper.youngFont)) { Colspan = 2, FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT, BorderWidthTop = 0.6f, BorderWidthRight = 0f, BorderWidthBottom = 0.6f, BorderWidthLeft = 0.6f }
                        , amountTable, null, null, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("$" + base.GetStringByDecimalToUSD(terminationFrom.TfSettlement), PdfHelper.youngFont)) { Colspan = 2, BorderWidth = 0.6f, BorderWidthLeft = 0f }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("Reserve Type:", PdfHelper.youngFont)) { Rowspan = 2, BackgroundColor = PdfHelper.remarkBgColor }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(cbReserveDebt.Checked)
                        , amountTable, null, Rectangle.ALIGN_BOTTOM, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Bad Debt", PdfHelper.youngFont))
                        , amountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(cbReserveSettlement.Checked)
                        , amountTable, null, Rectangle.ALIGN_BOTTOM, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Settlement", PdfHelper.youngFont)) { BorderWidth = 0.6f, BorderWidthLeft = 0f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                        , amountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("Write off", PdfHelper.youngFont)) { Colspan = 2, BorderWidthTop = 0.6f, BorderWidthRight = 0f, BorderWidthBottom = 0.6f, BorderWidthLeft = 0.6f }
                        , amountTable, null, null, false);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("$" + base.GetStringByDecimalToUSD(terminationFrom.TfWriteOff), PdfHelper.youngFont)) { Colspan = 2, BorderWidth = 0.6f, BorderWidthLeft = 0f }
                        , amountTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(this.AddCheckBox(cbReserveReturn.Checked)) { BorderWidthTop = 0f, BorderWidthRight = 0f, BorderWidthBottom = 1f, BorderWidthLeft = 0.6f, BorderColorBottom = PdfHelper.blueColor }
                        , amountTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Sales Return", PdfHelper.youngFont)) { BorderWidth = 0.6f, BorderWidthRight = 0f, BorderWidthTop = 0f, BorderWidthLeft = 0f, BorderWidthBottom = 1f, BorderColorBottom = PdfHelper.blueColor }
                        , amountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(this.AddCheckBox(cbReserveOther.Checked)) { BorderWidthTop = 0f, BorderWidthRight = 0f, BorderWidthBottom = 1f, BorderWidthLeft = 0.6f, BorderColorBottom = PdfHelper.blueColor }
                        , amountTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Other", PdfHelper.youngFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 0f, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorBottom = PdfHelper.blueColor, BorderColorRight = PdfHelper.blueColor }
                        , amountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddPdfTable(doc, amountTable);
                #endregion
                #endregion

                #region Approvals
                PdfPTable approvalTable = new PdfPTable(8);
                approvalTable.SetWidths(new float[] { 2f, 37f, 30f, 2f, 15f, 2f, 10f, 2f });
                PdfHelper.InitPdfTableProperty(approvalTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 8 }, approvalTable, null, null);

                //上边框
                PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("")) { Rowspan = 21 }
                        , approvalTable, null, null, true);
                PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }
                        , approvalTable, null, null, true);
                PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph("")) { Rowspan = 21 }
                        , approvalTable, null, null, true);

                //Approvals
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Approvals", PdfHelper.italicFont)) { Colspan = 6, BackgroundColor = PdfHelper.remarkBgColor }
                        , approvalTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }
                        , approvalTable, null, null);

                #region Country*
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Country*", PdfHelper.italicFont)) { Colspan = 6, BackgroundColor = PdfHelper.grayColor }
                        , approvalTable, Rectangle.ALIGN_LEFT, null);

                //Relationship Manager
                PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell() { FixedHeight = 10f }
                        , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) {FixedHeight = 10f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 0f, BorderWidthTop = 1f, BorderColorTop = PdfHelper.blueColor }
                        , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell() { FixedHeight = 10f, Colspan = 4 }, approvalTable, null, null, true);

                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("Relationship Manager (if applicable)", PdfHelper.normalFont)) { FixedHeight = 15f }
                        , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(terminationFrom.TfRsmPrintName), pdfFont.normalChineseFont)) { FixedHeight = 15f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthTop = 0, BorderColorTop = PdfHelper.blueColor }
                     , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(approvalTable);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(terminationFrom.TfRsmDate), PdfHelper.normalFont)) { FixedHeight = 15f, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, Colspan = 3 }
                        , approvalTable, null, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell()
                        , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, true);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("SIGNATURE", PdfHelper.youngFont)) { FixedHeight = 15f }
                        , approvalTable, null, Rectangle.ALIGN_TOP, true);
                //PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(), approvalTable, null, null, true);
                //PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("PRINT NAME", PdfHelper.youngFont)) { FixedHeight = 15f }
                //        , approvalTable, null, Rectangle.ALIGN_TOP, true);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(), approvalTable, null, null, true);
                PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph("DATE", PdfHelper.youngFont)) { FixedHeight = 15f, Colspan = 3 }
                        , approvalTable, null, Rectangle.ALIGN_TOP, true);

                //Finance Manager
                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell() { FixedHeight = 10f }
                        , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { FixedHeight = 10f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 0 }
                        , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorderRight(new PdfPCell() { FixedHeight = 10f, Colspan = 4 }, approvalTable, null, null, true);

                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("Country Controller / Finance Manager", PdfHelper.normalFont)) { FixedHeight = 15f }
                        , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(terminationFrom.TfFmPrintName), pdfFont.normalChineseFont)) { FixedHeight = 15f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 1f }
                        , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(approvalTable);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(terminationFrom.TfFmDate), PdfHelper.normalFont)) { FixedHeight = 15f, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, Colspan = 3 }
                        , approvalTable, null, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell()
                        , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, true);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("SIGNATURE", PdfHelper.youngFont)) { FixedHeight = 15f }
                        , approvalTable, null, Rectangle.ALIGN_TOP, true);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell() { FixedHeight = 15f }, approvalTable, null, null, true);
                PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph("DATE", PdfHelper.youngFont)) { FixedHeight = 15f, Colspan = 3 }
                        , approvalTable, null, Rectangle.ALIGN_TOP, true);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("* SIGNATURES REQUIRED FOR ALL APPROVAL FORMS", PdfHelper.youngDescFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT, Colspan = 6, PaddingTop = 2f }
                        , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }
                       , approvalTable, null, null);

                #endregion

                #region Finance

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Finance", PdfHelper.italicFont)) { Colspan = 6, BackgroundColor = PdfHelper.grayColor }
                        , approvalTable, Rectangle.ALIGN_LEFT, null);

                PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("Region Controller / VP Finance", PdfHelper.normalFont)) { FixedHeight = 10f }
                        , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { FixedHeight = 10f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 0, BorderWidthTop = 1f, BorderColorTop = PdfHelper.blueColor }
                        , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell() { FixedHeight = 10f, Colspan = 4 }, approvalTable, null, null, true);

                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("(Asia/Pacific,Canada, EMEA, Latin America)", PdfHelper.youngBoldFont)) { FixedHeight = 15f }
                        , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(terminationFrom.TfVpFinancePrintName), pdfFont.normalChineseFont)) { FixedHeight = 15f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthTop = 0, BorderColorTop = PdfHelper.blueColor }
                   , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(approvalTable);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(terminationFrom.TfVpFinanceDate), PdfHelper.normalFont)) { FixedHeight = 15f, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, Colspan = 3 }
                        , approvalTable, null, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph("Annual Contract Value = > $2M ", PdfHelper.youngItalicFont)) { FixedHeight = 15f }
                        , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, true);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("SIGNATURE", PdfHelper.youngFont)) { FixedHeight = 15f }
                        , approvalTable, null, Rectangle.ALIGN_TOP, true);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(), approvalTable, null, null, true);
                //PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("PRINT NAME", PdfHelper.youngFont)) { FixedHeight = 15f }
                //        , approvalTable, null, Rectangle.ALIGN_TOP, true);
                //PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(), approvalTable, null, null, true);
                PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph("DATE", PdfHelper.youngFont)) { FixedHeight = 15f, Colspan = 3 }
                        , approvalTable, null, Rectangle.ALIGN_TOP, true);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }
                       , approvalTable, null, null);
                #endregion

                #region General Management

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("General Management", PdfHelper.italicFont)) { Colspan = 6, BackgroundColor = PdfHelper.grayColor }
                        , approvalTable, Rectangle.ALIGN_LEFT, null);

                PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("Region President or VP", PdfHelper.normalFont)) { FixedHeight = 10f }
                        , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { FixedHeight = 10f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 0, BorderWidthTop = 1f, BorderColorTop = PdfHelper.blueColor }
                        , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell() { FixedHeight = 10f, Colspan = 4 }, approvalTable, null, null, true);

                PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("(Asia/Pacific,Canada, EMEA, Latin America)", PdfHelper.youngBoldFont)) { FixedHeight = 15f }
                        , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(terminationFrom.TfVpPrintName), pdfFont.normalChineseFont)) { FixedHeight = 15f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthTop = 0, BorderColorTop = PdfHelper.blueColor }
                       , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(approvalTable);
                //PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { FixedHeight = 15f }
                //        , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                //PdfHelper.AddEmptyPdfCell(approvalTable);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(terminationFrom.TfVpDate), PdfHelper.normalFont)) { FixedHeight = 15f, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, Colspan = 3 }
                        , approvalTable, null, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph("Annual Contract Value = > $5M ", PdfHelper.youngItalicFont)) { FixedHeight = 15f }
                        , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, true);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("SIGNATURE", PdfHelper.youngFont)) { FixedHeight = 15f }
                        , approvalTable, null, Rectangle.ALIGN_TOP, true);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(), approvalTable, null, null, true);
                //PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("PRINT NAME", PdfHelper.youngFont)) { FixedHeight = 15f }
                //        , approvalTable, null, Rectangle.ALIGN_TOP, true);
                //PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(), approvalTable, null, null, true);
                PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph("DATE", PdfHelper.youngFont)) { FixedHeight = 15f, Colspan = 3 }
                        , approvalTable, null, Rectangle.ALIGN_TOP, true);
                #endregion

                //下边框
                PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph(""))
                        , approvalTable, null, null, true);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }
                        , approvalTable, null, null, true);
                PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph(""))
                        , approvalTable, null, null, true);

                PdfHelper.AddPdfTable(doc, approvalTable);

                #endregion

                // return fileName;
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
            DownloadFileForDCMS(fileName, "IAF_Form_7.pdf", "DCMS");
        }

        private PdfPCell AddCheckBox(string key, string value)
        {
            #region Public Element
            PdfPCell noSelectCell = PdfHelper.GetNoSelectImageCell();
            PdfPCell SelectCell = PdfHelper.GetYesSelectImageCell();
            #endregion

            if (!string.IsNullOrEmpty(key) && value.ToUpper().Equals(key.ToUpper()))
            {
                //选中
                return SelectCell;
            }
            else
            {
                //未选中
                return noSelectCell;
            }
        }

        private PdfPCell AddCheckBox(bool? check)
        {
            #region Public Element
            PdfPCell noSelectCell = PdfHelper.GetNoSelectImageCell();
            PdfPCell SelectCell = PdfHelper.GetYesSelectImageCell();
            #endregion

            if (check != null)
            {
                if (check.Value)
                {
                    //选中
                    return SelectCell;
                }
                else
                {
                    //未选中
                    return noSelectCell;
                }
            }
            else
            {
                //未选中
                return noSelectCell;
            }


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
