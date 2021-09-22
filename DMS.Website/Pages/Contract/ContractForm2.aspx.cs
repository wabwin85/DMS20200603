using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using DMS.Business.Contract;
using DMS.Model;

namespace DMS.Website.Pages.Contract
{
    using Coolite.Ext.Web;
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

    public partial class ContractForm2 : BasePage
    {
        private IContractAppointmentService _appointment = new ContractAppointmentService();
        private IContractRenewalService _renewal = new ContractRenewalService();
        private IContractMasterBLL _contractBll = new ContractMasterBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["ContId"] != null && Request.QueryString["ParmetType"] != null)
            {
                this.hdContractID.Value = Request.QueryString["ContId"];
                this.hdParmetType.Value = Request.QueryString["ParmetType"];
                if (this.hdParmetType.Value.ToString().Equals("Appointment"))
                {
                    BindPageDataAmandment();
                }
                else if (this.hdParmetType.Value.ToString().Equals("Renewal")) 
                {
                    BindPageDataRenewal();
                }
            }
            if (!RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
            {
                btnCreatePdf.Enabled = false;
            }
        }
        private void BindPageDataAmandment()
        {
            ContractAppointment ConApm = _appointment.GetContractAppointmentByID(new Guid(this.hdContractID.Value.ToString()));
            if (ConApm != null)
            {
              
                if (GetObjectDate(ConApm.CapContractType).ToLower().Equals("distributor"))
                {
                    radioDistributor.Checked = true;
                }
                if (GetObjectDate(ConApm.CapContractType).ToLower().Equals("dealer"))
                {
                    radioDealer.Checked = true;
                }
                if (GetObjectDate(ConApm.CapContractType).ToLower().Equals("agent"))
                {
                    radioAgent.Checked = true;
                }

                this.tfThirdPartyName.Text = GetDealerName(ConApm.CapDmaId);

                this.tfThirdParyAddress.Text = GetObjectDate(ConApm.CapOfficeAddress);
                if (ConApm.CapEffectiveDate != null)
                {
                    this.tfContractTermsEffectiveDate.Value = Convert.ToDateTime(ConApm.CapEffectiveDate).ToShortDateString();
                }
                if (ConApm.CapExpirationDate != null)
                {
                    //string aa = ConApm.CapExpirationDate.ToString().Substring(2, 2);
                    this.nfContractTermsExpirationDateYear.Text = Convert.ToDateTime(ConApm.CapExpirationDate).Year.ToString().Substring(2, 2);
                }
              
                if (GetObjectDate(ConApm.CapExclusiveness).ToLower().Equals("exclusive"))
                {
                    radioExclusive.Checked = true;
                }
                if (GetObjectDate(ConApm.CapExclusiveness).ToLower().Equals("non-exclusive"))
                {
                    radioNonExclusive.Checked = true;
                }

                if (ConApm.CapDivision != null)
                {
                    if (ConApm.CapDivision.ToLower().Equals("cardio"))
                    {
                        this.radioProductLineCardio.Checked = true;
                    } if (ConApm.CapDivision.ToLower().Equals("crm"))
                    {
                        this.radioProductLineCrm.Checked = true;
                    }
                    if (ConApm.CapDivision.ToLower().Equals("endo"))
                    {
                        this.radioProductLineEndo.Checked = true;
                    }
                    if (ConApm.CapDivision.ToLower().Equals("pi"))
                    {
                        this.radioProductLinePi.Checked = true;
                    }
                    if (ConApm.CapDivision.ToLower().Equals("ep"))
                    {
                        this.radioProductLineEp.Checked = true;
                    }
                    if (ConApm.CapDivision.ToLower().Equals("uro"))
                    {
                        this.radioProductLineUro.Checked = true;
                    }
                    if (ConApm.CapDivision.ToLower().Equals("as"))
                    {
                        this.radioProductLineAsth.Checked = true;
                    }
                    if (ConApm.CapDivision.ToLower().Equals("sh"))
                    {
                        this.radioProductLineSh.Checked = true;
                    }
                }
                if (GetObjectDate(ConApm.CapPaymentTerm).Equals("COD"))
                {
                    this.radioPaymentTermCashOnly.Checked = true;
                }
                else
                {
                    this.radioPaymentTermOpenAccount.Checked = true;
                    this.tfPaymentTermOpenAccountDay.Text = GetObjectDate(ConApm.CapAccount);
                    this.tfPaymentTermOpenAccountDayBank.Text = GetObjectDate(ConApm.CapCreditLimit);
                    this.tfSecurityAmount.Text = GetObjectDate(ConApm.CapSecurityDeposit);

                    string strGuarantee = GetObjectDate(ConApm.CapGuarantee).ToLower().Replace(" ","");

                    if (!strGuarantee.Equals("")) 
                    {
                        string[] temp = strGuarantee.Split(',');
                        for (int i = 0; i < temp.Length; i++)
                        {
                            string tempValue = temp[i].ToString();
                            if (tempValue.Equals("cashdeposit")) 
                            {
                                cbGuarantee1.Checked = true;
                            }
                            if (tempValue.Equals("bankguarantee"))
                            {
                                cbGuarantee2.Checked = true;
                            }
                            if (tempValue.Equals("companyguarantee"))
                            {
                                cbGuarantee3.Checked = true;
                            }
                            if (tempValue.Equals("realestatemortgage"))
                            {
                                cbGuarantee4.Checked = true;
                            }
                            if (tempValue.Equals("others"))
                            {
                                cbGuarantee5.Checked = true;
                            }
                        }
                    }
                    this.tfSecurityOther.Text = GetObjectDate(ConApm.CapGuaranteeRemark);
                }

                //绑定固定值
                this.tfContractTypeRemarks.Text = "Invoicing,collections,warehousing,receivables and product deliveries";
                this.tfContractyPartySpecify.Text = "China";
                this.tfContractTermsMore2Year.Text = GetMoreThan2Remark(ConApm.CapEffectiveDate, ConApm.CapExpirationDate);
                this.tfContractTermsExclusive.Text = "Reputable and experienced dealer in the region";
                this.tfThirdParyRegion.Text = "(See attachment)";
                this.tfQuotasOther.Text = SR.Const_ExchangeRate.ToString();

            }
        }

        private void BindPageDataRenewal() 
        {
            ContractRenewal renewal = _renewal.GetContractRenewalByID(new Guid(this.hdContractID.Value.ToString()));
            if (renewal != null)
            {
                radioDealer.Checked = true;
                this.tfThirdPartyName.Text = GetDealerName(renewal.CreDmaId);
                //this.tfThirdParyAddress.Text = GetObjectDate(ConApm.CapOfficeAddress);
                if (renewal.CreAgrmtEffectiveDateRenewal != null)
                {
                    this.tfContractTermsEffectiveDate.Value = Convert.ToDateTime(renewal.CreAgrmtEffectiveDateRenewal).ToShortDateString();
                }
                if (renewal.CreAgrmtExpirationDateRenewal != null)
                {
                    //string aa = ConApm.CapExpirationDate.ToString().Substring(2, 2);
                    this.nfContractTermsExpirationDateYear.Text = Convert.ToDateTime(renewal.CreAgrmtExpirationDateRenewal).Year.ToString().Substring(2, 2);
                }

                if (GetObjectDate(renewal.CreExclusivenessRenewal).ToLower().Equals("exclusive"))
                {
                    radioExclusive.Checked = true;
                }
                if (GetObjectDate(renewal.CreExclusivenessRenewal).ToLower().Equals("non-exclusive"))
                {
                    radioNonExclusive.Checked = true;
                }

                if (renewal.CreDivision != null)
                {
                    if (renewal.CreDivision.ToLower().Equals("cardio"))
                    {
                        this.radioProductLineCardio.Checked = true;
                    } if (renewal.CreDivision.ToLower().Equals("crm"))
                    {
                        this.radioProductLineCrm.Checked = true;
                    }
                    if (renewal.CreDivision.ToLower().Equals("endo"))
                    {
                        this.radioProductLineEndo.Checked = true;
                    }
                    if (renewal.CreDivision.ToLower().Equals("pi"))
                    {
                        this.radioProductLinePi.Checked = true;
                    }
                    if (renewal.CreDivision.ToLower().Equals("ep"))
                    {
                        this.radioProductLineEp.Checked = true;
                    }
                    if (renewal.CreDivision.ToLower().Equals("uro"))
                    {
                        this.radioProductLineUro.Checked = true;
                    }
                    if (renewal.CreDivision.ToLower().Equals("as"))
                    {
                        this.radioProductLineAsth.Checked = true;
                    }
                    if (renewal.CreDivision.ToLower().Equals("sh"))
                    {
                        this.radioProductLineSh.Checked = true;
                    }
                }
                if (GetObjectDate(renewal.CrePaymentRenewal).Equals("COD"))
                {
                    this.radioPaymentTermCashOnly.Checked = true;
                }
                else
                {
                    this.radioPaymentTermOpenAccount.Checked = true;
                    this.tfPaymentTermOpenAccountDay.Text = GetObjectDate(renewal.CreAccountRenewal);
                    this.tfPaymentTermOpenAccountDayBank.Text = GetObjectDate(renewal.CreCreditLimitsRenewal);
                    this.tfSecurityAmount.Text = GetObjectDate(renewal.CreSecurityDepositRenewal);

                    string strGuarantee = GetObjectDate(renewal.CreGuaranteeWayRenewal).ToLower().Replace(" ", "");

                    if (!strGuarantee.Equals(""))
                    {
                        string[] temp = strGuarantee.Split(',');
                        for (int i = 0; i < temp.Length; i++)
                        {
                            string tempValue = temp[i].ToString();
                            if (tempValue.Equals("cashdeposit"))
                            {
                                cbGuarantee1.Checked = true;
                            }
                            if (tempValue.Equals("bankguarantee"))
                            {
                                cbGuarantee2.Checked = true;
                            }
                            if (tempValue.Equals("companyguarantee"))
                            {
                                cbGuarantee3.Checked = true;
                            }
                            if (tempValue.Equals("realestatemortgage"))
                            {
                                cbGuarantee4.Checked = true;
                            }
                            if (tempValue.Equals("others"))
                            {
                                cbGuarantee5.Checked = true;
                            }
                        }
                    }
                    this.tfSecurityOther.Text = GetObjectDate(renewal.CreGuaranteeWayRemark);
                }

                //绑定固定值
                this.tfContractTypeRemarks.Text = "Invoicing,collections,warehousing,receivables and product deliveries";
                this.tfContractyPartySpecify.Text = "China";
                this.tfContractTermsMore2Year.Text = GetMoreThan2Remark(renewal.CreAgrmtEffectiveDateRenewal, renewal.CreAgrmtExpirationDateRenewal);
                this.tfContractTermsExclusive.Text = "Reputable and experienced dealer in the region";
                this.tfThirdParyRegion.Text = "(See attachment)";
                this.tfQuotasOther.Text = SR.Const_ExchangeRate.ToString();

            }
        }

        private string GetDealerName(Guid dealerid) 
        {
            string dealerName = "";
            if (dealerid !=null && dealerid != Guid.Empty)
            {
                IDealerMasters bll = new DealerMasters();
                DealerMaster dm = new DealerMaster();
                dm.Id = dealerid;
                IList<DealerMaster> listDm = bll.QueryForDealerMaster(dm);
                if (listDm.Count > 0)
                {
                    DealerMaster getDealerMaster = listDm[0];
                    dealerName=String.IsNullOrEmpty(getDealerMaster.EnglishName) ? getDealerMaster.ChineseName : getDealerMaster.EnglishName;
                }
            }
            return dealerName;
        }

        #region Create IAF_Form_4 File

        protected void CreatePdf(object sender, EventArgs e)
        {
            string fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
            string targetPath = Server.MapPath(PdfHelper.FILE_PATH + fileName);

            Document doc = new Document(iTextSharp.text.PageSize.A4, 36, 36, 75, 12);
            try
            {
                //注册中文字库
                PdfHelper.RegisterChineseFont();
                PdfHelper pdfFont = new PdfHelper();
                
                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
                //设置脚注，页码
                PdfPageEvent pdfPage = new PdfPageEvent("Form 2\r\nInternal Approval Form"
                                            , "044899 Form 2 – Internal Approval Form, Rev D"
                                            , true);
                writer.PageEvent = pdfPage;

                doc.Open();

                #region Public Element
                PdfPCell noSelectCell = PdfHelper.GetNoSelectImageCell();
                PdfPCell SelectCell = PdfHelper.GetYesSelectImageCell();
                #endregion

                #region Pdf Title

                ////设置Title Tabel 
                //PdfPTable titleTable = new PdfPTable(3);
                //titleTable.SetWidths(new float[] { 25f, 50f, 25f });
                //PdfHelper.InitPdfTableProperty(titleTable);

                //titleTable.AddCell(PdfHelper.GetIAFBscLogoImageCell());

                ////Pdf标题
                //PdfPCell titleCell = new PdfPCell(new Paragraph("Form 2\r\nInternal Approval Form", PdfHelper.iafTitleGrayFont));
                //titleCell.HorizontalAlignment = null;
                //titleCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                //titleCell.PaddingBottom = 9f;
                //titleCell.FixedHeight = 65.5f;
                //titleCell.Border = 0;
                //titleTable.AddCell(titleCell);

                //PdfHelper.AddEmptyPdfCell(titleTable);

                ////添加至pdf中
                //PdfHelper.AddPdfTable(doc, titleTable);

                #endregion

                string productRemark = "";
                if (this.hdParmetType.Value.Equals("Appointment"))
                {
                    ContractAppointment ConNew = _appointment.GetContractAppointmentByID(new Guid(this.hdContractID.Value.ToString()));
                    productRemark = ConNew.CapProductLine.ToLower().Equals("all") ? ("All Product of " + ConNew.CapDivision ): ConNew.CapProductLine;
                    #region 1.	Contract Type
                    PdfPTable contractTypeTable = new PdfPTable(12);
                    contractTypeTable.SetWidths(new float[] { 2f, 5f, 10f, 5f, 10f, 5f, 10f, 5f, 10f, 10f, 26f, 2f });
                    PdfHelper.InitPdfTableProperty(contractTypeTable);

                    //上边框
                    PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("")) { Rowspan = 6 }
                            , contractTypeTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 10 }
                            , contractTypeTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph("")) { Rowspan = 6 }
                            , contractTypeTable, null, null, true);

                    //1.	Contract Type
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("1.       Contract Type", PdfHelper.italicFont)) { Colspan = 10, BackgroundColor = PdfHelper.remarkBgColor }
                        , contractTypeTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddImageCell(this.AddCheckBox(ConNew.CapContractType, ContractDealerType.Agent.ToString()), contractTypeTable);
                    PdfHelper.AddPdfCell("Agent", PdfHelper.normalFont, contractTypeTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(ConNew.CapContractType, ContractDealerType.Dealer.ToString()), contractTypeTable);
                    PdfHelper.AddPdfCell("Dealer*", PdfHelper.normalFont, contractTypeTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(ConNew.CapContractType, ContractDealerType.Distributor.ToString()), contractTypeTable);
                    PdfHelper.AddPdfCell("Distributor", PdfHelper.normalFont, contractTypeTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, contractTypeTable);
                    PdfHelper.AddPdfCell("Other*:", PdfHelper.normalFont, contractTypeTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddEmptyPdfCell(contractTypeTable);
                    PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.iafAnswerFont, contractTypeTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("*Describe Dealer and/or Other (include specific activities being performed, e.g. invoicing, collections, warehouse, receivables):", PdfHelper.smallFont)) { Colspan = 10 }
                        , contractTypeTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("Invoicing,collections,warehousing,receivables and product deliveries", PdfHelper.iafAnswerFont)) { Colspan = 10, PaddingBottom = 3f }
                        , contractTypeTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    //空行
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph(" ")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 10 }
                           , contractTypeTable, null, null);

                    PdfHelper.AddPdfTable(doc, contractTypeTable);

                    //BSC Contracting Party
                    PdfPTable bscPartyTable = new PdfPTable(9);
                    bscPartyTable.SetWidths(new float[] { 2f, 5f, 15f, 5f, 15f, 5f, 21f, 30f, 2f });
                    PdfHelper.InitPdfTableProperty(bscPartyTable);

                    PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("")) { Rowspan = 2 }
                            , bscPartyTable, null, null, true);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("BSC Contracting Party", PdfHelper.italicFont)) { Colspan = 7, BackgroundColor = PdfHelper.grayColor }
                        , bscPartyTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph("")) { Rowspan = 2 }
                            , bscPartyTable, null, null, true);

                    PdfHelper.AddImageCell(noSelectCell, bscPartyTable);
                    PdfHelper.AddPdfCell("BSIBV (Kerkrade)", PdfHelper.normalFont, bscPartyTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, bscPartyTable);
                    PdfHelper.AddPdfCell("St. Paul (CRM)", PdfHelper.normalFont, bscPartyTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(SelectCell, bscPartyTable);
                    PdfHelper.AddPdfCell("Local Entity (Specify):", PdfHelper.normalFont, bscPartyTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddPdfCellWithUnderLine("China", PdfHelper.iafAnswerFont, bscPartyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    //下边框
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph(""))
                            , bscPartyTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 7 }
                            , bscPartyTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph(""))
                            , bscPartyTable, null, null, true);

                    PdfHelper.AddPdfTable(doc, bscPartyTable);

                    #endregion

                    #region 2.	Third Party Information
                    PdfPTable thirdParyTable = new PdfPTable(6);
                    thirdParyTable.SetWidths(new float[] { 2f, 16f, 30f, 20f, 30f, 2f });
                    PdfHelper.InitPdfTableProperty(thirdParyTable);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }, thirdParyTable, null, null);

                    //上边框
                    PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("")) { Rowspan = 7 }
                            , thirdParyTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }
                            , thirdParyTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph("")) { Rowspan = 7 }
                            , thirdParyTable, null, null, true);

                    //2.	Third Party Information
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("2.       Third Party Information", PdfHelper.italicFont)) { Colspan = 4, BackgroundColor = PdfHelper.remarkBgColor }
                        , thirdParyTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCell("Name:", PdfHelper.normalFont, thirdParyTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine(GetDealerName(ConNew.CapDmaId), pdfFont.normalChineseFont, thirdParyTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell("Region / Territory:", PdfHelper.normalFont, thirdParyTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine("(See attachment)", PdfHelper.iafAnswerFont, thirdParyTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Address:\r\n(Including Country)", PdfHelper.normalFont)) { FixedHeight = 26f }
                        , thirdParyTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConNew.CapOfficeAddress, pdfFont.normalChineseFont)) { Colspan = 3 }, thirdParyTable, null, Rectangle.ALIGN_BOTTOM);


                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph(" ")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }
                           , thirdParyTable, null, null);

                    PdfHelper.AddPdfTable(doc, thirdParyTable);

                    //Contract Terms
                    PdfPTable termsTable = new PdfPTable(10);
                    termsTable.SetWidths(new float[] { 2f, 14f, 13f, 15f, 13f, 5f, 16f, 5f, 15f, 2f });
                    PdfHelper.InitPdfTableProperty(termsTable);

                    PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("")) { Rowspan = 4 }
                            , termsTable, null, null, true);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Contract Terms", PdfHelper.italicFont)) { Colspan = 8, BackgroundColor = PdfHelper.grayColor }
                        , termsTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph("")) { Rowspan = 4 }
                            , termsTable, null, null, true);

                    PdfHelper.AddPdfCell("Effective Date:", PdfHelper.normalFont, termsTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConNew.CapEffectiveDate, null), PdfHelper.iafAnswerFont, termsTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell("Expiration Date:", PdfHelper.normalFont, termsTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConNew.CapExpirationDate, null), PdfHelper.iafAnswerFont, termsTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddImageCell(this.AddCheckBox(ConNew.CapExclusiveness, Exclusiveness.Non_Exclusive.ToString()), termsTable);
                    PdfHelper.AddPdfCell("Non-Exclusive", PdfHelper.normalFont, termsTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(ConNew.CapExclusiveness, Exclusiveness.Exclusive.ToString()), termsTable);
                    PdfHelper.AddPdfCell("Exclusive*", PdfHelper.normalFont, termsTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If > 2 years, please justify:", PdfHelper.normalFont)) { Colspan = 2 }, termsTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(GetMoreThan2Remark(ConNew.CapEffectiveDate, ConNew.CapExpirationDate), PdfHelper.iafAnswerFont)) { Colspan = 6, PaddingBottom = 3f }, termsTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("*If “Exclusive,” please justify:", PdfHelper.normalFont)) { Colspan = 2 }, termsTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("Reputable and experienced dealer in the region", PdfHelper.iafAnswerFont)) { Colspan = 6, PaddingBottom = 3f }, termsTable, null, Rectangle.ALIGN_BOTTOM);

                    //下边框
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph(""))
                            , termsTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 8 }
                            , termsTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph(""))
                            , termsTable, null, null, true);

                    PdfHelper.AddPdfTable(doc, termsTable);


                    #endregion

                    #region 3.	Additional Documentation Requested for Contract
                    PdfPTable requestedTable = new PdfPTable(11);
                    requestedTable.SetWidths(new float[] { 2f, 5f, 7f, 5f, 21f, 5f, 15f, 5f, 7f, 26f, 2f });
                    PdfHelper.InitPdfTableProperty(requestedTable);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 11 }, requestedTable, null, null);

                    //上边框
                    PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("")) { Rowspan = 3 }
                            , requestedTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 9 }
                            , requestedTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph("")) { Rowspan = 3 }
                            , requestedTable, null, null, true);

                    //3.	Additional Documentation Requested for Contract
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("3.       Additional Documentation Requested for Contract", PdfHelper.italicFont)) { Colspan = 9, BackgroundColor = PdfHelper.remarkBgColor }
                        , requestedTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddImageCell(SelectCell, requestedTable);
                    PdfHelper.AddPdfCell("None", PdfHelper.normalFont, requestedTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, requestedTable);
                    PdfHelper.AddPdfCell("Contract Legalization", PdfHelper.normalFont, requestedTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, requestedTable);
                    PdfHelper.AddPdfCell("Import Certificate", PdfHelper.normalFont, requestedTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, requestedTable);
                    PdfHelper.AddPdfCell("Other:", PdfHelper.normalFont, requestedTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.iafAnswerFont, requestedTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    //下边框
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph(""))
                            , requestedTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 9 }
                            , requestedTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph(""))
                            , requestedTable, null, null, true);

                    PdfHelper.AddPdfTable(doc, requestedTable);
                    #endregion

                    #region 4.	BSC Product Lines (Check ALL Product Lines to be sold by Third Party)
                    PdfPTable productLineTable = new PdfPTable(8);
                    productLineTable.SetWidths(new float[] { 2f, 5f, 30f, 5f, 30f, 5f, 21f, 2f });
                    PdfHelper.InitPdfTableProperty(productLineTable);

                    Chunk cProductLineNote = new Chunk("NOTE: For all Contract Amendment Requests please complete required Sections, including appropriate approvals. ", PdfHelper.normalFont);
                    Chunk cProductLineDesc = new Chunk("\r\n(Quotas should be provided for all new product line requests) .", PdfHelper.descFont);
                    Phrase phraseProductLine = new Phrase();
                    phraseProductLine.Add(cProductLineNote);
                    phraseProductLine.Add(cProductLineDesc);
                    Paragraph paragraphProductLine = new Paragraph();
                    paragraphProductLine.Add(phraseProductLine);

                    PdfHelper.AddPdfCell(new PdfPCell(paragraphProductLine) { FixedHeight = PdfHelper.PDF_NEW_LINE * 3, Colspan = 8 }, productLineTable, null, null);

                    //上边框
                    PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("")) { Rowspan = 7 }
                            , productLineTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }
                            , productLineTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph("")) { Rowspan = 7 }
                            , productLineTable, null, null, true);

                    //4.	BSC Product Lines (Check ALL Product Lines to be sold by Third Party)
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("4.       BSC Product Lines (Check ALL Product Lines to be sold by Third Party)", PdfHelper.italicFont)) { Colspan = 6, BackgroundColor = PdfHelper.remarkBgColor }
                        , productLineTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddImageCell(this.AddCheckBox(ConNew.CapDivision, DivisionName.Cardio.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Interventional Cardiology (Cardio)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(ConNew.CapDivision, DivisionName.CRM.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Cardiac Rhythm Management (CRM)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, productLineTable);
                    PdfHelper.AddPdfCell("Women’s Health (WH)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddImageCell(this.AddCheckBox(ConNew.CapDivision, DivisionName.PI.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Peripheral Interventions (PI)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(ConNew.CapDivision, DivisionName.Endo.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Endoscopy (Endo)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(ConNew.CapDivision, DivisionName.EP.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Electrophysiology (EP)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddImageCell(noSelectCell, productLineTable);
                    PdfHelper.AddPdfCell("Neuromodulation (NM)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(ConNew.CapDivision, DivisionName.Uro.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Urology (Uro)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(ConNew.CapDivision, DivisionName.SH.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Structural Heart (SH)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);



                    PdfHelper.AddImageCell(noSelectCell, productLineTable);
                    PdfHelper.AddPdfCell("Watchman (W)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(ConNew.CapDivision, DivisionName.AS.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Asthma (Asth)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, productLineTable);
                    PdfHelper.AddPdfCell("Other/Partial (list):", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);

                    //PdfHelper.AddPdfCell(new PdfPCell() { Colspan = 6 }, productLineTable, null, null);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph(" ")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }
                           , productLineTable, null, null);

                    PdfHelper.AddPdfTable(doc, productLineTable);
                    #endregion

                    #region 5.	Quotas
                    PdfPTable quotasTable = new PdfPTable(10);
                    quotasTable.SetWidths(new float[] { 2f, 20f, 5f, 5f, 5f, 5f, 5f, 21f, 30f, 2f });
                    PdfHelper.InitPdfTableProperty(quotasTable);

                    //Title
                    PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("")) { Rowspan = 4 }
                            , quotasTable, null, null, true);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("5.       Quotas", PdfHelper.italicFont)) { Colspan = 8, BackgroundColor = PdfHelper.remarkBgColor }
                        , quotasTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph("")) { Rowspan = 4 }
                            , quotasTable, null, null, true);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("NOTE: All quotas should be in US $ or Euro unless contract is with local entity.", PdfHelper.normalFont)) { Colspan = 8 }
                            , quotasTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Please specify currency: ", PdfHelper.normalFont))
                            , quotasTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddImageCell(noSelectCell, quotasTable);
                    PdfHelper.AddPdfCell("US $", PdfHelper.normalFont, quotasTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, quotasTable);
                    PdfHelper.AddPdfCell("Euro", PdfHelper.normalFont, quotasTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(SelectCell, quotasTable);
                    PdfHelper.AddPdfCell("Other (include SFX):", PdfHelper.normalFont, quotasTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine("CNY (USD 1=CNY 6.15)", PdfHelper.iafAnswerFont, quotasTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { Colspan = 8, FixedHeight = 10f, BorderWidth = 0f, BorderWidthBottom = 0.3f }
                            , quotasTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfTable(doc, quotasTable);

                    PdfPTable aopTable = new PdfPTable(9);
                    aopTable.SetWidths(new float[] { 2f, 7f, 15f, 15f, 15f, 15f, 17f, 12f, 2f });
                    PdfHelper.InitPdfTableProperty(aopTable);

                    DataTable dtQuotasnew = _contractBll.GetAopDealersByQueryByContractId(new Guid(this.hdContractID.Value.ToString())).Tables[0];

                    PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("")) { Rowspan = dtQuotasnew.Rows.Count + 4 }, aopTable, null, null, true);
                    PdfHelper.AddPdfCell(new PdfPCell() { Colspan = 7 }, aopTable, null, null);
                    PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph("")) { Rowspan = dtQuotasnew.Rows.Count + 4 }, aopTable, null, null, true);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("QUOTA", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }, aopTable, null, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Q1", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }, aopTable, null, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Q2", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }, aopTable, null, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Q3", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }, aopTable, null, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Q4", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }, aopTable, null, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("TOTAL", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }, aopTable, null, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("% VS PRIOR YEAR SALES", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }, aopTable, null, null);

                    for (int i = 0; i < dtQuotasnew.Rows.Count; i++)
                    {
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(dtQuotasnew.Rows[i]["Year"].ToString(), PdfHelper.normalFont)), aopTable, null, null);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(dtQuotasnew.Rows[i]["Q1"].ToString(), PdfHelper.normalFont)), aopTable, null, null);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(dtQuotasnew.Rows[i]["Q2"].ToString(), PdfHelper.normalFont)), aopTable, null, null);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(dtQuotasnew.Rows[i]["Q3"].ToString(), PdfHelper.normalFont)), aopTable, null, null);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(dtQuotasnew.Rows[i]["Q4"].ToString(), PdfHelper.normalFont)), aopTable, null, null);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(dtQuotasnew.Rows[i]["Amount_Y"].ToString(), PdfHelper.normalFont)), aopTable, null, null);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)), aopTable, null, null);
                    }

                    //CAP_Pricing_Rebate_Remark
                    string PricRemark = "";
                    PricRemark = "Note: the purchase quota given above is the net sales value exclude VAT (value added tax).\r\n\r\n";
                    string rebateRemark = (String.IsNullOrEmpty(ConNew.CapPricingRebateRemark) ? "" : ConNew.CapPricingRebateRemark.ToString());
                    rebateRemark = rebateRemark.Replace("\r\n", " ");
                    PricRemark = PricRemark + rebateRemark;
                    Paragraph paragraphAtt = new Paragraph();
                    paragraphAtt.IndentationLeft = 20f;
                    paragraphAtt.KeepTogether = true;
                    paragraphAtt.Alignment = Element.ALIGN_JUSTIFIED;
                    paragraphAtt.Add(new Paragraph(PricRemark, pdfFont.normalChineseFont));
                    aopTable.AddCell(new PdfPCell(new Paragraph(" ")) { Colspan = 7, Border = 0, FixedHeight = 10f });
                    aopTable.AddCell(new PdfPCell(paragraphAtt) { Colspan = 7, Border = 0 });



                    //下边框
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph(""))
                          , aopTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph()) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 7 }
                            , aopTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph(""))
                            , aopTable, null, null, true);

                    PdfHelper.AddPdfTable(doc, aopTable);
                    #endregion

                    doc.NewPage();

                    #region 6.	Payment Terms (check one)
                    PdfPTable paymentTable = new PdfPTable(8);
                    paymentTable.SetWidths(new float[] { 2f, 5f, 15f, 15f, 25f, 20f, 16f, 2f });
                    PdfHelper.InitPdfTableProperty(paymentTable);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 8 }, paymentTable, null, null);

                    //上边框
                    PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("")) { Rowspan = 6 }
                            , paymentTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }
                            , paymentTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph("")) { Rowspan = 6 }
                            , paymentTable, null, null, true);

                    //6.	Payment Terms (check one)
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("6.       Payment Terms (check one)", PdfHelper.italicFont)) { Colspan = 6, BackgroundColor = PdfHelper.remarkBgColor }
                        , paymentTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddImageCell(this.radioPaymentTermOpenAccount.Checked ? SelectCell : noSelectCell, paymentTable);
                    PdfHelper.AddPdfCell("Open Account:", PdfHelper.normalFont, paymentTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine(this.tfPaymentTermOpenAccountDay.Text, PdfHelper.iafAnswerFont, paymentTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell("day terms with a credit limit of", PdfHelper.normalFont, paymentTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine(this.tfPaymentTermOpenAccountDayBank.Text, PdfHelper.iafAnswerFont, paymentTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(paymentTable);

                    PdfHelper.AddImageCell(this.radioPaymentTermCashOnly.Checked ? SelectCell : noSelectCell, paymentTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Cash in Advance ONLY", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 5 }
                        , paymentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddImageCell(noSelectCell, paymentTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Cash in Advance or Letter of Credit (LOC): payable within ", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 3 }
                        , paymentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.iafAnswerFont, paymentTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell("Days", PdfHelper.normalFont, paymentTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }, paymentTable, null, null);

                    PdfHelper.AddPdfTable(doc, paymentTable);

                    //Security (if required)
                    PdfPTable securityTable = new PdfPTable(11);
                    securityTable.SetWidths(new float[] { 2f, 10f, 15f, 5f, 15, 5f, 6f, 5f, 15f, 20f, 2f });
                    PdfHelper.InitPdfTableProperty(securityTable);

                    PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("")) { Rowspan = 4 }
                            , securityTable, null, null, true);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Security (if required)", PdfHelper.italicFont)) { Colspan = 9, BackgroundColor = PdfHelper.grayColor }
                            , securityTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph("")) { Rowspan = 4 }
                            , securityTable, null, null, true);

                    PdfHelper.AddPdfCell("Amount:", PdfHelper.normalFont, securityTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine(this.tfSecurityAmount.Text, PdfHelper.iafAnswerFont, securityTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);

                    PdfHelper.AddImageCell(this.cbGuarantee1.Checked ? SelectCell : noSelectCell, securityTable);
                    PdfHelper.AddPdfCell("Cash Deposit:", PdfHelper.normalFont, securityTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddImageCell(this.cbGuarantee2.Checked ? SelectCell : noSelectCell, securityTable);
                    PdfHelper.AddPdfCell("Bank Guarantee", PdfHelper.normalFont, securityTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddImageCell(this.cbGuarantee3.Checked ? SelectCell : noSelectCell, securityTable);
                    //PdfHelper.AddPdfCell("Company Guarantee", PdfHelper.normalFont, securityTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Company Guarantee", PdfHelper.normalFont)) { Colspan = 2 }, securityTable, null, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddImageCell(this.cbGuarantee4.Checked ? SelectCell : noSelectCell, securityTable);
                    PdfHelper.AddPdfCell("Real Estate Mortgage", PdfHelper.normalFont, securityTable, Rectangle.ALIGN_LEFT);


                    PdfHelper.AddImageCell(this.cbGuarantee5.Checked ? SelectCell : noSelectCell, securityTable);
                    PdfHelper.AddPdfCell("Other (explain):", PdfHelper.normalFont, securityTable, Rectangle.ALIGN_LEFT);
                    //PdfHelper.AddPdfCellWithUnderLine(this.tfSecurityOther.Text, PdfHelper.iafAnswerFont, securityTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(this.tfSecurityOther.Text, PdfHelper.normalFont)) { Colspan = 3 }, securityTable, null, Rectangle.ALIGN_BOTTOM);
                
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);

                    //下边框
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph(""))
                            , securityTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 9 }
                            , securityTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph(""))
                            , securityTable, null, null, true);

                    PdfHelper.AddPdfTable(doc, securityTable);
                    #endregion

                    #region 7.	Agent Commission Compensation*
                    PdfPTable agentTable = new PdfPTable(13);
                    agentTable.SetWidths(new float[] { 2f, 15f, 5f, 5f, 15f, 5f, 5f, 5f, 7f, 5f, 9f, 19f, 2f });
                    PdfHelper.InitPdfTableProperty(agentTable);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 13 }, agentTable, null, null);

                    //上边框
                    PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("")) { Rowspan = 9 }
                            , agentTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 11 }
                            , agentTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph("")) { Rowspan = 9 }
                            , agentTable, null, null, true);

                    //7.	Agent Commission Compensation*
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("7.       Agent Commission Compensation*", PdfHelper.italicFont)) { Colspan = 11, BackgroundColor = PdfHelper.remarkBgColor }
                            , agentTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Commission Range:", PdfHelper.normalFont)) { Colspan = 2 }, agentTable, null, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.iafAnswerFont, agentTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell("%", PdfHelper.normalFont, agentTable, Rectangle.ALIGN_LEFT);
                    //PdfHelper.AddEmptyPdfCell(agentTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Additional payments *", PdfHelper.normalFont)) { Colspan = 7 }
                            , agentTable, null, Rectangle.ALIGN_BOTTOM);


                    //PdfHelper.AddPdfCell("Payable: Monthly", PdfHelper.normalFont, agentTable, Rectangle.ALIGN_LEFT);
                    //PdfHelper.AddImageCell(noSelectCell, agentTable);
                    //PdfHelper.AddPdfCell("Quarterly", PdfHelper.normalFont, agentTable, Rectangle.ALIGN_LEFT);
                    //PdfHelper.AddImageCell(noSelectCell, agentTable);


                    //PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 7 }
                    //        , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Payable:", PdfHelper.normalFont)) { Colspan = 2 }, agentTable, null, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, agentTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Monthly", PdfHelper.normalFont)) { Colspan = 1 }, agentTable, null, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, agentTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Quarterly", PdfHelper.normalFont)) { Colspan = 2 }, agentTable, null, Rectangle.ALIGN_LEFT);
                    



                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Yes", PdfHelper.normalFont)) { PaddingLeft = 12f }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddImageCell(noSelectCell, agentTable);
                    PdfHelper.AddPdfCell(" - amount ", PdfHelper.normalFont, agentTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.iafAnswerFont, agentTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 7 }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("No", PdfHelper.normalFont)) { PaddingLeft = 12f }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddImageCell(noSelectCell, agentTable);
                    PdfHelper.AddEmptyPdfCell(agentTable);
                    PdfHelper.AddEmptyPdfCell(agentTable);

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 7 }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Type (please specify)", PdfHelper.normalFont)) { Colspan = 3, PaddingLeft = 12f }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.iafAnswerFont, agentTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If > 10% please explain*:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 11 }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("* Includes any signing bonus, up-front payment or guaranteed payment other than sales commissions (Vice President Finance (Regional) signature required).", PdfHelper.descFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 11 }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 11 }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    //下边框
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph(""))
                            , agentTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 11 }
                            , agentTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph(""))
                            , agentTable, null, null, true);

                    PdfHelper.AddPdfTable(doc, agentTable);
                    #endregion

                    #region 8.Approvals
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
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("8. Approvals", PdfHelper.italicFont)) { Colspan = 6, BackgroundColor = PdfHelper.remarkBgColor }
                            , approvalTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }
                            , approvalTable, null, null);

                    #region Country*
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Country*", PdfHelper.italicFont)) { Colspan = 6, BackgroundColor = PdfHelper.grayColor }
                            , approvalTable, Rectangle.ALIGN_LEFT, null);

                    //Relationship Manager
                    PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell() { FixedHeight = 10f }
                            , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { FixedHeight = 10f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 0f, BorderWidthTop = 1f, BorderColorTop = PdfHelper.blueColor }
                            , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell() { FixedHeight = 10f, Colspan = 4 }, approvalTable, null, null, true);

                    PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("Relationship Manager (if applicable)", PdfHelper.normalFont)) { FixedHeight = 15f }
                            , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(ConNew.CapDrmPrintName), pdfFont.normalChineseFont)) { FixedHeight = 15f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthTop = 0, BorderColorTop = PdfHelper.blueColor }
                         , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(approvalTable);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(ConNew.CapDrmDate), PdfHelper.normalFont)) { FixedHeight = 15f, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, Colspan = 3 }
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
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(ConNew.CapFcPrintName), pdfFont.normalChineseFont)) { FixedHeight = 15f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 1f }
                            , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(approvalTable);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(ConNew.CapFcDate), PdfHelper.normalFont)) { FixedHeight = 15f, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, Colspan = 3 }
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
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(ConNew.CapVpfPrintName), pdfFont.normalChineseFont)) { FixedHeight = 15f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthTop = 0, BorderColorTop = PdfHelper.blueColor }
                       , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(approvalTable);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(ConNew.CapVpfDate), PdfHelper.normalFont)) { FixedHeight = 15f, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, Colspan = 3 }
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
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(ConNew.CapVpapPrintName), pdfFont.normalChineseFont)) { FixedHeight = 15f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthTop = 0, BorderColorTop = PdfHelper.blueColor }
                           , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(approvalTable);
                    //PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { FixedHeight = 15f }
                    //        , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                    //PdfHelper.AddEmptyPdfCell(approvalTable);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(ConNew.CapVpapDate), PdfHelper.normalFont)) { FixedHeight = 15f, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, Colspan = 3 }
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
                    
                }
                if (this.hdParmetType.Value.Equals("Renewal")) 
                {
                    ContractRenewal renewal = _renewal.GetContractRenewalByID(new Guid(this.hdContractID.Value.ToString()));
                    productRemark = renewal.CreProductLineNew.ToLower().Equals("all") ? "All product of " + renewal.CreDivision : renewal.CreProductLineRemarks;
                    #region 1.	Contract Type
                    PdfPTable contractTypeTable = new PdfPTable(12);
                    contractTypeTable.SetWidths(new float[] { 2f, 5f, 10f, 5f, 10f, 5f, 10f, 5f, 10f, 10f, 26f, 2f });
                    PdfHelper.InitPdfTableProperty(contractTypeTable);

                    //上边框
                    PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("")) { Rowspan = 6 }
                            , contractTypeTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 10 }
                            , contractTypeTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph("")) { Rowspan = 6 }
                            , contractTypeTable, null, null, true);

                    //1.	Contract Type
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("1.       Contract Type", PdfHelper.italicFont)) { Colspan = 10, BackgroundColor = PdfHelper.remarkBgColor }
                        , contractTypeTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddImageCell(this.AddCheckBox(false), contractTypeTable);
                    PdfHelper.AddPdfCell("Agent", PdfHelper.normalFont, contractTypeTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(true), contractTypeTable);
                    PdfHelper.AddPdfCell("Dealer*", PdfHelper.normalFont, contractTypeTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(false), contractTypeTable);
                    PdfHelper.AddPdfCell("Distributor", PdfHelper.normalFont, contractTypeTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, contractTypeTable);
                    PdfHelper.AddPdfCell("Other*:", PdfHelper.normalFont, contractTypeTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddEmptyPdfCell(contractTypeTable);
                    PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.iafAnswerFont, contractTypeTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("*Describe Dealer and/or Other (include specific activities being performed, e.g. invoicing, collections, warehouse, receivables):", PdfHelper.smallFont)) { Colspan = 10 }
                        , contractTypeTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("Invoicing,collections,warehousing,receivables and product deliveries", PdfHelper.iafAnswerFont)) { Colspan = 10, PaddingBottom = 3f }
                        , contractTypeTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    //空行
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph(" ")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 10 }
                           , contractTypeTable, null, null);

                    PdfHelper.AddPdfTable(doc, contractTypeTable);

                    //BSC Contracting Party
                    PdfPTable bscPartyTable = new PdfPTable(9);
                    bscPartyTable.SetWidths(new float[] { 2f, 5f, 15f, 5f, 15f, 5f, 21f, 30f, 2f });
                    PdfHelper.InitPdfTableProperty(bscPartyTable);

                    PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("")) { Rowspan = 2 }
                            , bscPartyTable, null, null, true);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("BSC Contracting Party", PdfHelper.italicFont)) { Colspan = 7, BackgroundColor = PdfHelper.grayColor }
                        , bscPartyTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph("")) { Rowspan = 2 }
                            , bscPartyTable, null, null, true);

                    PdfHelper.AddImageCell(noSelectCell, bscPartyTable);
                    PdfHelper.AddPdfCell("BSIBV (Kerkrade)", PdfHelper.normalFont, bscPartyTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, bscPartyTable);
                    PdfHelper.AddPdfCell("St. Paul (CRM)", PdfHelper.normalFont, bscPartyTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(SelectCell, bscPartyTable);
                    PdfHelper.AddPdfCell("Local Entity (Specify):", PdfHelper.normalFont, bscPartyTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddPdfCellWithUnderLine("China", PdfHelper.iafAnswerFont, bscPartyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    //下边框
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph(""))
                            , bscPartyTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 7 }
                            , bscPartyTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph(""))
                            , bscPartyTable, null, null, true);

                    PdfHelper.AddPdfTable(doc, bscPartyTable);

                    #endregion

                    #region 2.	Third Party Information
                    PdfPTable thirdParyTable = new PdfPTable(6);
                    thirdParyTable.SetWidths(new float[] { 2f, 16f, 30f, 20f, 30f, 2f });
                    PdfHelper.InitPdfTableProperty(thirdParyTable);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }, thirdParyTable, null, null);

                    //上边框
                    PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("")) { Rowspan = 7 }
                            , thirdParyTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }
                            , thirdParyTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph("")) { Rowspan = 7 }
                            , thirdParyTable, null, null, true);

                    //2.	Third Party Information
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("2.       Third Party Information", PdfHelper.italicFont)) { Colspan = 4, BackgroundColor = PdfHelper.remarkBgColor }
                        , thirdParyTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCell("Name:", PdfHelper.normalFont, thirdParyTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine(GetDealerName(renewal.CreDmaId), pdfFont.normalChineseFont, thirdParyTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell("Region / Territory:", PdfHelper.normalFont, thirdParyTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine("(See attachment)", PdfHelper.iafAnswerFont, thirdParyTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Address:\r\n(Including Country)", PdfHelper.normalFont)) { FixedHeight = 26f }
                        , thirdParyTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(" Address", pdfFont.normalChineseFont)) { Colspan = 3 }, thirdParyTable, null, Rectangle.ALIGN_BOTTOM);


                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph(" ")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }
                           , thirdParyTable, null, null);

                    PdfHelper.AddPdfTable(doc, thirdParyTable);

                    //Contract Terms
                    PdfPTable termsTable = new PdfPTable(10);
                    termsTable.SetWidths(new float[] { 2f, 14f, 13f, 15f, 13f, 5f, 16f, 5f, 15f, 2f });
                    PdfHelper.InitPdfTableProperty(termsTable);

                    PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("")) { Rowspan = 4 }
                            , termsTable, null, null, true);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Contract Terms", PdfHelper.italicFont)) { Colspan = 8, BackgroundColor = PdfHelper.grayColor }
                        , termsTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph("")) { Rowspan = 4 }
                            , termsTable, null, null, true);

                    PdfHelper.AddPdfCell("Effective Date:", PdfHelper.normalFont, termsTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(renewal.CreAgrmtEffectiveDateRenewal, null), PdfHelper.iafAnswerFont, termsTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell("Expiration Date:", PdfHelper.normalFont, termsTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(renewal.CreAgrmtExpirationDateRenewal, null), PdfHelper.iafAnswerFont, termsTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddImageCell(this.AddCheckBox(renewal.CreExclusivenessRenewal, Exclusiveness.Non_Exclusive.ToString()), termsTable);
                    PdfHelper.AddPdfCell("Non-Exclusive", PdfHelper.normalFont, termsTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(renewal.CreExclusivenessRenewal, Exclusiveness.Exclusive.ToString()), termsTable);
                    PdfHelper.AddPdfCell("Exclusive*", PdfHelper.normalFont, termsTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If > 2 years, please justify:", PdfHelper.normalFont)) { Colspan = 2 }, termsTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(GetMoreThan2Remark(renewal.CreAgrmtEffectiveDateRenewal, renewal.CreAgrmtExpirationDateRenewal), PdfHelper.iafAnswerFont)) { Colspan = 6, PaddingBottom = 3f }, termsTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("*If “Exclusive,” please justify:", PdfHelper.normalFont)) { Colspan = 2 }, termsTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("Reputable and experienced dealer in the region", PdfHelper.iafAnswerFont)) { Colspan = 6, PaddingBottom = 3f }, termsTable, null, Rectangle.ALIGN_BOTTOM);

                    //下边框
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph(""))
                            , termsTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 8 }
                            , termsTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph(""))
                            , termsTable, null, null, true);

                    PdfHelper.AddPdfTable(doc, termsTable);


                    #endregion

                    #region 3.	Additional Documentation Requested for Contract
                    PdfPTable requestedTable = new PdfPTable(11);
                    requestedTable.SetWidths(new float[] { 2f, 5f, 7f, 5f, 21f, 5f, 15f, 5f, 7f, 26f, 2f });
                    PdfHelper.InitPdfTableProperty(requestedTable);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 11 }, requestedTable, null, null);

                    //上边框
                    PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("")) { Rowspan = 3 }
                            , requestedTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 9 }
                            , requestedTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph("")) { Rowspan = 3 }
                            , requestedTable, null, null, true);

                    //3.	Additional Documentation Requested for Contract
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("3.       Additional Documentation Requested for Contract", PdfHelper.italicFont)) { Colspan = 9, BackgroundColor = PdfHelper.remarkBgColor }
                        , requestedTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddImageCell(SelectCell, requestedTable);
                    PdfHelper.AddPdfCell("None", PdfHelper.normalFont, requestedTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, requestedTable);
                    PdfHelper.AddPdfCell("Contract Legalization", PdfHelper.normalFont, requestedTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, requestedTable);
                    PdfHelper.AddPdfCell("Import Certificate", PdfHelper.normalFont, requestedTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, requestedTable);
                    PdfHelper.AddPdfCell("Other:", PdfHelper.normalFont, requestedTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.iafAnswerFont, requestedTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    //下边框
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph(""))
                            , requestedTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 9 }
                            , requestedTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph(""))
                            , requestedTable, null, null, true);

                    PdfHelper.AddPdfTable(doc, requestedTable);
                    #endregion

                    #region 4.	BSC Product Lines (Check ALL Product Lines to be sold by Third Party)
                    PdfPTable productLineTable = new PdfPTable(8);
                    productLineTable.SetWidths(new float[] { 2f, 5f, 30f, 5f, 30f, 5f, 21f, 2f });
                    PdfHelper.InitPdfTableProperty(productLineTable);

                    Chunk cProductLineNote = new Chunk("NOTE: For all Contract Amendment Requests please complete required Sections, including appropriate approvals. ", PdfHelper.normalFont);
                    Chunk cProductLineDesc = new Chunk("\r\n(Quotas should be provided for all new product line requests) .", PdfHelper.descFont);
                    Phrase phraseProductLine = new Phrase();
                    phraseProductLine.Add(cProductLineNote);
                    phraseProductLine.Add(cProductLineDesc);
                    Paragraph paragraphProductLine = new Paragraph();
                    paragraphProductLine.Add(phraseProductLine);

                    PdfHelper.AddPdfCell(new PdfPCell(paragraphProductLine) { FixedHeight = PdfHelper.PDF_NEW_LINE * 3, Colspan = 8 }, productLineTable, null, null);

                    //上边框
                    PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("")) { Rowspan = 7 }
                            , productLineTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }
                            , productLineTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph("")) { Rowspan = 7 }
                            , productLineTable, null, null, true);

                    //4.	BSC Product Lines (Check ALL Product Lines to be sold by Third Party)
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("4.       BSC Product Lines (Check ALL Product Lines to be sold by Third Party)", PdfHelper.italicFont)) { Colspan = 6, BackgroundColor = PdfHelper.remarkBgColor }
                        , productLineTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddImageCell(this.AddCheckBox(renewal.CreDivision, DivisionName.Cardio.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Interventional Cardiology (Cardio)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(renewal.CreDivision, DivisionName.CRM.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Cardiac Rhythm Management (CRM)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, productLineTable);
                    PdfHelper.AddPdfCell("Women’s Health (WH)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddImageCell(this.AddCheckBox(renewal.CreDivision, DivisionName.PI.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Peripheral Interventions (PI)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(renewal.CreDivision, DivisionName.Endo.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Endoscopy (Endo)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(renewal.CreDivision, DivisionName.EP.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Electrophysiology (EP)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddImageCell(noSelectCell, productLineTable);
                    PdfHelper.AddPdfCell("Neuromodulation (NM)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(renewal.CreDivision, DivisionName.Uro.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Urology (Uro)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(renewal.CreDivision, DivisionName.SH.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Structural Heart (SH)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);



                    PdfHelper.AddImageCell(noSelectCell, productLineTable);
                    PdfHelper.AddPdfCell("Watchman (W)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(this.AddCheckBox(renewal.CreDivision, DivisionName.AS.ToString()), productLineTable);
                    PdfHelper.AddPdfCell("Asthma (Asth)", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, productLineTable);
                    PdfHelper.AddPdfCell("Other/Partial (list):", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);

                    //PdfHelper.AddPdfCell(new PdfPCell() { Colspan = 6 }, productLineTable, null, null);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph(" ")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }
                           , productLineTable, null, null);

                    PdfHelper.AddPdfTable(doc, productLineTable);
                    #endregion

                    #region 5.	Quotas
                    PdfPTable quotasTable = new PdfPTable(10);
                    quotasTable.SetWidths(new float[] { 2f, 20f, 5f, 5f, 5f, 5f, 5f, 21f, 30f, 2f });
                    PdfHelper.InitPdfTableProperty(quotasTable);

                    //Title
                    PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("")) { Rowspan = 4 }
                            , quotasTable, null, null, true);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("5.       Quotas", PdfHelper.italicFont)) { Colspan = 8, BackgroundColor = PdfHelper.remarkBgColor }
                        , quotasTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph("")) { Rowspan = 4 }
                            , quotasTable, null, null, true);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("NOTE: All quotas should be in US $ or Euro unless contract is with local entity.", PdfHelper.normalFont)) { Colspan = 8 }
                            , quotasTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Please specify currency: ", PdfHelper.normalFont))
                            , quotasTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddImageCell(noSelectCell, quotasTable);
                    PdfHelper.AddPdfCell("US $", PdfHelper.normalFont, quotasTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, quotasTable);
                    PdfHelper.AddPdfCell("Euro", PdfHelper.normalFont, quotasTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(SelectCell, quotasTable);
                    PdfHelper.AddPdfCell("Other (include SFX):", PdfHelper.normalFont, quotasTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine("CNY (USD 1=CNY 6.15)", PdfHelper.iafAnswerFont, quotasTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { Colspan = 8, FixedHeight = 10f, BorderWidth = 0f, BorderWidthBottom = 0.3f }
                            , quotasTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfTable(doc, quotasTable);

                    PdfPTable aopTable = new PdfPTable(9);
                    aopTable.SetWidths(new float[] { 2f, 7f, 15f, 15f, 15f, 15f, 17f, 12f, 2f });
                    PdfHelper.InitPdfTableProperty(aopTable);

                    DataTable dtQuotasnew = _contractBll.GetAopDealerContrastLastYear(new Guid(this.hdContractID.Value.ToString())).Tables[0];

                    PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("")) { Rowspan = dtQuotasnew.Rows.Count + 4 }, aopTable, null, null, true);
                    PdfHelper.AddPdfCell(new PdfPCell() { Colspan = 7 }, aopTable, null, null);
                    PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph("")) { Rowspan = dtQuotasnew.Rows.Count + 4 }, aopTable, null, null, true);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("QUOTA", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }, aopTable, null, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Q1", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }, aopTable, null, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Q2", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }, aopTable, null, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Q3", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }, aopTable, null, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Q4", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }, aopTable, null, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("TOTAL", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }, aopTable, null, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("% VS PRIOR YEAR SALES", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }, aopTable, null, null);

                    for (int i = 0; i < dtQuotasnew.Rows.Count; i++)
                    {
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(dtQuotasnew.Rows[i]["Year"].ToString(), PdfHelper.normalFont)), aopTable, null, null);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(dtQuotasnew.Rows[i]["Q1"].ToString(), PdfHelper.normalFont)), aopTable, null, null);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(dtQuotasnew.Rows[i]["Q2"].ToString(), PdfHelper.normalFont)), aopTable, null, null);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(dtQuotasnew.Rows[i]["Q3"].ToString(), PdfHelper.normalFont)), aopTable, null, null);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(dtQuotasnew.Rows[i]["Q4"].ToString(), PdfHelper.normalFont)), aopTable, null, null);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(dtQuotasnew.Rows[i]["Amount_Y"].ToString(), PdfHelper.normalFont)), aopTable, null, null);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(dtQuotasnew.Rows[i]["Comparison"].ToString(), PdfHelper.normalFont)), aopTable, null, null);
                    }

                    //CAP_Pricing_Rebate_Remark
                    string PricRemark = "";
                    PricRemark = "Note: the purchase quota given above is the net sales value exclude VAT (value added tax).\r\n\r\n";
                    string rebateRemark = (String.IsNullOrEmpty(renewal.CrePricesRemarks) ? "" : renewal.CrePricesRemarks.ToString());
                    rebateRemark = rebateRemark.Replace("\r\n", " ");
                    PricRemark = PricRemark + rebateRemark;
                    Paragraph paragraphAtt = new Paragraph();
                    paragraphAtt.IndentationLeft = 20f;
                    paragraphAtt.KeepTogether = true;
                    paragraphAtt.Alignment = Element.ALIGN_JUSTIFIED;
                    paragraphAtt.Add(new Paragraph(PricRemark, pdfFont.normalChineseFont));
                    aopTable.AddCell(new PdfPCell(new Paragraph(" ")) { Colspan = 7, Border = 0, FixedHeight = 10f });
                    aopTable.AddCell(new PdfPCell(paragraphAtt) { Colspan = 7, Border = 0 });

                    //Paragraph paragraphAtt = new Paragraph();
                    //paragraphAtt.IndentationLeft = 20f;
                    //paragraphAtt.KeepTogether = true;
                    //paragraphAtt.Alignment = Element.ALIGN_JUSTIFIED;
                    //string rebateRemark = (String.IsNullOrEmpty(renewal.CrePricesRemarks) ? "" : renewal.CrePricesRemarks.ToString());
                    //paragraphAtt.Add(new Paragraph(rebateRemark.Replace("\r\n", " "), pdfFont.normalChineseFont));
                    //aopTable.AddCell(new PdfPCell(new Paragraph(" ")) { Colspan = 7, Border = 0, FixedHeight = 10f });
                    //aopTable.AddCell(new PdfPCell(paragraphAtt) { Colspan = 7, Border = 0 });



                    //下边框
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph(""))
                          , aopTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph()) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 7 }
                            , aopTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph(""))
                            , aopTable, null, null, true);

                    PdfHelper.AddPdfTable(doc, aopTable);
                    #endregion

                    doc.NewPage();

                    #region 6.	Payment Terms (check one)
                    PdfPTable paymentTable = new PdfPTable(8);
                    paymentTable.SetWidths(new float[] { 2f, 5f, 15f, 15f, 25f, 20f, 16f, 2f });
                    PdfHelper.InitPdfTableProperty(paymentTable);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 8 }, paymentTable, null, null);

                    //上边框
                    PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("")) { Rowspan = 6 }
                            , paymentTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }
                            , paymentTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph("")) { Rowspan = 6 }
                            , paymentTable, null, null, true);

                    //6.	Payment Terms (check one)
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("6.       Payment Terms (check one)", PdfHelper.italicFont)) { Colspan = 6, BackgroundColor = PdfHelper.remarkBgColor }
                        , paymentTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddImageCell(this.radioPaymentTermOpenAccount.Checked ? SelectCell : noSelectCell, paymentTable);
                    PdfHelper.AddPdfCell("Open Account:", PdfHelper.normalFont, paymentTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine(this.tfPaymentTermOpenAccountDay.Text, PdfHelper.normalFont, paymentTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell("day terms with a credit limit of", PdfHelper.normalFont, paymentTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine(this.tfPaymentTermOpenAccountDayBank.Text, PdfHelper.normalFont, paymentTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(paymentTable);

                    PdfHelper.AddImageCell(this.radioPaymentTermCashOnly.Checked ? SelectCell : noSelectCell, paymentTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Cash in Advance ONLY", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 5 }
                        , paymentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddImageCell(noSelectCell, paymentTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Cash in Advance or Letter of Credit (LOC): payable within ", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 3 }
                        , paymentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.iafAnswerFont, paymentTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell("Days", PdfHelper.normalFont, paymentTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }, paymentTable, null, null);

                    PdfHelper.AddPdfTable(doc, paymentTable);

                    //Security (if required)
                    PdfPTable securityTable = new PdfPTable(11);
                    securityTable.SetWidths(new float[] { 2f, 10f, 15f, 5f, 15, 5f, 6f, 5f, 15f, 20f, 2f });
                    PdfHelper.InitPdfTableProperty(securityTable);

                    PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("")) { Rowspan = 4 }
                            , securityTable, null, null, true);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Security (if required)", PdfHelper.italicFont)) { Colspan = 9, BackgroundColor = PdfHelper.grayColor }
                            , securityTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Paragraph("")) { Rowspan = 4 }
                            , securityTable, null, null, true);

                    PdfHelper.AddPdfCell("Amount:", PdfHelper.normalFont, securityTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine(this.tfSecurityAmount.Text, PdfHelper.iafAnswerFont, securityTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);

                    PdfHelper.AddImageCell(this.cbGuarantee1.Checked ? SelectCell : noSelectCell, securityTable);
                    PdfHelper.AddPdfCell("Cash Deposit:", PdfHelper.normalFont, securityTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddImageCell(this.cbGuarantee2.Checked ? SelectCell : noSelectCell, securityTable);
                    PdfHelper.AddPdfCell("Bank Guarantee", PdfHelper.normalFont, securityTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddImageCell(this.cbGuarantee3.Checked ? SelectCell : noSelectCell, securityTable);
                    //PdfHelper.AddPdfCell("Company Guarantee", PdfHelper.normalFont, securityTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Company Guarantee", PdfHelper.normalFont)) { Colspan = 2 }, securityTable, null, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddImageCell(this.cbGuarantee4.Checked ? SelectCell : noSelectCell, securityTable);
                    PdfHelper.AddPdfCell("Real Estate Mortgage", PdfHelper.normalFont, securityTable, Rectangle.ALIGN_LEFT);


                    PdfHelper.AddImageCell(this.cbGuarantee5.Checked ? SelectCell : noSelectCell, securityTable);
                    PdfHelper.AddPdfCell("Other (explain):", PdfHelper.normalFont, securityTable, Rectangle.ALIGN_LEFT);
                    //PdfHelper.AddPdfCellWithUnderLine(this.tfSecurityOther.Text, PdfHelper.iafAnswerFont, securityTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(this.tfSecurityOther.Text, PdfHelper.normalFont)) { Colspan = 3 }, securityTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);
                    PdfHelper.AddEmptyPdfCell(securityTable);

                    //下边框
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph(""))
                            , securityTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 9 }
                            , securityTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph(""))
                            , securityTable, null, null, true);

                    PdfHelper.AddPdfTable(doc, securityTable);
                    #endregion

                    #region 7.	Agent Commission Compensation*
                    PdfPTable agentTable = new PdfPTable(13);
                    agentTable.SetWidths(new float[] { 2f, 15f, 5f, 5f, 15f, 5f, 5f, 5f, 7f, 5f, 9f, 19f, 2f });
                    PdfHelper.InitPdfTableProperty(agentTable);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 13 }, agentTable, null, null);

                    //上边框
                    PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Paragraph("")) { Rowspan = 9 }
                            , agentTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 11 }
                            , agentTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Paragraph("")) { Rowspan = 9 }
                            , agentTable, null, null, true);

                    //7.	Agent Commission Compensation*
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("7.       Agent Commission Compensation*", PdfHelper.italicFont)) { Colspan = 11, BackgroundColor = PdfHelper.remarkBgColor }
                            , agentTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Commission Range:", PdfHelper.normalFont)) { Colspan = 2 }, agentTable, null, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.iafAnswerFont, agentTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell("%", PdfHelper.normalFont, agentTable, Rectangle.ALIGN_LEFT);
                    //PdfHelper.AddEmptyPdfCell(agentTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Additional payments *", PdfHelper.normalFont)) { Colspan = 7 }
                            , agentTable, null, Rectangle.ALIGN_BOTTOM);


                    //PdfHelper.AddPdfCell("Payable: Monthly", PdfHelper.normalFont, agentTable, Rectangle.ALIGN_LEFT);
                    //PdfHelper.AddImageCell(noSelectCell, agentTable);
                    //PdfHelper.AddPdfCell("Quarterly", PdfHelper.normalFont, agentTable, Rectangle.ALIGN_LEFT);
                    //PdfHelper.AddImageCell(noSelectCell, agentTable);


                    //PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 7 }
                    //        , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Payable:", PdfHelper.normalFont)) { Colspan = 2 }, agentTable, null, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, agentTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Monthly", PdfHelper.normalFont)) { Colspan = 1 }, agentTable, null, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddImageCell(noSelectCell, agentTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Quarterly", PdfHelper.normalFont)) { Colspan = 2 }, agentTable, null, Rectangle.ALIGN_LEFT);




                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Yes", PdfHelper.normalFont)) { PaddingLeft = 12f }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddImageCell(noSelectCell, agentTable);
                    PdfHelper.AddPdfCell(" - amount ", PdfHelper.normalFont, agentTable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.iafAnswerFont, agentTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 7 }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("No", PdfHelper.normalFont)) { PaddingLeft = 12f }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddImageCell(noSelectCell, agentTable);
                    PdfHelper.AddEmptyPdfCell(agentTable);
                    PdfHelper.AddEmptyPdfCell(agentTable);

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 7 }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Type (please specify)", PdfHelper.normalFont)) { Colspan = 3, PaddingLeft = 12f }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.iafAnswerFont, agentTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If > 10% please explain*:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 11 }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("* Includes any signing bonus, up-front payment or guaranteed payment other than sales commissions (Vice President Finance (Regional) signature required).", PdfHelper.descFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 11 }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 11 }
                            , agentTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                    //下边框
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Paragraph(""))
                            , agentTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 11 }
                            , agentTable, null, null, true);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Paragraph(""))
                            , agentTable, null, null, true);

                    PdfHelper.AddPdfTable(doc, agentTable);
                    #endregion

                    #region 8.Approvals
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
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("8. Approvals", PdfHelper.italicFont)) { Colspan = 6, BackgroundColor = PdfHelper.remarkBgColor }
                            , approvalTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 6 }
                            , approvalTable, null, null);

                    #region Country*
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Country*", PdfHelper.italicFont)) { Colspan = 6, BackgroundColor = PdfHelper.grayColor }
                            , approvalTable, Rectangle.ALIGN_LEFT, null);

                    //Relationship Manager
                    PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell() { FixedHeight = 10f }
                            , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { FixedHeight = 10f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 0f, BorderWidthTop = 1f, BorderColorTop = PdfHelper.blueColor }
                            , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell() { FixedHeight = 10f, Colspan = 4 }, approvalTable, null, null, true);

                    PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Paragraph("Relationship Manager (if applicable)", PdfHelper.normalFont)) { FixedHeight = 15f }
                            , approvalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(renewal.CreDrmPrintName), pdfFont.answerChineseFont)) { FixedHeight = 15f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthTop = 0, BorderColorTop = PdfHelper.blueColor }
                         , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(approvalTable);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(renewal.CreDrmDate), PdfHelper.normalFont)) { FixedHeight = 15f, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, Colspan = 3 }
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
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(renewal.CreFcPrintName), pdfFont.answerChineseFont)) { FixedHeight = 15f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 1f }
                            , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(approvalTable);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(renewal.CreFcDate), PdfHelper.normalFont)) { FixedHeight = 15f, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, Colspan = 3 }
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
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(renewal.CreVpfPrintName), pdfFont.answerChineseFont)) { FixedHeight = 15f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthTop = 0, BorderColorTop = PdfHelper.blueColor }
                       , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(approvalTable);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(renewal.CreVpfDate), PdfHelper.normalFont)) { FixedHeight = 15f, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, Colspan = 3 }
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
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(renewal.CreVpapPrintName), pdfFont.answerChineseFont)) { FixedHeight = 15f, Rowspan = 1, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthTop = 0, BorderColorTop = PdfHelper.blueColor }
                           , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(approvalTable);
                    //PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { FixedHeight = 15f }
                    //        , approvalTable, null, Rectangle.ALIGN_BOTTOM);
                    //PdfHelper.AddEmptyPdfCell(approvalTable);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(GetObjectDate(renewal.CreVpapDate), PdfHelper.normalFont)) { FixedHeight = 15f, BorderWidth = 0, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, Colspan = 3 }
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
                    
                }

                #region 授权
                //doc.NewPage();

                //string content = @"Attachment of Form 3 -- Territory:";
                //Chunk chunkAtt = new Chunk(content, PdfHelper.normalFont);
                //Phrase phraseAtt = new Phrase();
                //phraseAtt.Add(chunkAtt);
                //Paragraph paragraphAtt2 = new Paragraph();
                //paragraphAtt2.IndentationLeft = 20f;
                //paragraphAtt2.KeepTogether = true;
                //paragraphAtt2.Alignment = Element.ALIGN_JUSTIFIED;

                //paragraphAtt2.Add(phraseAtt);
                //paragraphAtt2.Add(new Paragraph(" "));
                //doc.Add(paragraphAtt2);

                //Phrase ProductPhrase = new Phrase();
                //ProductPhrase.Add(new Chunk(productRemark, PdfHelper.normalFont));
                //Paragraph ProductParagraph = new Paragraph();
                //ProductParagraph.IndentationLeft = 20f;
                //ProductParagraph.KeepTogether = true;
                //ProductParagraph.Alignment = Element.ALIGN_JUSTIFIED;
                //ProductParagraph.Add(ProductPhrase);
                //doc.Add(ProductParagraph);


                //Chunk hospCnChunk = null;
                //Chunk hospEnChunk = null;
                //Phrase hospPhrase = null;
                //Paragraph hospParagraph = null;
                //PdfHelper pdflp = new PdfHelper();
                
                //DataTable dtTerritorynew = _contractBll.GetContractTerritoryByContractId(new Guid(this.hdContractID.Value.ToString())).Tables[0];
                //for (int i = 0; i < dtTerritorynew.Rows.Count; i++)
                //{
                //    hospCnChunk = new Chunk(dtTerritorynew.Rows[i]["HospitalName"].ToString() + "   ", pdflp.answerChineseFont);
                //    hospEnChunk = new Chunk("(" + dtTerritorynew.Rows[i]["HospitalENName"].ToString() + ")", PdfHelper.normalFont);
                //    hospPhrase = new Phrase();
                //    hospPhrase.Add(new Chunk((i + 1).ToString() + ".   ", PdfHelper.normalFont));
                //    hospPhrase.Add(hospCnChunk);
                //    hospPhrase.Add(hospEnChunk);
                //    hospParagraph = new Paragraph();
                //    hospParagraph.IndentationLeft = 20f;
                //    hospParagraph.KeepTogether = true;
                //    hospParagraph.Alignment = Element.ALIGN_JUSTIFIED;

                //    hospParagraph.Add(hospPhrase);
                //    doc.Add(hospParagraph);
                //}

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
            DownloadFileForDCMS(fileName, "IAF_Form_2.pdf", "DCMS");
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

        public string GetStringByDateYear(DateTime? dateTime)
        {
            return dateTime.HasValue ? dateTime.Value.Year.ToString().Substring(2,2) : string.Empty;
        }

        public string GetMoreThan2Remark(DateTime? EffectiveDate, DateTime? ExpirationDate) 
        {
            string remark = "";
            DateTime towYeraDate = new DateTime();
            if (EffectiveDate.HasValue) 
            {
                towYeraDate = EffectiveDate.Value.AddYears(2);
                if (towYeraDate.CompareTo(ExpirationDate.Value)<= 0) 
                {
                    remark = "Reputable and experienced dealer in the region";
                }
            }
            return remark;
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
