using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
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
    using Coolite.Ext.Web;
    using DMS.Common;
    using System.Data;

    public partial class ContractAppendix4 : BasePage
    {
        private IContractTerminationService termination = new ContractTerminationService();
        private IContractMasterBLL _contractBll = new ContractMasterBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["ContId"] != null)
            {
                this.hdContractID.Value = Request.QueryString["ContId"];
                this.hdDealerType.Value = Request.QueryString["DealerLv"];
                BindPageData();
            }

            //if (!RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
            //{
            //    btnCreatePdf.Enabled = false;
            //}
            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation) && (this.hdDealerType.Value.Equals(DealerType.T1.ToString()) || this.hdDealerType.Value.Equals(DealerType.LP.ToString())))
            {
                btnCreatePdf.Enabled = true;
            }
            else if (this.hdDealerType.Value.Equals(DealerType.T2.ToString()) && RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
            {
                btnCreatePdf.Enabled = true;
            }
            else if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ContractQuery))
            {
                btnCreatePdf.Enabled = true;
            }
            else if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ContractAudit))
            {
                btnCreatePdf.Enabled = true;
            }
            else
            {
                btnCreatePdf.Enabled = false;
            }
        }

        private void BindPageData()
        {
            ContractTermination term = termination.GetContractTerminationByID(new Guid(this.hdContractID.Value.ToString()));
            DataTable dtDivision = _contractBll.GetDivision(String.Empty).Tables[0];
            if (dtDivision.Rows.Count > 0)
            {
                this.rgDivision.Items.Clear();
                for (int i = 0; i < dtDivision.Rows.Count; i++)
                {
                    Radio rd = new Radio();
                    rd.ReadOnly = true;
                    rd.ID = "radioDivision" + dtDivision.Rows[i]["DivisionName"].ToString();
                    rd.BoxLabel = dtDivision.Rows[i]["DivisionName"].ToString();
                    if (term.CteDivision != null)
                    {
                        if (term.CteDivision.ToLower().Equals(dtDivision.Rows[i]["DivisionName"].ToString().ToLower()))
                        {
                            rd.Checked = true;
                        }
                        else
                        {
                            rd.Checked = false;
                        }
                    }
                    else
                    {
                        rd.Checked = false;
                    }
                    this.rgDivision.Items.Add(rd);
                }
            }
            if (term != null) 
            {
                this.laSubBU.Text = term.CteSubdepName;
                this.tfDealerName.Text = term.CteDealerName;
                this.dfAgreeEffectiveDate.Value = term.CteAgreementExpirationDate == null ? null : Convert.ToDateTime(term.CteAgreementExpirationDate).ToShortDateString();
                this.dfTermExpirationDate.Value = term.CteTerminationEffectiveDate == null ? null : Convert.ToDateTime(term.CteTerminationEffectiveDate).ToShortDateString();
                if (term.CteTerminationStatus != null) 
                {
                    if (term.CteTerminationStatus.ToLower().Equals("non-renewal"))
                    {
                        this.radioNonRenewal.Checked = true;
                    }
                    else 
                    {
                        this.radioTermination.Checked = true;
                    }

                }
                if (term.CteTerminationsReasons != null) 
                {
                    if (term.CteTerminationsReasons.ToString().Equals("Accounts Receivable Issues")) 
                    {
                        this.cbAccounts.Checked = true;
                    }
                    else if (term.CteTerminationsReasons.ToString().Equals("Not Meeting Quota"))
                    {
                        this.cbNoQuota.Checked = true;
                    }
                    else if (term.CteTerminationsReasons.ToString().Equals("Product Line Discontinued"))
                    {
                        this.cbPlDis.Checked = true;
                    }
                    else
                    {
                        this.cbOthers.Checked = true;
                    }
                }
                this.tfOtherReasons.Value = term.CteTerminationsReasonsRemark;
                if (term.CtePendTender != null) 
                {
                    if (Convert.ToBoolean(term.CtePendTender))
                    {
                        radioPendingTenderYes.Checked = true;
                    }
                    else 
                    {
                        radioPendingTenderNo.Checked = true;
                    }
                }
                this.tfPendingTenderRemark.Value = term.CtePendTenderRemark;
                if (term.CteRebate != null) 
                {
                    if (term.CteRebate.ToString().ToLower().Equals("exchange product")) 
                    {
                        this.radioRebateReplacement.Checked = true;
                    }
                    if (term.CteRebate.ToString().ToLower().Equals("refund"))
                    {
                        this.radioRebateReturn.Checked = true;
                    }
                }
                this.tfRebateAmount.Text = GetObjectDate(term.CteRebateAmount);
                if (term.CtePromotion != null) 
                {
                    if (term.CtePromotion.ToString().ToLower().Equals("exchange product")) 
                    {
                        this.radioPromotionReplacement.Checked = true;
                    }
                    if (term.CtePromotion.ToString().ToLower().Equals("refund"))
                    {
                        this.radioPromotionReturn.Checked = true;
                    }
                }
                this.tfPromotionAmount.Text = GetObjectDate(term.CtePromotionAmount);
                if (term.CteComplaint != null)
                {
                    if (term.CteComplaint.ToString().ToLower().Equals("exchange product"))
                    {
                        this.radioComplaintReplacement.Checked = true;
                    }
                    if (term.CteComplaint.ToString().ToLower().Equals("refund"))
                    {
                        this.radioComplaintReturn.Checked = true;
                    }
                }
                this.tfComplaintAmount.Text = GetObjectDate(term.CteComplaintAmount);
                if (term.CteTermRetn != null)
                {
                    if (term.CteTermRetn.ToString().Equals("1"))
                    {
                        this.radioTermRetnYes.Checked = true;
                    }
                    if (term.CteTermRetn.ToString().Equals("0"))
                    {
                        this.radioTermRetnNo.Checked = true;
                    }
                }
                if (term.CteTermRetnRemark != null) 
                {
                    if (term.CteTermRetnRemark.ToString().Equals("Long Expiry Products (over 6 months)")) 
                    {
                        this.radioTermRetnReason1.Checked = true;
                    }
                    if (term.CteTermRetnRemark.ToString().Equals("Short Expiry Products"))
                    {
                        this.radioTermRetnReason2.Checked = true;
                    }
                    if (term.CteTermRetnRemark.ToString().Equals("Expired & Damaged Products"))
                    {
                        this.radioTermRetnReason3.Checked = true;
                    }
                }
                this.tfTermRetnAmount.Text = GetObjectDate(term.CteTermRetnAmount);
                if (term.CteScarletLetter != null) 
                {
                    if (term.CteScarletLetter.ToString().Equals("1")) 
                    {
                        radioScarletLetterYes.Checked = true;
                    }
                    if (term.CteScarletLetter.ToString().Equals("0"))
                    {
                        radioScarletLetterNo.Checked = true;
                    }
                }
                this.tfScarletLetterRemark.Text = GetObjectDate(term.CteScarletLetterRemark);

                if (term.CteDisputeMoney != null)
                {
                    if (Convert.ToBoolean(term.CteDisputeMoney))
                    {
                        radioDisputeMoneyYes.Checked = true;
                    }
                    else 
                    {
                        radioDisputeMoneyNo.Checked = true;
                    }
                }
                this.tfDisputeMoneyReason.Text = GetObjectDate(term.CteDisputeMoneyRemark);
                this.tfDisputeMoneyAmount.Text = GetObjectDate(term.CteDisputeMoneyAmount);
                this.tfCurrentAR.Value = term.CteCurrentar.ToString();
                if (term.CteCashDeposit != null)
                {
                    if (Convert.ToBoolean(term.CteCashDeposit))
                    {
                        radioCashDepositYes.Checked = true;
                    }
                    else
                    {
                        radioCashDepositNo.Checked = true;
                    }
                }
                this.tfCashDepositAmount.Text = GetObjectDate(term.CteCashDepositAmount);
                if (term.CteBGuarantee != null)
                {
                    if (term.CteBGuarantee.ToString().Equals("1"))
                    {
                        radioBGuaranteeYes.Checked = true;
                    }
                    else
                    {
                        radioBGuaranteeNo.Checked = true;
                    }
                }
                this.tfBGuaranteeAmount.Text = GetObjectDate(term.CteBGuaranteeAmount);
                if (term.CteCGuarantee != null)
                {
                    if (term.CteCGuarantee.ToString().Equals("1"))
                    {
                        radioCGuaranteeYes.Checked = true;
                    }
                    else
                    {
                        radioCGuaranteeNo.Checked = true;
                    }
                }
                this.tfCGuaranteeAmount.Value = GetObjectDate(term.CteCGuaranteeAmount);
                if (term.CteInventory != null)
                {
                    if (Convert.ToBoolean(term.CteInventory))
                    {
                        radioInventoryYes.Checked = true;
                    }
                    else
                    {
                        radioInventoryNo.Checked = true;
                    }
                }
                this.tfInventoryAmount.Text = GetObjectDate(term.CteInventoryAmount);

                this.tfEstimatedAR.Text = GetObjectDate(term.CteEstimatedar);
                this.tfEstimatedARWirte.Text = GetObjectDate(term.CteEstimatedarWirte);
                if (term.CtePaymentPlan != null)
                {
                    this.tfPaymentPlan.Value = term.CtePaymentPlan.ToString();
                }
                this.tfHandoverTake.Value = term.CteTakeOver;
                if (term.CteTakeOverType != null) 
                {
                    if (term.CteTakeOverType.ToString().Equals("BSC")) 
                    {
                        this.radioTakeType1.Checked = true;
                    }
                    if (term.CteTakeOverType.ToString().Equals("LP"))
                    {
                        this.radioTakeType2.Checked = true;
                    }
                    if (term.CteTakeOverType.ToString().Equals("T1"))
                    {
                        this.radioTakeType3.Checked = true;
                    }
                    if (term.CteTakeOverType.ToString().Equals("T2"))
                    {
                        this.radioTakeType4.Checked = true;
                    }
                }
                if (term.CteTakeOverNew != null) 
                {
                    if (term.CteTakeOverNew.ToString().Equals("1"))
                    {
                        this.radioHandoverAppoinYes.Checked = true;
                    }
                    else 
                    {
                        this.radioHandoverAppoinNo.Checked = true;
                    }
                }


                if (term.CteTimelineHasNotified != null) 
                {
                    if (Convert.ToBoolean(term.CteTimelineHasNotified))
                    {
                        radioTimelineHasNotifiedYes.Checked = true;
                    }
                    else
                    {
                        radioTimelineHasNotifiedNo.Checked = true;
                    }
                }
                if (term.CteTimelineWhenNotify != null) 
                {
                    tfTimelineWhenNotify.Text = Convert.ToDateTime(term.CteTimelineWhenNotify).Year.ToString() +"-"+ Convert.ToDateTime(term.CteTimelineWhenNotify).Month.ToString();
                }
                if (term.CteTimelineWhenSettlement != null)
                {
                    tfTimelineWhenSettlement.Text = Convert.ToDateTime(term.CteTimelineWhenSettlement).Year.ToString() + "-" + Convert.ToDateTime(term.CteTimelineWhenSettlement).Month.ToString();
                }
                if (term.CteTimelineWhenHandover != null)
                {
                    tfTimelineWhenHandover.Text = Convert.ToDateTime(term.CteTimelineWhenHandover).Year.ToString() + "-" + Convert.ToDateTime(term.CteTimelineWhenHandover).Month.ToString();
                }
                //tfTimelineWhenSettlement.Text = term.CteTimelineWhenSettlement.ToString();
                //tfTimelineWhenHandover.Text = term.CteTimelineWhenHandover.ToString();

                if (term.CteHasCommunications != null) 
                {
                    if (Convert.ToBoolean(term.CteHasCommunications))
                    {
                        radioCommunicationsYes.Checked = true;
                    }
                    else
                    {
                        radioCommunicationsNo.Checked = true;
                    }
                }
                if (term.CteHasSettlementProposals != null)
                {
                    if (Convert.ToBoolean(term.CteHasSettlementProposals))
                    {
                        radioSettlementProposalsYes.Checked = true;
                    }
                    else
                    {
                        radioSettlementProposalsNo.Checked = true;
                    }
                }
                if (term.CteHasBusinessHandover != null)
                {
                    if (Convert.ToBoolean(term.CteHasBusinessHandover))
                    {
                        radioBusinessHandoverYes.Checked = true;
                    }
                    else
                    {
                        radioBusinessHandoverNo.Checked = true;
                    }
                }
                tfBusinessHandover_Specify.Text = GetObjectDate(term.CteBusinessHandoverSpecify);
                //if (term.CteHasiafPreparations != null)
                //{
                //    if (Convert.ToBoolean(term.CteHasiafPreparations))
                //    {
                //        radioIAFPreparationsYes.Checked = true;
                //    }
                //    else
                //    {
                //        radioIAFPreparationsNo.Checked = true;
                //    }
                //}
            }
        }

        #region Create Appendix_I File

        protected void CreatePdf(object sender, EventArgs e)
        {
            string fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
            string targetPath = Server.MapPath(PdfHelper.FILE_PATH + fileName);

            Document doc = new Document(iTextSharp.text.PageSize.A4, 36, 36, 12, 12);
            try
            {
                ContractTermination ConTerm = termination.GetContractTerminationByID(new Guid(this.hdContractID.Value.ToString()));

                //注册中文字库
                PdfHelper.RegisterChineseFont();
                PdfHelper pdfFont = new PdfHelper();

                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
                doc.Open();

                #region Public Element
                PdfPCell noSelectCell = PdfHelper.GetNoSelectImageCell();
                PdfPCell SelectCell = PdfHelper.GetYesSelectImageCell();
                #endregion

                #region Pdf Title

                //设置Title Tabel 
                PdfPTable titleTable = new PdfPTable(2);
                titleTable.SetWidths(new float[] { 75f, 25f });
                PdfHelper.InitPdfTableProperty(titleTable);

                //Pdf标题
                PdfPCell titleCell = new PdfPCell(new Paragraph("BSC China & HK Dealer Non-Renewal/Termination Application Form ", PdfHelper.boldFont));
                titleCell.HorizontalAlignment = Rectangle.ALIGN_LEFT;
                titleCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                titleCell.PaddingBottom = 9f;
                titleCell.FixedHeight = 65.5f;
                titleCell.Border = 0;
                titleTable.AddCell(titleCell);

                titleTable.AddCell(PdfHelper.GetBscLogoImageCell());


                //title下划线
                PdfContentByte cb = writer.DirectContent;
                cb.SetLineWidth(0.2f);
                cb.MoveTo(35f, 772.5f);
                cb.LineTo(381f, 772.5f);
                cb.ClosePath();
                cb.Stroke();

                //添加至pdf中
                PdfHelper.AddPdfTable(doc, titleTable);
                #endregion

                #region Section 1 - 3

                #region 副标题
                PdfPTable recTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(recTable);

                PdfPCell recCell = new PdfPCell(new Paragraph("For Requestor: Please Complete Section 1 - 7", PdfHelper.italicFont));
                recCell.HorizontalAlignment = Rectangle.ALIGN_LEFT;
                recCell.VerticalAlignment = Rectangle.ALIGN_TOP;
                recCell.BackgroundColor = BaseColor.YELLOW;
                recCell.FixedHeight = 17f;
                recCell.PaddingTop = 1f;
                recCell.Border = 0;
                recTable.AddCell(recCell);
                PdfHelper.AddPdfTable(doc, recTable);

                #endregion

                #region 1. Division
                PdfPTable divisionTable = new PdfPTable(18);
                divisionTable.SetWidths(new float[] { 19f, 4f, 6f, 4f, 5f, 4f, 5f, 4f, 5f, 4f, 4f, 4f, 4f, 4f, 7f, 4f, 5f, 8f });
                PdfHelper.InitPdfTableProperty(divisionTable);

                //Division
                PdfHelper.AddPdfCell("1. Division (please tick):", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Cardio
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteDivision, DivisionName.Cardio.ToString()), divisionTable);
                PdfHelper.AddPdfCell("Cardio", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //CRM
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteDivision, DivisionName.CRM.ToString()), divisionTable);
                PdfHelper.AddPdfCell("CRM", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Endo
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteDivision, DivisionName.Endo.ToString()), divisionTable);
                PdfHelper.AddPdfCell("Endo", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //EP
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteDivision, DivisionName.EP.ToString()), divisionTable);
                PdfHelper.AddPdfCell("EP", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //PI
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteDivision, DivisionName.PI.ToString()), divisionTable);
                PdfHelper.AddPdfCell("PI", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Uro
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteDivision, DivisionName.Uro.ToString()), divisionTable);
                PdfHelper.AddPdfCell("Uro", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Asthma
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteDivision, DivisionName.AS.ToString()), divisionTable);
                PdfHelper.AddPdfCell("Asthma", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //SH
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteDivision, DivisionName.SH.ToString()), divisionTable);
                PdfHelper.AddPdfCell("SH", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Empty
                PdfHelper.AddEmptyPdfCell(divisionTable);

                PdfHelper.AddPdfTable(doc, divisionTable);

                PdfPTable divisionRec_Table = new PdfPTable(5);
                PdfHelper.InitPdfTableProperty(divisionRec_Table);
                divisionRec_Table.SetWidths(new float[] { 20f, 25f, 20f, 25f, 10f });

                //Recommender
                //PdfHelper.AddPdfCell("Recommender:", PdfHelper.normalFont, divisionRec_Table, null);
                //Recommender Answer
                //PdfHelper.AddPdfCellWithUnderLine("11", PdfHelper.answerFont, divisionRec_Table, null);

                //Job Title
                //PdfHelper.AddPdfCell("Job Title:", PdfHelper.normalFont, divisionRec_Table, null);
                //Job Title Answer
                //PdfHelper.AddPdfCellWithUnderLine("22", PdfHelper.answerFont, divisionRec_Table, null);

                //Empty Cell
                PdfHelper.AddEmptyPdfCell(divisionRec_Table);

                PdfHelper.AddPdfTable(doc, divisionRec_Table);
                #endregion

                #region 2.  Agreement Non-Renewal/Termination Status:
                PdfPTable basicDealerInfoTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(basicDealerInfoTable);

                PdfHelper.AddPdfCell("2.  Agreement Non-Renewal/Termination Status: ", PdfHelper.normalFont, basicDealerInfoTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, basicDealerInfoTable);


                PdfPTable dealerNameTable = new PdfPTable(7);
                dealerNameTable.SetWidths(new float[] { 4f, 15f, 10f, 20f, 30f, 15f, 10f });
                PdfHelper.InitPdfTableProperty(dealerNameTable);



                //Dealer Name            
                PdfHelper.AddEmptyPdfCell(dealerNameTable);
                PdfHelper.AddPdfCell("Dealer Name:", PdfHelper.normalFont, dealerNameTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConTerm.CteDealerName, pdfFont.answerChineseFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 4 }, dealerNameTable, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(dealerNameTable);

                //Agreement Detail
                PdfHelper.AddEmptyPdfCell(dealerNameTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Agreement Expiration Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 2 }, dealerNameTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                //PdfHelper.AddPdfCell("Agreement Expiration Date:", PdfHelper.normalFont, dealerNameTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConTerm.CteAgreementExpirationDate, null), PdfHelper.answerFont, dealerNameTable, null);
                PdfHelper.AddPdfCell("Effective Date of Termination:", PdfHelper.normalFont, dealerNameTable, Rectangle.ALIGN_RIGHT);
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConTerm.CteTerminationEffectiveDate, null), PdfHelper.answerFont, dealerNameTable, null);
                PdfHelper.AddEmptyPdfCell(dealerNameTable);

                PdfHelper.AddPdfTable(doc, dealerNameTable);

                //Please choose one
                PdfPTable chooseTypeTable = new PdfPTable(7);
                chooseTypeTable.SetWidths(new float[] { 4f, 15f, 5f, 25f, 5f, 25f, 25f });
                PdfHelper.InitPdfTableProperty(chooseTypeTable);
                PdfHelper.AddEmptyPdfCell(chooseTypeTable);
                PdfHelper.AddPdfCell("Please choose one:", PdfHelper.descFont, chooseTypeTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteTerminationStatus, TerminationStatus.Non_Renewal.ToString().Replace("_", "-")), chooseTypeTable);
                PdfHelper.AddPdfCell("Non-Renewal", PdfHelper.normalFont, chooseTypeTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteTerminationStatus, TerminationStatus.Termination.ToString()), chooseTypeTable);
                PdfHelper.AddPdfCell("Termination", PdfHelper.normalFont, chooseTypeTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(chooseTypeTable);

                PdfHelper.AddPdfTable(doc, chooseTypeTable);
                #endregion


                #region 3.  Reasons for Non-Renewal/Terminations:
                PdfPTable reasonsTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(reasonsTable);

                PdfHelper.AddPdfCell("3.  Reasons for Non-Renewal/Terminations: (please check all that apply)", PdfHelper.normalFont, reasonsTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, reasonsTable);


                PdfPTable reasonsSelectTable = new PdfPTable(10);
                reasonsSelectTable.SetWidths(new float[] { 4f, 5f, 20f, 5f, 5f, 20f, 5f, 5f, 30f, 5f });
                PdfHelper.InitPdfTableProperty(reasonsSelectTable);

                //Select Reasons
                PdfHelper.AddEmptyPdfCell(reasonsSelectTable);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteTerminationsReasons != null ? (ConTerm.CteTerminationsReasons.ToString().Equals("Accounts Receivable Issues") ? true : false) : false), reasonsSelectTable);
                PdfHelper.AddPdfCell("Accounts Receivable Issues", PdfHelper.normalFont, reasonsSelectTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(reasonsSelectTable);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteTerminationsReasons != null ? (ConTerm.CteTerminationsReasons.ToString().Equals("Not Meeting Quota") ? true : false) : false), reasonsSelectTable);
                PdfHelper.AddPdfCell("Not Meeting Quota", PdfHelper.normalFont, reasonsSelectTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(reasonsSelectTable);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteTerminationsReasons != null ? (ConTerm.CteTerminationsReasons.ToString().Equals("Product Line Discontinued") ? true : false) : false), reasonsSelectTable);
                PdfHelper.AddPdfCell("Product Line Discontinued", PdfHelper.normalFont, reasonsSelectTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(reasonsSelectTable);

                PdfHelper.AddEmptyPdfCell(reasonsSelectTable);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteTerminationsReasons != null ? (ConTerm.CteTerminationsReasons.ToString().Equals("Others") ? true : false) : false), reasonsSelectTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Others(please explain):", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 2 }, reasonsSelectTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConTerm.CteTerminationsReasonsRemark, pdfFont.answerChineseFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 5 }, reasonsSelectTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(reasonsSelectTable);

                PdfHelper.AddPdfTable(doc, reasonsSelectTable);
                #endregion

                #region 4.  Current Status of the Dealer:
                PdfPTable curStatusTitleTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(curStatusTitleTable);
                PdfHelper.AddPdfCell("4.  Current status of the dealer: ", PdfHelper.normalFont, curStatusTitleTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, curStatusTitleTable);


                PdfPTable curStatusTable = new PdfPTable(12);
                curStatusTable.SetWidths(new float[] { 4f, 8f,5f,17f,5f,15f,9f,14f,8f,4f, 10f, 5f });
                PdfHelper.InitPdfTableProperty(curStatusTable);

                //Line1       
                PdfHelper.AddEmptyPdfCell(curStatusTable);
               // PdfHelper.AddPdfCell("(1) Is there any pending tender issues with this dealer (if yes, please specify)?", PdfHelper.normalFont, curStatusTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(1) Is there any pending tender issues with this dealer (if yes, please specify)?", PdfHelper.normalFont)) { Colspan = 10 }, curStatusTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTable);

                PdfHelper.AddEmptyPdfCell(curStatusTable);
                PdfHelper.AddEmptyPdfCell(curStatusTable);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CtePendTender != null ? Convert.ToBoolean(ConTerm.CtePendTender) : false), curStatusTable);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFontmin, curStatusTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CtePendTender != null ? (Convert.ToBoolean(ConTerm.CtePendTender) ? false : true) : false), curStatusTable);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFontmin, curStatusTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Remarks:", PdfHelper.normalFont)) { Colspan = 2 }, curStatusTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConTerm.CtePendTenderRemark, pdfFont.answerChineseFont)) { Colspan = 3 }, curStatusTable, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTable);



                //Line2       
                PdfHelper.AddEmptyPdfCell(curStatusTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(2) Dealer sales rebate (CNY, inc. VAT) ", PdfHelper.normalFont)) { Colspan = 10 }, curStatusTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTable);

                PdfHelper.AddEmptyPdfCell(curStatusTable);
                PdfHelper.AddEmptyPdfCell(curStatusTable);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteRebate, "Exchange product"), curStatusTable);
                PdfHelper.AddPdfCell("Exchange product", PdfHelper.normalFontmin, curStatusTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteRebate, "Refund"), curStatusTable);
                PdfHelper.AddPdfCell("Refund", PdfHelper.normalFontmin, curStatusTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Sales rebate amount:", PdfHelper.normalFont)) { Colspan = 2 }, curStatusTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConTerm.CteRebateAmount != null ? ConTerm.CteRebateAmount.ToString() : "", pdfFont.answerChineseFont)) { Colspan = 3 }, curStatusTable, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTable);


                //Line3      
                //PdfHelper.AddEmptyPdfCell(curStatusTable);
                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(3) Dealer sales promotion (CNY, inc. VAT)", PdfHelper.normalFont)) { Colspan = 4 }, curStatusTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                //PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CtePromotion, "换货"), curStatusTable);
                //PdfHelper.AddPdfCell("Exchange product", PdfHelper.normalFontmin, curStatusTable, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CtePromotion, "退款"), curStatusTable);
                //PdfHelper.AddPdfCell("Refund", PdfHelper.normalFontmin, curStatusTable, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddPdfCell(" Sales promotion amount:", PdfHelper.normalFont, curStatusTable, Rectangle.ALIGN_RIGHT);
                //PdfHelper.AddPdfCellWithUnderLine(ConTerm.CtePromotionAmount != null ? ConTerm.CtePromotionAmount.ToString() : "", pdfFont.answerChineseFont, curStatusTable, null);
                //PdfHelper.AddEmptyPdfCell(curStatusTable);

                PdfHelper.AddEmptyPdfCell(curStatusTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(3) Dealer sales promotion (CNY, inc. VAT) ", PdfHelper.normalFont)) { Colspan = 10 }, curStatusTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTable);

                PdfHelper.AddEmptyPdfCell(curStatusTable);
                PdfHelper.AddEmptyPdfCell(curStatusTable);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CtePromotion, "Exchange product"), curStatusTable);
                PdfHelper.AddPdfCell("Exchange product", PdfHelper.normalFontmin, curStatusTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CtePromotion, "Refund"), curStatusTable);
                PdfHelper.AddPdfCell("Refund", PdfHelper.normalFontmin, curStatusTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Sales promotion amount:", PdfHelper.normalFont)) { Colspan = 2 }, curStatusTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConTerm.CtePromotionAmount != null ? ConTerm.CtePromotionAmount.ToString() : "", pdfFont.answerChineseFont)) { Colspan = 3 }, curStatusTable, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTable);

                //Line4       
                //PdfHelper.AddEmptyPdfCell(curStatusTable);
                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(4) Dealer complance goods return (CNY, inc. VAT) ", PdfHelper.normalFont)) { Colspan = 4 }, curStatusTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                //PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteComplaint, "换货"), curStatusTable);
                //PdfHelper.AddPdfCell("Exchange product", PdfHelper.normalFontmin, curStatusTable, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteComplaint, "退款"), curStatusTable);
                //PdfHelper.AddPdfCell("Refund", PdfHelper.normalFontmin, curStatusTable, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddPdfCell("Goods claim for return and exchange:", PdfHelper.normalFont, curStatusTable, Rectangle.ALIGN_RIGHT);
                //PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteComplaintAmount != null ? ConTerm.CteComplaintAmount.ToString() : "", pdfFont.answerChineseFont, curStatusTable, null);
                //PdfHelper.AddEmptyPdfCell(curStatusTable);


                PdfHelper.AddEmptyPdfCell(curStatusTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(4) Dealer complance goods return (CNY, inc. VAT) ", PdfHelper.normalFont)) { Colspan = 10 }, curStatusTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTable);

                PdfHelper.AddEmptyPdfCell(curStatusTable);
                PdfHelper.AddEmptyPdfCell(curStatusTable);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteComplaint, "Exchange product"), curStatusTable);
                PdfHelper.AddPdfCell("Exchange product", PdfHelper.normalFontmin, curStatusTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteComplaint, "Refund"), curStatusTable);
                PdfHelper.AddPdfCell("Refund", PdfHelper.normalFontmin, curStatusTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Complaint Goods Return and exchange:", PdfHelper.normalFont)) { Colspan = 2 }, curStatusTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConTerm.CteComplaintAmount != null ? ConTerm.CteComplaintAmount.ToString() : "", pdfFont.answerChineseFont)) { Colspan = 3 }, curStatusTable, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTable);


                PdfHelper.AddEmptyPdfCell(curStatusTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(5) Goods Return After Temination ", PdfHelper.normalFont)) { Colspan = 10 }, curStatusTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTable);

                PdfHelper.AddEmptyPdfCell(curStatusTable);
                PdfHelper.AddEmptyPdfCell(curStatusTable);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteTermRetn, "1"), curStatusTable);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFontmin, curStatusTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteTermRetn, "0"), curStatusTable);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFontmin, curStatusTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Goods return amount:", PdfHelper.normalFont)) { Colspan = 2 }, curStatusTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConTerm.CteTermRetnAmount != null ? ConTerm.CteTermRetnAmount.ToString() : "", pdfFont.answerChineseFont)) { Colspan = 3 }, curStatusTable, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTable);

                PdfHelper.AddPdfTable(doc, curStatusTable);

                //Line5     
                //PdfPTable curStatusTable6 = new PdfPTable(9);
                //curStatusTable6.SetWidths(new float[] { 4f,30f, 5f, 10f, 5f, 10f,  20f, 15f, 5f });
                //PdfHelper.InitPdfTableProperty(curStatusTable6);

                //PdfHelper.AddEmptyPdfCell(curStatusTable6);
                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(5) Goods Return After Temination", PdfHelper.normalFont)) { Colspan = 1 }, curStatusTable6, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                //PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteTermRetn, "1"), curStatusTable6);
                //PdfHelper.AddPdfCell("Yes", PdfHelper.normalFontmin, curStatusTable6, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteTermRetn, "0"), curStatusTable6);
                //PdfHelper.AddPdfCell("No", PdfHelper.normalFontmin, curStatusTable6, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddPdfCell("Goods return amount:", PdfHelper.normalFont, curStatusTable6, Rectangle.ALIGN_RIGHT);
                //PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteTermRetnAmount != null ? ConTerm.CteTermRetnAmount.ToString() : "", pdfFont.answerChineseFont, curStatusTable6, null);
                //PdfHelper.AddEmptyPdfCell(curStatusTable6);

                //PdfHelper.AddPdfTable(doc, curStatusTable6);


                PdfPTable curStatusTable2 = new PdfPTable(9);
                curStatusTable2.SetWidths(new float[] { 4f, 20f, 5f, 20f, 5f, 20f, 5f, 20f,5f });
                PdfHelper.InitPdfTableProperty(curStatusTable2);

                PdfHelper.AddEmptyPdfCell(curStatusTable2);
                PdfHelper.AddPdfCell("Return reason:", PdfHelper.descFont, curStatusTable2, Rectangle.ALIGN_RIGHT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteTermRetnRemark != null ? ConTerm.CteTermRetnRemark.ToString().Equals("Long Expiry Products (over 6 months)") : false), curStatusTable2);
                PdfHelper.AddPdfCell("Long expiry products (over 6 months)", PdfHelper.descFont, curStatusTable2, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteTermRetnRemark != null ? ConTerm.CteTermRetnRemark.ToString().Equals("Short Expiry Products") : false), curStatusTable2);
                PdfHelper.AddPdfCell("Short expiry products", PdfHelper.descFont, curStatusTable2, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteTermRetnRemark != null ? ConTerm.CteTermRetnRemark.ToString().Equals("Expired & Damaged Products") : false), curStatusTable2);
                PdfHelper.AddPdfCell("Expired & damaged products", PdfHelper.descFont, curStatusTable2, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(curStatusTable2);

                PdfHelper.AddPdfTable(doc, curStatusTable2);


                PdfPTable curStatusTableRedpiao = new PdfPTable(9);
                curStatusTableRedpiao.SetWidths(new float[] { 4f, 10f, 5f, 10f, 5f, 10f, 19f, 36f, 5f });
                PdfHelper.InitPdfTableProperty(curStatusTableRedpiao);
                //Line6      
                PdfHelper.AddEmptyPdfCell(curStatusTableRedpiao);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(6) Is the dealer certified to issue Red-piao notice from local tax bureau during the coming termination period?", PdfHelper.normalFont)) { Colspan = 7 }, curStatusTableRedpiao, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddEmptyPdfCell(curStatusTableRedpiao);

                PdfHelper.AddEmptyPdfCell(curStatusTableRedpiao);
                PdfHelper.AddEmptyPdfCell(curStatusTableRedpiao);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteScarletLetter, "1"), curStatusTableRedpiao);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFontmin, curStatusTableRedpiao, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteScarletLetter, "0"), curStatusTableRedpiao);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFontmin, curStatusTableRedpiao, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell("Remarks:", PdfHelper.normalFont, curStatusTableRedpiao, Rectangle.ALIGN_RIGHT);
                PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteScarletLetterRemark, pdfFont.answerChineseFont, curStatusTableRedpiao, null);
                PdfHelper.AddEmptyPdfCell(curStatusTableRedpiao);

                PdfHelper.AddPdfTable(doc, curStatusTableRedpiao);



                PdfPTable curStatusTablePending = new PdfPTable(12);
                curStatusTablePending.SetWidths(new float[] { 4f, 10f, 5f, 14f, 5f, 10f, 5f, 14f, 8f, 14f, 10f, 5f });
                PdfHelper.InitPdfTableProperty(curStatusTablePending);
                //Line7      
                PdfHelper.AddEmptyPdfCell(curStatusTablePending);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(7) Any pending payment to the dealer?", PdfHelper.normalFont)) { Colspan = 4 }, curStatusTablePending, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteDisputeMoney != null ? Convert.ToBoolean(ConTerm.CteDisputeMoney) : false), curStatusTablePending);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFontmin, curStatusTablePending, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteDisputeMoney != null ? (Convert.ToBoolean(ConTerm.CteDisputeMoney) ? false : true) : false), curStatusTablePending);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFontmin, curStatusTablePending, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell("Amount:", PdfHelper.normalFont, curStatusTablePending, Rectangle.ALIGN_RIGHT);
                PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteDisputeMoneyAmount != null ? ConTerm.CteDisputeMoneyAmount.ToString() : "", pdfFont.answerChineseFont, curStatusTablePending, null);
                PdfHelper.AddEmptyPdfCell(curStatusTablePending);

                PdfHelper.AddEmptyPdfCell(curStatusTablePending);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("    Reason:", PdfHelper.normalFont)) { Colspan = 2 }, curStatusTablePending, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConTerm.CteDisputeMoneyRemark != null ? ConTerm.CteDisputeMoneyRemark.ToString() : "", pdfFont.answerChineseFont)) { Colspan = 8 }, curStatusTablePending, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTablePending);

                //Line8      
                PdfHelper.AddEmptyPdfCell(curStatusTablePending);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(8) Current A/R balance of the dealer (CNY, inc. VAT):", PdfHelper.normalFont)) { Colspan = 6 }, curStatusTablePending, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConTerm.CteCurrentar != null ? ConTerm.CteCurrentar.ToString() : "", pdfFont.answerChineseFont)) { Colspan = 2 }, curStatusTablePending, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTablePending);
                PdfHelper.AddEmptyPdfCell(curStatusTablePending);
                PdfHelper.AddEmptyPdfCell(curStatusTablePending);

                //Line9      
                PdfHelper.AddEmptyPdfCell(curStatusTablePending);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(9) Does the dealer have a security deposit with BSC", PdfHelper.normalFont)) { Colspan = 10 }, curStatusTablePending, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTablePending);

                PdfHelper.AddEmptyPdfCell(curStatusTablePending);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("    Cash deposit", PdfHelper.normalFont)) { Colspan = 3 }, curStatusTablePending, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteCashDeposit != null ? Convert.ToBoolean(ConTerm.CteCashDeposit) : false), curStatusTablePending);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFontmin, curStatusTablePending, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteCashDeposit != null ? (Convert.ToBoolean(ConTerm.CteCashDeposit) ? false : true) : false), curStatusTablePending);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("No", PdfHelper.normalFontmin)) { Colspan = 2 }, curStatusTablePending, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell("Amount:", PdfHelper.normalFont, curStatusTablePending, Rectangle.ALIGN_RIGHT);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConTerm.CteCashDepositAmount != null ? ConTerm.CteCashDepositAmount.ToString() : "", pdfFont.answerChineseFont)) { Colspan = 1 }, curStatusTablePending, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTablePending);


                PdfHelper.AddEmptyPdfCell(curStatusTablePending);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("    Bank guarantee", PdfHelper.normalFont)) { Colspan = 3 }, curStatusTablePending, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteBGuarantee, "1"), curStatusTablePending);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFontmin, curStatusTablePending, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteBGuarantee, "0"), curStatusTablePending);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("No", PdfHelper.normalFontmin)) { Colspan = 2 }, curStatusTablePending, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell("Amount:", PdfHelper.normalFont, curStatusTablePending, Rectangle.ALIGN_RIGHT);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConTerm.CteBGuaranteeAmount != null ? ConTerm.CteBGuaranteeAmount.ToString() : "", pdfFont.answerChineseFont)) { Colspan = 1 }, curStatusTablePending, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddEmptyPdfCell(curStatusTablePending);

                PdfHelper.AddEmptyPdfCell(curStatusTablePending);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("    Campany guarantee", PdfHelper.normalFont)) { Colspan = 3 }, curStatusTablePending, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteCGuarantee, "1"), curStatusTablePending);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFontmin, curStatusTablePending, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteCGuarantee, "0"), curStatusTablePending);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("No", PdfHelper.normalFontmin)) { Colspan = 2 }, curStatusTablePending, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell("Amount:", PdfHelper.normalFont, curStatusTablePending, Rectangle.ALIGN_RIGHT);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConTerm.CteCGuaranteeAmount != null ? ConTerm.CteCGuaranteeAmount.ToString() : "", pdfFont.answerChineseFont)) { Colspan = 1 }, curStatusTablePending, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTablePending);
                PdfHelper.AddPdfTable(doc, curStatusTablePending);

                PdfPTable curStatusTable4 = new PdfPTable(9);
                curStatusTable4.SetWidths(new float[] { 4f, 45f, 5f, 8, 5f, 8f, 10f, 14f, 5f });
                PdfHelper.InitPdfTableProperty(curStatusTable4);
                //Line10      
                PdfHelper.AddEmptyPdfCell(curStatusTable4);
                PdfHelper.AddPdfCell("(10) Any back order or short term consignment need clear and issue invoices (CNY, inc. VAT)", PdfHelper.normalFont, curStatusTable4, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteInventory != null ? Convert.ToBoolean(ConTerm.CteInventory) : false), curStatusTable4);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFontmin, curStatusTable4, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteInventory != null ? (Convert.ToBoolean(ConTerm.CteInventory) ? false : true) : false), curStatusTable4);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFontmin, curStatusTable4, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell("Amount:", PdfHelper.normalFont, curStatusTable4, Rectangle.ALIGN_RIGHT);
                PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteInventoryAmount != null ? ConTerm.CteInventoryAmount.ToString() : "", pdfFont.answerChineseFont, curStatusTable4, null);
                PdfHelper.AddEmptyPdfCell(curStatusTable4);
                PdfHelper.AddPdfTable(doc, curStatusTable4);

                PdfPTable curStatusTable5 = new PdfPTable(6);
                curStatusTable5.SetWidths(new float[] { 4f, 50f, 10f, 25f, 10f, 5f });
                PdfHelper.InitPdfTableProperty(curStatusTable5);
                //Line11      
                PdfHelper.AddEmptyPdfCell(curStatusTable5);
                PdfHelper.AddPdfCell("(11) Estimated A/R balance after settlement ($, inc. VAT):", PdfHelper.normalFont, curStatusTable5, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteEstimatedar != null ? ConTerm.CteEstimatedar.ToString() : "", pdfFont.answerChineseFont, curStatusTable5, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell("Included the amount pending for write off:", PdfHelper.normalFont, curStatusTable5, Rectangle.ALIGN_RIGHT);
                PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteEstimatedarWirte != null ? ConTerm.CteEstimatedarWirte.ToString() : "", pdfFont.answerChineseFont, curStatusTable5, null);
                PdfHelper.AddEmptyPdfCell(curStatusTable5);

                //Line12
                PdfHelper.AddEmptyPdfCell(curStatusTable5);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(12) If there is outstanding AR after above items on settlement, please provide payment schedule:", PdfHelper.normalFont)) { Colspan = 1 }, curStatusTable5, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConTerm.CtePaymentPlan, pdfFont.answerChineseFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT,  Colspan = 2 }, curStatusTable5, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(curStatusTable5);
                PdfHelper.AddEmptyPdfCell(curStatusTable5);

                PdfHelper.AddPdfTable(doc, curStatusTable5);
                #endregion
             

                #region 5.  Business Handover:
                PdfPTable businessHandoverTitleTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(businessHandoverTitleTable);
                PdfHelper.AddPdfCell("5.  Business handover: ", PdfHelper.normalFont, businessHandoverTitleTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, businessHandoverTitleTable);

                //Detail
                PdfPTable businessHandoverDetailTable = new PdfPTable(12);
                businessHandoverDetailTable.SetWidths(new float[] { 4f, 5f, 20f, 5f, 20f, 5f, 20f, 5f, 5f,5f, 10f, 5f });
                PdfHelper.InitPdfTableProperty(businessHandoverDetailTable);

                //Line1
                PdfHelper.AddEmptyPdfCell(businessHandoverDetailTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Who will take over the business from this dealer:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 4 }, businessHandoverDetailTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConTerm.CteTakeOver, pdfFont.answerChineseFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 5 }, businessHandoverDetailTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(businessHandoverDetailTable);
                PdfHelper.AddEmptyPdfCell(businessHandoverDetailTable);
                //Line2
                PdfHelper.AddEmptyPdfCell(businessHandoverDetailTable);
                PdfHelper.AddImageCell(this.AddCheckBox(this.radioTakeType1.Checked), businessHandoverDetailTable);
                PdfHelper.AddPdfCell("BSC", PdfHelper.normalFont, businessHandoverDetailTable, Rectangle.ALIGN_LEFT);

                PdfHelper.AddImageCell(this.AddCheckBox(this.radioTakeType2.Checked), businessHandoverDetailTable);
                PdfHelper.AddPdfCell("LP", PdfHelper.normalFont, businessHandoverDetailTable, Rectangle.ALIGN_LEFT);

                PdfHelper.AddImageCell(this.AddCheckBox(this.radioTakeType3.Checked), businessHandoverDetailTable);
                PdfHelper.AddPdfCell("T1 Dealer", PdfHelper.normalFont, businessHandoverDetailTable, Rectangle.ALIGN_LEFT);

                PdfHelper.AddImageCell(this.AddCheckBox(this.radioTakeType4.Checked), businessHandoverDetailTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("T2 Dealer", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 3 }, businessHandoverDetailTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddEmptyPdfCell(businessHandoverDetailTable);


                PdfHelper.AddEmptyPdfCell(businessHandoverDetailTable);
                PdfHelper.AddEmptyPdfCell(businessHandoverDetailTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If it is a new dealer, have you submitted the appointment application? ", PdfHelper.descFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 5 }, businessHandoverDetailTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddImageCell(this.AddCheckBox(this.radioHandoverAppoinYes.Checked), businessHandoverDetailTable);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, businessHandoverDetailTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(this.radioHandoverAppoinNo.Checked), businessHandoverDetailTable);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, businessHandoverDetailTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(businessHandoverDetailTable);

                PdfHelper.AddPdfTable(doc, businessHandoverDetailTable);
                #endregion

                #region 6.  Timeline Estimation:
                PdfPTable timelineEstimationTitleTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(timelineEstimationTitleTable);
                PdfHelper.AddPdfCell("6.  Timeline estimation:", PdfHelper.normalFont, timelineEstimationTitleTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, timelineEstimationTitleTable);

                //Line1
                PdfPTable timelineEstimationTable = new PdfPTable(8);
                timelineEstimationTable.SetWidths(new float[] { 4f, 45f, 20f, 5f, 10f, 5f, 10f, 5f });
                PdfHelper.InitPdfTableProperty(timelineEstimationTable);

                //Line1       
                PdfHelper.AddEmptyPdfCell(timelineEstimationTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(1) Have you notified the dealer about the Non-Renewal/Termination? ", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 2 }, timelineEstimationTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteTimelineHasNotified), timelineEstimationTable);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, timelineEstimationTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(radioTimelineHasNotifiedNo.Checked), timelineEstimationTable);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, timelineEstimationTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(timelineEstimationTable);


                //Line2       
                PdfHelper.AddEmptyPdfCell(timelineEstimationTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(2) When would you like to notify the dealer: ", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 1 }, timelineEstimationTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(tfTimelineWhenNotify.Text, PdfHelper.answerFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 5 }, timelineEstimationTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(timelineEstimationTable);

                //Line3       
                PdfHelper.AddEmptyPdfCell(timelineEstimationTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(3) When would you like to complete the settlement: ", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 1 }, timelineEstimationTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(tfTimelineWhenSettlement.Text, PdfHelper.answerFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 5 }, timelineEstimationTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(timelineEstimationTable);

                //Line4       
                PdfHelper.AddEmptyPdfCell(timelineEstimationTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(4) When would you like to complete the handover: ", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 1 }, timelineEstimationTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(tfTimelineWhenHandover.Text, PdfHelper.answerFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 5 }, timelineEstimationTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(timelineEstimationTable);

                PdfHelper.AddPdfTable(doc, timelineEstimationTable);
                #endregion

                #region Sales Division Management Approvals
                PdfPTable sdmApprovalTable = new PdfPTable(6);
                sdmApprovalTable.SetWidths(new float[] { 4f, 20f, 23f, 20f, 23f, 10f });
                PdfHelper.InitPdfTableProperty(sdmApprovalTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Colspan = 8 }, sdmApprovalTable, null, null);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Sales Division Management Approvals:", PdfHelper.italicFont)) { BackgroundColor = BaseColor.CYAN, FixedHeight = 17f, PaddingTop = 1f, Colspan = 8 },
                    sdmApprovalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("ZSM / RSM / Applicant:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteRsmPrintName, PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
               
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConTerm.CteRsmDate, ""), PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);

                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("NCM:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteNcmPrintName, PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConTerm.CteNcmDate, ""), PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);

                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("BUM / NSM:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteNsmPrintName, PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConTerm.CteNsmDate, ""), PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);

                PdfHelper.AddPdfTable(doc, sdmApprovalTable);

                #endregion

                #endregion

                #region Section 7- 10

                #region 副标题
                PdfPTable forNcmTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(forNcmTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f }, forNcmTable, null, null);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("For National Channel Manager: Please Complete Section 8 - 11", PdfHelper.italicFont)) { FixedHeight = 17f, PaddingTop = 1f, BackgroundColor = BaseColor.PINK },
                    forNcmTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                PdfHelper.AddPdfTable(doc, forNcmTable);

                #endregion
                #region 7.  Internal Communications:
                PdfPTable internalCommunicationsTable = new PdfPTable(8);
                internalCommunicationsTable.SetWidths(new float[] { 4f, 20f, 42f, 5f, 7f, 5f, 7f, 10f });
                PdfHelper.InitPdfTableProperty(internalCommunicationsTable);

                //8.  Internal Communications:  
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("7.  Internal Communications: ", PdfHelper.normalFont)) { Colspan = 8, FixedHeight = 25f }, internalCommunicationsTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                //第1行
                PdfHelper.AddEmptyPdfCell(internalCommunicationsTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Have you notified this case to DRM, Finance, Operations & HEGA? ", PdfHelper.normalFont)) { Colspan = 2, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    internalCommunicationsTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteHasCommunications), internalCommunicationsTable);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, internalCommunicationsTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(!ConTerm.CteHasCommunications), internalCommunicationsTable);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, internalCommunicationsTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(internalCommunicationsTable);

                PdfHelper.AddPdfTable(doc, internalCommunicationsTable);
                #endregion

                #region 9.  Settlement Proposals:
                PdfPTable settlementProposalsTable = new PdfPTable(8);
                settlementProposalsTable.SetWidths(new float[] { 4f, 20f, 42f, 5f, 7f, 5f, 7f, 10f });
                PdfHelper.InitPdfTableProperty(settlementProposalsTable);

                //8.  Settlement Proposals: 
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("8.  Settlement Proposals: ", PdfHelper.normalFont)) { Colspan = 8, FixedHeight = 25f }, settlementProposalsTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                //第1行
                PdfHelper.AddEmptyPdfCell(settlementProposalsTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Have you reviewed and confirmed above settlement proposals? ", PdfHelper.normalFont)) { Colspan = 2, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    settlementProposalsTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteHasSettlementProposals), settlementProposalsTable);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, settlementProposalsTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(!ConTerm.CteHasSettlementProposals), settlementProposalsTable);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, settlementProposalsTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(settlementProposalsTable);

                PdfHelper.AddPdfTable(doc, settlementProposalsTable);
                #endregion

                #region 10.  Business Handover:
                PdfPTable businessHandoverTable = new PdfPTable(8);
                businessHandoverTable.SetWidths(new float[] { 4f, 35f, 27f, 5f, 7f, 5f, 7f, 10f });
                PdfHelper.InitPdfTableProperty(businessHandoverTable);

                //9.  Business Handover:
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("9.  Business Handover:", PdfHelper.normalFont)) { Colspan = 8, FixedHeight = 25f }, businessHandoverTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                //第1行
                PdfHelper.AddEmptyPdfCell(businessHandoverTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Have you submitted new dealer appointment IAF for handover purpose? ", PdfHelper.normalFont)) { Colspan = 2, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    businessHandoverTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteHasBusinessHandover), businessHandoverTable);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, businessHandoverTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(!ConTerm.CteHasBusinessHandover), businessHandoverTable);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, businessHandoverTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(businessHandoverTable);
                //第2行
                PdfHelper.AddEmptyPdfCell(businessHandoverTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If not applicable, please specify: ", PdfHelper.descFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, PaddingBottom = 5f },
                    businessHandoverTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConTerm.CteBusinessHandoverSpecify, pdfFont.answerChineseFont)) { Colspan = 5 },
                    businessHandoverTable, null, null);
                PdfHelper.AddEmptyPdfCell(businessHandoverTable);

                PdfHelper.AddPdfTable(doc, businessHandoverTable);
                #endregion


                //#region 10.  IAF Preparations:
                //PdfPTable iafPreparationsTable = new PdfPTable(8);
                //iafPreparationsTable.SetWidths(new float[] { 4f, 30f, 32f, 5f, 7f, 5f, 7f, 10f });
                //PdfHelper.InitPdfTableProperty(iafPreparationsTable);

                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("10.  IAF Preparations: ", PdfHelper.normalFont)) { Colspan = 8, FixedHeight = 25f },
                //    iafPreparationsTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                //PdfHelper.AddEmptyPdfCell(iafPreparationsTable);
                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Have you prepared Dealer Non-Renewal IAF and attached it to this form? ", PdfHelper.normalFont)) { Colspan = 2, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                //    iafPreparationsTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                //PdfHelper.AddImageCell(this.AddCheckBox(ConTerm.CteHasiafPreparations), iafPreparationsTable);
                //PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, iafPreparationsTable, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddImageCell(this.AddCheckBox(!ConTerm.CteHasiafPreparations), iafPreparationsTable);
                //PdfHelper.AddPdfCell("No", PdfHelper.normalFont, iafPreparationsTable, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddEmptyPdfCell(iafPreparationsTable);

                //PdfHelper.AddPdfTable(doc, iafPreparationsTable);
                //#endregion

                #region NCM Approval
                PdfPTable ncmApprovalTable = new PdfPTable(6);
                ncmApprovalTable.SetWidths(new float[] { 4f, 20f, 23f, 20f, 23f, 10f });
                PdfHelper.InitPdfTableProperty(ncmApprovalTable);
                ncmApprovalTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 6 });
                PdfHelper.AddPdfTable(doc, ncmApprovalTable);

                PdfHelper.AddEmptyPdfCell(ncmApprovalTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("NCM Signature:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT },
                    ncmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteNcmForPart2PrintName, PdfHelper.answerFont, ncmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT },
                    ncmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConTerm.CteNcmForPart2Date, ""), PdfHelper.answerFont, ncmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(ncmApprovalTable);

                ncmApprovalTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 6 });
                PdfHelper.AddPdfTable(doc, ncmApprovalTable);

                #endregion

                if (ConTerm.CteDrmPrintName != null && !ConTerm.CteDrmPrintName.ToString().Equals(""))
                {
                    #region Local Management Approvals
                    PdfPTable localManagementTable = new PdfPTable(6);
                    localManagementTable.SetWidths(new float[] { 4f, 20f, 23f, 20f, 23f, 10f });
                    PdfHelper.InitPdfTableProperty(localManagementTable);
                    localManagementTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 6 });

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Colspan = 6 }, localManagementTable, null, null);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Sales Division Management Approvals:", PdfHelper.italicFont)) { BackgroundColor = BaseColor.CYAN, FixedHeight = 17f, PaddingTop = 1f, Colspan = 8 },
                        localManagementTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                    PdfHelper.AddEmptyPdfCell(localManagementTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("DRM Manager:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteDrmPrintName, PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConTerm.CteDrmDate, ""), PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(localManagementTable);

                    if (ConTerm.CteFcPrintName != null && !ConTerm.CteFcPrintName.ToString().Equals(""))
                    {
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Finance Director:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteFcPrintName, PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);

                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConTerm.CteFcDate, ""), PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                    }

                    if (ConTerm.CteCdPrintName != null && !ConTerm.CteCdPrintName.ToString().Equals(""))
                    {
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Country Director:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteCdPrintName, PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);

                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConTerm.CteCdDate, ""), PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                    }
                    localManagementTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 6 });
                    PdfHelper.AddPdfTable(doc, localManagementTable);

                    #endregion
                }

                if (ConTerm.CteVpfPrintName != null && !ConTerm.CteVpfPrintName.ToString().Equals(""))
                {
                    #region Regional Management Approvals
                    PdfPTable regionalManagementTable = new PdfPTable(6);
                    regionalManagementTable.SetWidths(new float[] { 4f, 20f, 23f, 20f, 23f, 10f });
                    PdfHelper.InitPdfTableProperty(regionalManagementTable);
                    regionalManagementTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 6 });

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Colspan = 6 }, regionalManagementTable, null, null);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Regional Management Approvals:", PdfHelper.italicFont)) { BackgroundColor = BaseColor.CYAN, FixedHeight = 17f, PaddingTop = 1f, Colspan = 8 },
                        regionalManagementTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                    PdfHelper.AddEmptyPdfCell(regionalManagementTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Region Controller /VP \r\n Finance Asia-Pacific:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, regionalManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteVpfPrintName, PdfHelper.answerFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, regionalManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConTerm.CteVpfDate, ""), PdfHelper.answerFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(regionalManagementTable);

                    PdfHelper.AddEmptyPdfCell(regionalManagementTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("EVP & President,\r\n Asia-Pacific:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, regionalManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(ConTerm.CteVpapPrintName, PdfHelper.answerFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, regionalManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConTerm.CteVpapDate, ""), PdfHelper.answerFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(regionalManagementTable);

                    PdfHelper.AddPdfTable(doc, regionalManagementTable);

                    #endregion
                }

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
            DownloadFileForDCMS(fileName, "Appendix_4.pdf", "DCMS");
           
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
