using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.Website.Common;
using DMS.Business.Contract;
using DMS.Model;
using System.Data;
using DMS.Business;
using Coolite.Ext.Web;

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

    public partial class ContractAppendix1 : BasePage
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
        private IContractMasterBLL _contractBll = new ContractMasterBLL();
        private IDealerMasters _dealerMasters = new DealerMasters();
        
        //private DataTable dtProductLine = new DataTable();
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (Request.QueryString["ContId"] != null)
                {
                    this.hdContractID.Value = Request.QueryString["ContId"];
                    this.hdDealerType.Value = Request.QueryString["DealerLv"];
                    BindPageData();
                }
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
        }

        protected void Store_RefreshTerritoryNew(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable dtTerritoryAll = _contractBll.GetContractTerritoryByContractId(new Guid(this.hdContractID.Value.ToString())).Tables[0];
            DataTable dtTerritory = dtTerritoryAll.Clone();
            DataRow[] drTerritory = dtTerritoryAll.Select("ProductLineId <> 'DD1B6ADF-3772-4E4A-B9CC-A2B900B5F935'");
            foreach (DataRow row in drTerritory)
            {
                dtTerritory.Rows.Add(row.ItemArray);
            }
          
            if (dtTerritory.Rows.Count > 0)
            {
                this.TerritoryNew.DataSource = dtTerritory;
                this.TerritoryNew.DataBind();
            }
            this.lbTerritory.Text = "(7) Territory ( "+dtTerritory.Rows.Count+" Hospitals)" ;
        }

        protected void Store_RefreshQuotaNew(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable dtQuotas = _contractBll.GetAopDealersByQueryByContractId(new Guid(this.hdContractID.Value.ToString())).Tables[0];
            if (dtQuotas.Rows.Count > 0)
            {
                this.QuotaNew.DataSource = dtQuotas;
                this.QuotaNew.DataBind();
            }
        }

        protected void Store_RefreshQuotaHospitalNew(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataTable dtQuotasHospital = _contractBll.GetAopDealersHospitalByQueryByContractId(new Guid(this.hdContractID.Value.ToString()), (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount).Tables[0];
            (this.QuotaHospitalNew.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            if (dtQuotasHospital.Rows.Count > 0)
            {
                this.QuotaHospitalNew.DataSource = dtQuotasHospital;
                this.QuotaHospitalNew.DataBind();
            }
        }

        protected void AreaStore_OnRefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!String.IsNullOrEmpty(this.hdContractID.Value.ToString()))
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hdContractID.Value.ToString()); //合同ID
                DataTable provinces = _contractBll.GetProvincesForAreaSelected(obj).Tables[0];
                AreaStore.DataSource = provinces;
                AreaStore.DataBind();
                if (provinces.Rows.Count > 0)
                {
                    this.PanelAreaHHosPital.Hidden = true;
                    this.PanelArea.Hidden = false;
                }
                else {
                    this.PanelArea.Hidden = true;
                    this.PanelAreaHHosPital.Hidden = false;
                }
            }
        }

        protected void ExcludeHospitalStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!String.IsNullOrEmpty(this.hdContractID.Value.ToString()))
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hdContractID.Value.ToString()); //合同ID

                DataSet query = _contractBll.GetPartAreaExcHospitalTemp(obj);
                this.ExcludeHospitalStore.DataSource = query;
                this.ExcludeHospitalStore.DataBind();
            }
        }

        protected void Store_RefreshQuotaHospitalProductNew(object sender, StoreRefreshDataEventArgs e)
        {
            RefreshData(e.Start, e.Limit);
        }

        private void RefreshData(int start, int limit)
        {
            int totalCount = 0;
            DataTable dtQuotasHospitalProduct = _contractBll.GetICAopDealersHospitalUnitByQuery(new Guid(this.hdContractID.Value.ToString()), (start == -1 ? 0 : start), (limit == -1 ? this.PagingToolBar1.PageSize : limit), out totalCount).Tables[0];
            (this.QuotaHospitalProductNew.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.QuotaHospitalProductNew.DataSource = dtQuotasHospitalProduct;
            this.QuotaHospitalProductNew.DataBind();
        }

        private void BindPageData() 
        {
            ContractAppointment ConApm = _appointment.GetContractAppointmentByID(new Guid(this.hdContractID.Value.ToString()));
            
            DataTable dtDivision = _contractBll.GetDivision(String.Empty).Tables[0];
            if (dtDivision.Rows.Count > 0) 
            {
                this.rgDivision.Items.Clear();
                for (int i = 0; i < dtDivision.Rows.Count; i++) 
                {
                    Radio rd = new Radio();
                    rd.ReadOnly = true;
                    rd.ID = "radioDivision" + dtDivision.Rows[i]["DivisionCode"].ToString();
                    rd.BoxLabel = dtDivision.Rows[i]["DivisionName"].ToString();
                    if (ConApm.CapDivision != null)
                    {
                        if (ConApm.CapDivision.ToLower().Equals(dtDivision.Rows[i]["DivisionName"].ToString().ToLower()))
                        {
                            rd.Checked = true;
                            this.radioProductLineAll.BoxLabel = "All products of " + dtDivision.Rows[i]["DivisionName"].ToString();
                            this.hdDivision.Value = dtDivision.Rows[i]["DivisionName"].ToString();
                            if (dtDivision.Rows[i]["DivisionName"].ToString().ToLower().Equals("cardio") || dtDivision.Rows[i]["DivisionName"].ToString().ToLower().Equals("sh") || (ConApm.CapMarketType != null && ConApm.CapMarketType.ToString().Equals("1")))
                            {
                                this.LabelQyotas.Text = "(8) Purchase Quotas By Dealer (CNY, exclude VAT),  " + SR.Const_ExchangeRate;
                                this.LabelQyotasForHosp.Text = "(9) Purchase Quotas By Hospital (CNY,exclude VAT),  " + SR.Const_ExchangeRate;
                                this.PanelQuotaHospitalProduct.Hidden = true;
                                this.PanelQuotaHospital.Hidden = false;
                            }
                            else 
                            {
                                this.PanelQuotaHospitalProduct.Hidden = true ;
                                this.PanelQuotaHospital.Hidden = false;
                            }
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
            this.laSubBU.Text = ConApm.CapSubdepName;
            this.hdDmaId.Text = ConApm.CapDmaId.ToString();
            hdCmID.Value = ConApm.CapCmId;
            tfRecommender.Text = ConApm.CapRecommender;
            tfJobTitle.Text = ConApm.CapJobTitle;
            tfCompanyNameEn.Text = ConApm.CapCompanyName;
            tfContactPerson.Text = ConApm.CapContactPerson;
            tfOfficeNumber.Text = ConApm.CapOfficeNumber;
            tfEmail.Text = ConApm.CapEmailAddress;
            tfMobile.Text = ConApm.CapMobilePhone;
            tfAddress.Text = ConApm.CapOfficeAddress;
            tfCompanyType.Text = ConApm.CapCompanyType;
            tfRegisteredCapital.Text = ConApm.CapRegisteredCapital;
            if (ConApm.CapEstablishedTime != null)
            {
                tfEstablishedTime.Text =Convert.ToDateTime(ConApm.CapEstablishedTime).ToShortDateString();
            }
            tfWebsite.Text = ConApm.CapWebsite;

            if (ConApm.CapBusinessLicense != null)
            {
                if (ConApm.CapBusinessLicense.Value == true)
                {
                    this.radioBusinessLicenseYes.Checked = true;
                }
                else
                {
                    this.radioBusinessLicenseNo.Checked = true;
                }
            }

            if (ConApm.CapMedicalLicense != null)
            {
                if (ConApm.CapMedicalLicense.Value)
                {
                    this.radioMedicalLicenseYes.Checked = true;
                }
                else
                {
                    this.radioMedicalLicenseNo.Checked = true;
                }
            }

            if (ConApm.CapTaxRegistration != null)
            {
                if (ConApm.CapTaxRegistration.Value)
                {
                    this.radioTaxCertificateYes.Checked = true;
                }
                else
                {
                    this.radioTaxCertificateNo.Checked = true;
                }
            }
            tbHealthcareExperience.Value = ConApm.CapHealthcareExperience;
            tbInterventionalExperience.Value = ConApm.CapInterventionalExperience;
            tbKolRelationships.Value = ConApm.CapKolRelationships;
            tbBusinessPartnerships.Value = ConApm.CapBusinessPartnerships;
            tbJustifications.Value = ConApm.CapCompetencyJustifications;
            if (ConApm.CapContractType != null)
            {
                if (ConApm.CapContractType.ToLower().Equals("distributor"))
                {
                    radioDistributor.Checked = true;
                }
                if (ConApm.CapContractType.ToLower().Equals("dealer"))
                {
                    radioDealer.Checked = true;
                }
                if (ConApm.CapContractType.ToLower().Equals("agent"))
                {
                    radioAgent.Checked = true;
                }
            }

            if (ConApm.CapBscEntity != null)
            {
                if (ConApm.CapBscEntity.ToLower().Equals("china"))
                {
                    radioChina.Checked = true;
                }
                if (ConApm.CapBscEntity.ToLower().Replace(" ", "").Equals("hongkong"))
                {
                    radioHongKong.Checked = true;
                }
                if (ConApm.CapBscEntity.ToLower().Equals("international"))
                {
                    radioInternational.Checked = true;
                }
            }

            if (ConApm.CapExclusiveness != null)
            {
                if (ConApm.CapExclusiveness.ToLower().Equals("exclusive"))
                {
                    radioExclusive.Checked = true;
                }
                if (ConApm.CapExclusiveness.ToLower().Equals("non-exclusive"))
                {
                    radioNonExclusive.Checked = true;
                }
            }

            if (ConApm.CapEffectiveDate != null) 
            {
                this.dfEffective.Value = Convert.ToDateTime(ConApm.CapEffectiveDate).ToShortDateString();
            }
            if (ConApm.CapExpirationDate != null)
            {
                this.dfExpiration.Value = Convert.ToDateTime(ConApm.CapExpirationDate).ToShortDateString();
            }
            //tfProductLine.Text = ConApm.CapProductLine;
            tfPricing.Text = ConApm.CapPricingDiscount;
            tfRebate.Text = ConApm.CapPricingRebate;
            tfDiscountRemarks.Text = ConApm.CapPricingDiscountRemark == null ? "" : ParseTags(ConApm.CapPricingDiscountRemark.Replace("&emsp;", "").Replace("<br/>", ""));
            tfRebateRemarks.Text = ConApm.CapPricingRebateRemark == null ? "" : ParseTags(ConApm.CapPricingRebateRemark.Replace("&emsp;", "").Replace("<br/>", ""));
            //tfTerritory.Text = ConApm.CapTerritory;
            //tfPurchaseQuotas.Text = ConApm.CapQuotas;
            tfSpecialSales.Text = ConApm.CapSpecialSales;

            tfPaymentTerm.Text = ConApm.CapPaymentTerm;
            tfCreditLimit.Text = ConApm.CapCreditLimit;
            tfSecurityDeposit.Text = ConApm.CapSecurityDeposit;
            if (ConApm.CapInterviewDate != null)
            {
                tfInterviewTime.Value = Convert.ToDateTime(ConApm.CapInterviewDate).ToShortDateString();
            }
            tfVenue.Text = ConApm.CapVenue;
            tfInterviewee.Text = ConApm.CapInterview;
            tfFindings.Text = ConApm.CapInterviewFindings;

            if (ConApm.CapNonCompete != null)
            {
                if (ConApm.CapNonCompete.Value)
                {
                    radioCompetingProductYes.Checked = true;
                }
                else
                {
                    radioCompetingProductNo.Checked = true;
                }
            }
            tfCompetingProduct.Text = ConApm.CapNonCompeteReason;

            if (ConApm.CapSubDealers != null)
            {
                if (ConApm.CapSubDealers.Value)
                {
                    radioSubDealerYes.Checked = true;
                }
                else
                {
                    radioSubDealerNo.Checked = true;
                }
            }
            if (ConApm.CapFcpaConcernsProperty1 != null)
            {
                if (ConApm.CapFcpaConcernsProperty1.Value)
                {
                    radioGovernmentOfficialsYes.Checked = true;
                }
                else
                {
                    radioGovernmentOfficialsNo.Checked = true;
                }
            }

            if (ConApm.CapFcpaConcernsProperty2 != null)
            {
                if (ConApm.CapFcpaConcernsProperty2.Value)
                {
                    radioCompanyGovernmentYes.Checked = true;
                }
                else
                {
                    radioCompanyGovernmentNo.Checked = true;
                }
            }

            if (ConApm.CapFcpaConcernsProperty3 != null)
            {
                if (ConApm.CapFcpaConcernsProperty3.Value)
                {
                    rgShareholdersGovernmentYes.Checked = true;
                }
                else
                {
                    rgShareholdersGovernmentNo.Checked = true;
                }
            }
            lbOthers.Text = ConApm.CapFcpaConcernsOther;

            if (ConApm.CapDealerConflict != null)
            {
                if (ConApm.CapDealerConflict.Value)
                {
                    radioConflictYes.Checked = true;
                }
                else
                {
                    radioConflictNo.Checked = true;
                }
            }
            tfConflict.Text=ConApm.CapDealerConflictReason;

            if (ConApm.CapExclusiveConflict != null)
            {
                if (ConApm.CapExclusiveConflict.Value)
                {
                    radioOtherExclusiveDealersYes.Checked = true;
                }
                else
                {
                    radioOtherExclusiveDealersNo.Checked = true;
                }
            }
            tbOtherExclusiveDealers.Text = ConApm.CapExclusiveConflictReason;

            //产品线
            if (!String.IsNullOrEmpty(ConApm.CapProductLine))
            {
                if (ConApm.CapProductLine.Equals("All"))
                {
                    this.radioProductLineAll.Checked = true;
                }
                else
                {
                    this.radioProductLinePartial.Checked = true;
                    this.ProductLineText.Text = ConApm.CapProductLine == null ? "" : ConApm.CapProductLine.Replace("&emsp;", "").Replace("<br/>", "");
                }
            }

            if (ConApm.CapCocTraningDate != null) 
            {
                this.dfTraningDate.Value = ConApm.CapCocTraningDate;
            }

            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation.ToString()) && ConApm.CapStatus != null && ConApm.CapStatus.Equals(ContractStatus.Completed.ToString()))
            {
                if (this.hdDealerType.Value.Equals(DealerType.T1.ToString()))
                {
                    this.btnAgreement.Hidden = false;
                }
            }
        }

        protected void ExportExcel(object sender, EventArgs e)
        {
            DataTable dt = this.GetHospitalList().Tables[0];//dt是从后台生成的要导出的datatable
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

        private DataSet GetHospitalList() 
        {
            DataSet ds = _contractBll.GetExcelTerritoryByContractId(new Guid(this.hdContractID.Value.ToString()));
            return ds;
        }

         public static string ParseTags(string HTMLStr)    
         {        
             return System.Text.RegularExpressions.Regex.Replace(HTMLStr, "<[^>]*>", "");    
         }


        #region Create Appendix_I File
        
        protected void CreatePdf(object sender, EventArgs e)
        {
            bool isArea = false;
            string fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
            string targetPath = Server.MapPath(PdfHelper.FILE_PATH + fileName);

            Document doc = new Document(iTextSharp.text.PageSize.A4, 36, 36, 12, 50);
            try
            {
                //注册中文字库
                PdfHelper.RegisterChineseFont();
                PdfHelper pdfFont = new PdfHelper();
                
                #region 根据合同ID获得合同信息
                ContractAppointment ConNew = _appointment.GetContractAppointmentByID(new Guid(this.hdContractID.Value.ToString()));
                #endregion

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
                PdfPCell titleCell = new PdfPCell(new Paragraph("BSC China & HK New Dealer Appointment Application Form", PdfHelper.boldFont));
                titleCell.HorizontalAlignment = Rectangle.ALIGN_LEFT;
                titleCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                titleCell.PaddingBottom = 9f;
                titleCell.FixedHeight = 65.5f;
                titleCell.Border = 0;
                titleTable.AddCell(titleCell);

                titleTable.AddCell(PdfHelper.GetBscLogoImageCell());

                //Logo
                //string imageSrc = Server.MapPath("\\Picture\\bsc1.png");
                //iTextSharp.text.Image image = iTextSharp.text.Image.GetInstance(imageSrc);
                //image.ScaleAbsolute(100.8f, 36.4f);//图片缩放

                //PdfPCell cellImage = new PdfPCell(image);
                //cellImage.Border = 0;
                //cellImage.PaddingBottom = 5f;
                //cellImage.PaddingRight = 5f;
                //cellImage.HorizontalAlignment = Rectangle.ALIGN_RIGHT;
                //cellImage.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                //titleTable.AddCell(cellImage);

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

                #region Section 1 - 5

                #region 副标题
                PdfPTable recTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(recTable);

                PdfPCell recCell = new PdfPCell(new Paragraph("For Recommender : Please Complete Section 1 - 5", PdfHelper.italicFont));
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
                divisionTable.SetWidths(new float[] { 19f, 4f, 6f, 4f, 5f, 4f, 5f, 4f, 5f, 4f, 4f, 4f, 4f,4f,7f,4f,5f,8f });
                PdfHelper.InitPdfTableProperty(divisionTable);

                //Division
                PdfHelper.AddPdfCell("1. Division (please tick):", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Cardio
                this.AddCheckBox(divisionTable, ConNew.CapDivision, DivisionName.Cardio.ToString());
                PdfHelper.AddPdfCell("Cardio", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //CRM
                this.AddCheckBox(divisionTable, ConNew.CapDivision, DivisionName.CRM.ToString());
                PdfHelper.AddPdfCell("CRM", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Endo
                this.AddCheckBox(divisionTable, ConNew.CapDivision, DivisionName.Endo.ToString());
                PdfHelper.AddPdfCell("Endo", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //EP
                this.AddCheckBox(divisionTable, ConNew.CapDivision, DivisionName.EP.ToString());
                PdfHelper.AddPdfCell("EP", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);


                //PI
                this.AddCheckBox(divisionTable, ConNew.CapDivision, DivisionName.PI.ToString());
                PdfHelper.AddPdfCell("PI", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Uro
                this.AddCheckBox(divisionTable, ConNew.CapDivision, DivisionName.Uro.ToString());
                PdfHelper.AddPdfCell("Uro", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Asthma
                this.AddCheckBox(divisionTable, ConNew.CapDivision, DivisionName.AS.ToString());
                PdfHelper.AddPdfCell("Asthma", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //SH
                this.AddCheckBox(divisionTable, ConNew.CapDivision, DivisionName.SH.ToString());
                PdfHelper.AddPdfCell("SH", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Empty
                PdfHelper.AddEmptyPdfCell(divisionTable);

                PdfHelper.AddPdfTable(doc, divisionTable);

                PdfPTable divisionRec_Table = new PdfPTable(5);
                PdfHelper.InitPdfTableProperty(divisionRec_Table);
                divisionRec_Table.SetWidths(new float[] { 20f, 25f, 20f, 25f, 10f });

                //Recommender
                PdfHelper.AddPdfCell("Recommender:", PdfHelper.normalFont, divisionRec_Table, null);
                //Recommender Answer
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapRecommender, PdfHelper.answerFont, divisionRec_Table, null); 

                //Job Title
                PdfHelper.AddPdfCell("Job Title:", PdfHelper.normalFont, divisionRec_Table, null);
                //Job Title Answer
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapJobTitle, PdfHelper.answerFont, divisionRec_Table, null);

                //Empty Cell
                PdfHelper.AddEmptyPdfCell(divisionRec_Table);

                PdfHelper.AddPdfTable(doc, divisionRec_Table);
                #endregion

                #region 2. Basic Information of the Dealer
                PdfPTable basicDealerInfoTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(basicDealerInfoTable);

                //Dealer Info Label
                PdfHelper.AddPdfCell("2. Basic Information of the Dealer Candidate Recommended (Please use Chinese for local dealers):",
                    PdfHelper.normalFont, basicDealerInfoTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, basicDealerInfoTable);

                #region Company Name
                //Company Name cn,en
                PdfPTable companyNameTable = new PdfPTable(4);
                companyNameTable.SetWidths(new float[] { 4f, 31f, 60f, 10f });
                PdfHelper.InitPdfTableProperty(companyNameTable);

                PdfHelper.AddEmptyPdfCell(companyNameTable);
                //Company Name (Chinese)
                PdfHelper.AddPdfCell("Company Name (Chinese):", PdfHelper.normalFont, companyNameTable, Rectangle.ALIGN_LEFT);
                //Company Name (Chinese) Answer
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapCompanyName, pdfFont.answerChineseFont, companyNameTable, null);
                PdfHelper.AddEmptyPdfCell(companyNameTable);

                string DealerEnName = "";
              
                DealerMaster masert = _dealerMasters.GetDealerMaster(ConNew.CapDmaId);
                DealerEnName = masert.EnglishName;
                
                PdfHelper.AddEmptyPdfCell(companyNameTable);
                //Company Name (English)
                PdfHelper.AddPdfCell("Company Name (English):", PdfHelper.normalFont, companyNameTable, Rectangle.ALIGN_LEFT);
                //Company Name (English) Answer
                PdfHelper.AddPdfCellWithUnderLine(DealerEnName, PdfHelper.answerFont, companyNameTable, null);
                PdfHelper.AddEmptyPdfCell(companyNameTable);

                PdfHelper.AddPdfTable(doc, companyNameTable);

                #endregion

                #region Company Info
                PdfPTable companyInfoTable = new PdfPTable(7);
                companyInfoTable.SetWidths(new float[] { 4f, 16f, 27f, 4f, 16f, 27f, 10f });
                PdfHelper.InitPdfTableProperty(companyInfoTable);

                //Contact Person
                PdfHelper.AddEmptyPdfCell(companyInfoTable);
                PdfHelper.AddPdfCell("Contact Person:", PdfHelper.normalFont, companyInfoTable, Rectangle.ALIGN_LEFT);
                //Contact Person Answer
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapContactPerson, pdfFont.answerChineseFont, companyInfoTable, null);
                //Email Address
                PdfHelper.AddEmptyPdfCell(companyInfoTable);
                PdfHelper.AddPdfCell("Email Address:", PdfHelper.normalFont, companyInfoTable, Rectangle.ALIGN_LEFT);
                //Email Address Answer
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapEmailAddress, PdfHelper.answerFont, companyInfoTable, null);
                //Empty Cell
                PdfHelper.AddEmptyPdfCell(companyInfoTable);

                //Office Number
                PdfHelper.AddEmptyPdfCell(companyInfoTable);
                PdfHelper.AddPdfCell("Office Number:", PdfHelper.normalFont, companyInfoTable, Rectangle.ALIGN_LEFT);
                //Office Number Answer
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapOfficeNumber, PdfHelper.answerFont, companyInfoTable, null);
                //Mobile Phone
                PdfHelper.AddEmptyPdfCell(companyInfoTable);
                PdfHelper.AddPdfCell("Mobile Phone:", PdfHelper.normalFont, companyInfoTable, Rectangle.ALIGN_LEFT);
                //Mobile Phone Answer
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapMobilePhone, PdfHelper.answerFont, companyInfoTable, null);
                //Empty Cell
                PdfHelper.AddEmptyPdfCell(companyInfoTable);

                //Company Type
                PdfHelper.AddEmptyPdfCell(companyInfoTable);
                PdfHelper.AddPdfCell("Company Type:", PdfHelper.normalFont, companyInfoTable, Rectangle.ALIGN_LEFT);
                //Company Type Answer
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapCompanyType, pdfFont.answerChineseFont, companyInfoTable, null);
                //Established Time
                PdfHelper.AddEmptyPdfCell(companyInfoTable);
                PdfHelper.AddPdfCell("Established Time:", PdfHelper.normalFont, companyInfoTable, Rectangle.ALIGN_LEFT);
                //Established Time Answer
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConNew.CapEstablishedTime, null), PdfHelper.answerFont, companyInfoTable, null);
                //Empty Cell
                PdfHelper.AddEmptyPdfCell(companyInfoTable);

                //Registered Capital
                PdfHelper.AddEmptyPdfCell(companyInfoTable);
                PdfHelper.AddPdfCell("Registered Capital:", PdfHelper.normalFont, companyInfoTable, Rectangle.ALIGN_LEFT);
                //Company Type Answer
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapRegisteredCapital, PdfHelper.answerFont, companyInfoTable, null);
                //Website
                PdfHelper.AddEmptyPdfCell(companyInfoTable);
                PdfHelper.AddPdfCell("Website:", PdfHelper.normalFont, companyInfoTable, Rectangle.ALIGN_LEFT);
                //Website Answer
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapWebsite, PdfHelper.normalFont, companyInfoTable, null);
                //Empty Cell
                PdfHelper.AddEmptyPdfCell(companyInfoTable);

                PdfHelper.AddPdfTable(doc, companyInfoTable);
                #endregion

                #region Company Address
                //Company Address
                PdfPTable companyAddressTable = new PdfPTable(4);
                companyAddressTable.SetWidths(new float[] { 4f, 16f, 75f, 10f });
                PdfHelper.InitPdfTableProperty(companyAddressTable);

                //Company Address 
                PdfHelper.AddEmptyPdfCell(companyAddressTable);
                PdfHelper.AddPdfCell("Address:", PdfHelper.normalFont, companyAddressTable, null);
                //Company Address Answer
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapOfficeAddress, pdfFont.answerChineseFont, companyAddressTable, null);
                PdfHelper.AddEmptyPdfCell(companyAddressTable);

                PdfHelper.AddPdfTable(doc, companyAddressTable);
                #endregion
                #endregion

                #region 3. Supporting Documents
                PdfPTable supportDocTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(supportDocTable);

                //Supporting Documents Label
                PdfHelper.AddPdfCell("3. Supporting Documents:",
                    PdfHelper.normalFont, supportDocTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, supportDocTable);

                PdfPTable busLicTable = new PdfPTable(8);
                busLicTable.SetWidths(new float[] { 4f, 35f, 11f, 5f, 15f, 5f, 15f, 10f });
                PdfHelper.InitPdfTableProperty(busLicTable);

                //Business License
                PdfHelper.AddEmptyPdfCell(busLicTable);
                PdfHelper.AddPdfCell("(1) Business License:", PdfHelper.normalFont, busLicTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(busLicTable);

                //Yes
                this.AddCheckBox(busLicTable, ConNew.CapBusinessLicense);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, busLicTable, Rectangle.ALIGN_LEFT);
                //No
                this.AddCheckBox(busLicTable, !ConNew.CapBusinessLicense);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, busLicTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(busLicTable);

                PdfHelper.AddRemarkPdfCell("(Please do NOT go ahead with the recommendation if the dealer does not pass the annual inspection of local AIC)",
                    PdfHelper.descFont, busLicTable, 8);

                //Medical Device License
                PdfHelper.AddEmptyPdfCell(busLicTable);
                PdfHelper.AddPdfCell("(2) Medical Device License:", PdfHelper.normalFont, busLicTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(busLicTable);

                //Yes
                this.AddCheckBox(busLicTable, ConNew.CapMedicalLicense);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, busLicTable, Rectangle.ALIGN_LEFT);
                //No
                this.AddCheckBox(busLicTable, !ConNew.CapMedicalLicense);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, busLicTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(busLicTable);

                PdfHelper.AddRemarkPdfCell("(Please do NOT go ahead with the recommendation if the license does not cover the SFDA categories of BSC products)",
                    PdfHelper.descFont, busLicTable, 8);

                //Tax Registration Certificate
                PdfHelper.AddEmptyPdfCell(busLicTable);
                PdfHelper.AddPdfCell("(3) Tax Registration Certificate:", PdfHelper.normalFont, busLicTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(busLicTable);

                //Yes
                this.AddCheckBox(busLicTable, ConNew.CapTaxRegistration);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, busLicTable, Rectangle.ALIGN_LEFT);
                //No
                this.AddCheckBox(busLicTable, !ConNew.CapTaxRegistration);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, busLicTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(busLicTable);

                PdfHelper.AddRemarkPdfCell("(Please do NOT go ahead with the recommendation if the dealer does not pass the annual inspection of local Tax Bureau)",
                    PdfHelper.descFont, busLicTable, 8);

                PdfHelper.AddPdfTable(doc, busLicTable);
                #endregion

                #region 4. Sales & Marketing Competency
                PdfPTable smComLabelTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(smComLabelTable);

                //Sales & Marketing Competency Label
                PdfHelper.AddPdfCell("4. Sales & Marketing Competency:",
                    PdfHelper.normalFont, smComLabelTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, smComLabelTable);

                //Sales & Marketing Competency Content
                PdfPTable smComTable = new PdfPTable(4);
                smComTable.SetWidths(new float[] { 4f, 50f, 36f, 10f });
                PdfHelper.InitPdfTableProperty(smComTable);

                //(1) Healthcare Industry Experience (years)
                PdfHelper.AddEmptyPdfCell(smComTable);
                PdfHelper.AddPdfCell("(1) Healthcare Industry Experience (years):", PdfHelper.normalFont, smComTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine((ConNew.CapHealthcareExperience == null ? "" : ConNew.CapHealthcareExperience.ToString()), PdfHelper.answerFont, smComTable, null);
                PdfHelper.AddEmptyPdfCell(smComTable);

                //(2) Interventional Experience (years)
                PdfHelper.AddEmptyPdfCell(smComTable);
                PdfHelper.AddPdfCell("(2) Interventional Experience (years):", PdfHelper.normalFont, smComTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapInterventionalExperience == null ? "" : ConNew.CapInterventionalExperience.ToString(), PdfHelper.answerFont, smComTable, null);
                PdfHelper.AddEmptyPdfCell(smComTable);

                //(3) KOL Relationships (years)
                PdfHelper.AddEmptyPdfCell(smComTable);
                PdfHelper.AddPdfCell("(3) KOL Relationships (years):", PdfHelper.normalFont, smComTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapKolRelationships == null ? "" : ConNew.CapKolRelationships.ToString(), PdfHelper.answerFont, smComTable, null);
                PdfHelper.AddEmptyPdfCell(smComTable);

                //(4) Business Partnerships (MNC Principals)
                PdfHelper.AddEmptyPdfCell(smComTable);
                PdfHelper.AddPdfCell("(4) Business Partnerships (MNC Principals):", PdfHelper.normalFont, smComTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapBusinessPartnerships, pdfFont.answerChineseFont, smComTable, null);
                PdfHelper.AddEmptyPdfCell(smComTable);

                //
                PdfHelper.AddEmptyPdfCell(smComTable);
                PdfHelper.AddRemarkPdfCell("If dealer candidates possess none of above competencies, please provide justifications below:", PdfHelper.normalFont, smComTable, 2);
                PdfHelper.AddEmptyPdfCell(smComTable);

                PdfHelper.AddPdfTable(doc, smComTable);

                //Justifications
                PdfPTable smJustTable = new PdfPTable(4);
                smJustTable.SetWidths(new float[] { 17f, 15f, 58f, 10f });
                PdfHelper.InitPdfTableProperty(smJustTable);
                PdfHelper.AddEmptyPdfCell(smJustTable);
                PdfHelper.AddPdfCell("Justifications:", PdfHelper.normalFont, smJustTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapCompetencyJustifications, PdfHelper.answerFont, smJustTable, null);
                PdfHelper.AddEmptyPdfCell(smJustTable);

                PdfHelper.AddPdfTable(doc, smJustTable);


                #endregion

                #region 5. Preliminary Business Proposals

                PdfPTable pbpTable = new PdfPTable(9);
                pbpTable.SetWidths(new float[] { 4f, 20f, 5f, 17f, 5f, 17f, 5f, 17f, 10f });
                PdfHelper.InitPdfTableProperty(pbpTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("5. Preliminary Business Proposals:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 9 }, pbpTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                //(1) Contract Type
                PdfHelper.AddEmptyPdfCell(pbpTable);
                PdfHelper.AddPdfCell("(1) Contract Type:", PdfHelper.normalFont, pbpTable, Rectangle.ALIGN_LEFT);

                //Distributor
                this.AddCheckBox(pbpTable, ConNew.CapContractType, ContractDealerType.Distributor.ToString());
                PdfHelper.AddPdfCell("Distributor", PdfHelper.normalFont, pbpTable, Rectangle.ALIGN_LEFT);
                //Dealer
                this.AddCheckBox(pbpTable, ConNew.CapContractType, ContractDealerType.Dealer.ToString());
                PdfHelper.AddPdfCell("Dealer", PdfHelper.normalFont, pbpTable, Rectangle.ALIGN_LEFT);
                //Agent
                this.AddCheckBox(pbpTable, ConNew.CapContractType, ContractDealerType.Agent.ToString());
                PdfHelper.AddPdfCell("Agent", PdfHelper.normalFont, pbpTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(pbpTable);

                //(2) BSC Entity
                PdfHelper.AddEmptyPdfCell(pbpTable);
                PdfHelper.AddPdfCell("(2) BSC Entity:", PdfHelper.normalFont, pbpTable, Rectangle.ALIGN_LEFT);

                //China
                this.AddCheckBox(pbpTable, ConNew.CapBscEntity, BSCEntity.China.ToString());
                PdfHelper.AddPdfCell("China", PdfHelper.normalFont, pbpTable, Rectangle.ALIGN_LEFT);
                //Hong Kong
                this.AddCheckBox(pbpTable, ConNew.CapBscEntity, BSCEntity.Hong_Kong.ToString().Replace("_", " "));
                PdfHelper.AddPdfCell("Hong Kong", PdfHelper.normalFont, pbpTable, Rectangle.ALIGN_LEFT);
                //International
                this.AddCheckBox(pbpTable, ConNew.CapBscEntity, BSCEntity.International.ToString());
                PdfHelper.AddPdfCell("International", PdfHelper.normalFont, pbpTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(pbpTable);

                //(3) Exclusiveness
                PdfHelper.AddEmptyPdfCell(pbpTable);
                PdfHelper.AddPdfCell("(3) Exclusiveness:", PdfHelper.normalFont, pbpTable, Rectangle.ALIGN_LEFT);

                //Exclusive
                this.AddCheckBox(pbpTable, ConNew.CapExclusiveness, Exclusiveness.Exclusive.ToString());
                PdfHelper.AddPdfCell("Exclusive", PdfHelper.normalFont, pbpTable, Rectangle.ALIGN_LEFT);
                //Non-Exclusive
                this.AddCheckBox(pbpTable, ConNew.CapExclusiveness, Exclusiveness.Non_Exclusive.ToString().Replace("_", "-"));
                PdfHelper.AddPdfCell("Non-Exclusive", PdfHelper.normalFont, pbpTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(pbpTable);
                PdfHelper.AddEmptyPdfCell(pbpTable);
                PdfHelper.AddEmptyPdfCell(pbpTable);

                PdfHelper.AddPdfTable(doc, pbpTable);

                //(4) Agreement Term:
                PdfPTable agreementTermTable = new PdfPTable(7);
                agreementTermTable.SetWidths(new float[] { 4f, 20f, 17f, 16f, 17f, 16f, 10f });
                PdfHelper.InitPdfTableProperty(agreementTermTable);

                PdfHelper.AddEmptyPdfCell(agreementTermTable);
                PdfHelper.AddPdfCell("(4) Agreement Term:", PdfHelper.normalFont, agreementTermTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell("Effective Date:", PdfHelper.normalFont, agreementTermTable, Rectangle.ALIGN_RIGHT);
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConNew.CapEffectiveDate,null), PdfHelper.answerFont, agreementTermTable, null);

                PdfHelper.AddPdfCell("Expiration Date:", PdfHelper.normalFont, agreementTermTable, Rectangle.ALIGN_RIGHT);
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConNew.CapExpirationDate, null), PdfHelper.answerFont, agreementTermTable, null);
                PdfHelper.AddEmptyPdfCell(agreementTermTable);

                PdfHelper.AddPdfTable(doc, agreementTermTable);

                //(5) Product Line (if partial, please list):
                PdfPTable productLineTable = new PdfPTable(6);
                productLineTable.SetWidths(new float[] { 4f, 32f, 5f, 20f, 29f, 10f });
                PdfHelper.InitPdfTableProperty(productLineTable);

                //All Product
                PdfHelper.AddEmptyPdfCell(productLineTable);
                PdfHelper.AddPdfCell("(5) Product Line (if partial, please list):", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                if (radioProductLineAll.Checked)
                {
                    PdfHelper.AddImageCell(SelectCell, productLineTable);
                }
                else 
                {
                    PdfHelper.AddImageCell(noSelectCell, productLineTable);
                }
                
                PdfHelper.AddPdfCell(this.radioProductLineAll.BoxLabel.ToString(), PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(productLineTable);
                PdfHelper.AddEmptyPdfCell(productLineTable);

                //Partial
                PdfHelper.AddEmptyPdfCell(productLineTable);
                PdfHelper.AddEmptyPdfCell(productLineTable);
                if (radioProductLinePartial.Checked)
                {
                    PdfHelper.AddImageCell(SelectCell, productLineTable);
                }
                else
                {
                    PdfHelper.AddImageCell(noSelectCell, productLineTable);
                }
                
                PdfHelper.AddPdfCell("Partial", PdfHelper.normalFont, productLineTable, Rectangle.ALIGN_LEFT);
                if (radioProductLinePartial.Checked)
                {
                    PdfHelper.AddPdfCellWithUnderLine(this.ProductLineText.Text, pdfFont.answerChineseFont, productLineTable, null);
                }
                else 
                {
                    PdfHelper.AddPdfCellWithUnderLine("", pdfFont.answerChineseFont, productLineTable, null);
                }
                PdfHelper.AddEmptyPdfCell(productLineTable);

                PdfHelper.AddPdfTable(doc, productLineTable);

                //(6) Pricing:
                PdfPTable pricingTable = new PdfPTable(7);
                pricingTable.SetWidths(new float[] { 4f, 15f, 10f, 10f, 10f, 41f, 10f });
                PdfHelper.InitPdfTableProperty(pricingTable);

                //Discount
                PdfHelper.AddEmptyPdfCell(pricingTable);
                PdfHelper.AddPdfCell("(6) Pricing:", PdfHelper.normalFont, pricingTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(pricingTable);
                PdfHelper.AddPdfCell("Discount:", PdfHelper.normalFont, pricingTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapPricingDiscount == null ? "" : ConNew.CapPricingDiscount.Replace("&emsp;", "").Replace("<br/>", ""), pdfFont.answerChineseFont, pricingTable, null);
                PdfHelper.AddPdfCell("% off standard price list.", PdfHelper.normalFont, pricingTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(pricingTable);

                //Remark
                PdfHelper.AddEmptyPdfCell(pricingTable);
                PdfHelper.AddEmptyPdfCell(pricingTable);
                PdfHelper.AddEmptyPdfCell(pricingTable);
                PdfHelper.AddEmptyPdfCell(pricingTable);
                PdfHelper.AddPdfCell("Remark:", PdfHelper.normalFont, pricingTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapPricingDiscountRemark == null ? "" : ParseTags(ConNew.CapPricingDiscountRemark.Replace("&emsp;", "").Replace("<br/>", "")), pdfFont.answerChineseFont, pricingTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(pricingTable);

                //Rebate
                PdfHelper.AddEmptyPdfCell(pricingTable);
                PdfHelper.AddEmptyPdfCell(pricingTable);
                PdfHelper.AddEmptyPdfCell(pricingTable);
                PdfHelper.AddPdfCell("Rebate:", PdfHelper.normalFont, pricingTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapPricingRebate, PdfHelper.answerFont, pricingTable, null);
                PdfHelper.AddPdfCell("% of the quarter purchase ammount.", PdfHelper.normalFont, pricingTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(pricingTable);

                //Remark
                PdfHelper.AddEmptyPdfCell(pricingTable);
                PdfHelper.AddEmptyPdfCell(pricingTable);
                PdfHelper.AddEmptyPdfCell(pricingTable);
                PdfHelper.AddEmptyPdfCell(pricingTable);
                PdfHelper.AddPdfCell("Remark:", PdfHelper.normalFont, pricingTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapPricingRebateRemark == null ? "" : ParseTags(ConNew.CapPricingRebateRemark.Replace("&emsp;", "").Replace("<br/>", "")), pdfFont.answerChineseFont, pricingTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(pricingTable);

                PdfHelper.AddPdfTable(doc, pricingTable);

                PdfPTable territoryTable = new PdfPTable(4);
                territoryTable.SetWidths(new float[] { 4f, 26f, 60f, 10f });
                PdfHelper.InitPdfTableProperty(territoryTable);

                //(7) Territory:
                DataTable dtTerritorynew = _contractBll.GetContractTerritoryByContractId(new Guid(this.hdContractID.Value.ToString())).Tables[0];
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hdContractID.Value.ToString()); //合同ID
                DataTable provinces = _contractBll.GetProvincesForAreaSelected(obj).Tables[0];

                string countHps = "";
                if (provinces.Rows.Count > 0)
                {
                    for (int i = 0; i < provinces.Rows.Count; i++) 
                    {
                        countHps += (provinces.Rows[i]["Description"].ToString() + ",");
                    }
                    isArea = true;
                }
                else
                {
                    System.Data.DataView dataView = dtTerritorynew.DefaultView;
                    DataTable dataTableDistinct = dataView.ToTable(true, "HospitalName");

                    countHps = dataTableDistinct.Rows.Count.ToString() + "  hospitals.";
                }
                PdfHelper.AddEmptyPdfCell(territoryTable);
                PdfHelper.AddPdfCell("(7) Territory:", PdfHelper.normalFont, territoryTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(countHps, pdfFont.answerChineseFont, territoryTable, null);
                PdfHelper.AddEmptyPdfCell(territoryTable);

                //(8) Purchase Quotas:
                string valueString = "";

                #region 非IC合同(2016年IC合同和普通合同指标设置一致)
                DataTable dtQuotasnew = _contractBll.GetAopDealersByQueryByContractId(new Guid(this.hdContractID.Value.ToString())).Tables[0];
                decimal Q1 = 0;
                decimal Q2 = 0;
                decimal Q3 = 0;
                decimal Q4 = 0;
                decimal total = 0;
                string Year = "";
                int mark = 0;
                for (int i = 0; i < dtQuotasnew.Rows.Count; i++)
                {
                    if (!Year.Equals(dtQuotasnew.Rows[i]["Year"].ToString()))
                    {
                        if (mark == 1)
                        {
                            valueString = dtQuotasnew.Rows[i - 1]["Year"].ToString() + ":    Q1: " + base.GetStringByDecimal(Q1) + ";  Q2: " + base.GetStringByDecimal(Q2) + ";  Q3: " + base.GetStringByDecimal(Q3) + ";  Q4: " + base.GetStringByDecimal(Q4) + ";   Total: " + base.GetStringByDecimal(total) + "\r\n";
                        }
                        else
                        {
                            mark = 1;
                        }
                        Q1 = 0;
                        Q2 = 0;
                        Q3 = 0;
                        Q4 = 0;
                        total = Q1 + Q2 + Q3 + Q4;
                    }
                    Year = dtQuotasnew.Rows[i]["Year"].ToString();

                    Q1 += Convert.ToDecimal(dtQuotasnew.Rows[i]["Q1"].ToString());
                    Q2 += Convert.ToDecimal(dtQuotasnew.Rows[i]["Q2"].ToString());
                    Q3 += Convert.ToDecimal(dtQuotasnew.Rows[i]["Q3"].ToString());
                    Q4 += Convert.ToDecimal(dtQuotasnew.Rows[i]["Q4"].ToString());
                }

                if (dtQuotasnew.Rows.Count > 0)
                {
                    valueString += dtQuotasnew.Rows[dtQuotasnew.Rows.Count - 1]["Year"].ToString() + ":    Q1: " + base.GetStringByDecimal(Q1) + ";  Q2: " + base.GetStringByDecimal(Q2) + ";  Q3: " + base.GetStringByDecimal(Q3) + ";  Q4: " + base.GetStringByDecimal(Q4) + ";  Total: " + base.GetStringByDecimal(Q1 + Q2 + Q3 + Q4);
                }
                #endregion

               
                if (!valueString.Equals("")) 
                {
                    valueString += "\r\n(by CNY .BSC SFX Rate:USD 1=CNY 6.15)";
                }


                PdfHelper.AddEmptyPdfCell(territoryTable);
                PdfHelper.AddPdfCell(this.LabelQyotas.Text, PdfHelper.normalFont, territoryTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(valueString, PdfHelper.answerFont, territoryTable, null);
                PdfHelper.AddEmptyPdfCell(territoryTable);

                ////(9) Payment Term:
                //PdfHelper.AddEmptyPdfCell(territoryTable);
                //PdfHelper.AddPdfCell("(9) Special Sales Programs:", PdfHelper.normalFont, territoryTable, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddPdfCellWithUnderLine(ConNew.CapSpecialSales, PdfHelper.answerFont, territoryTable, null);
                //PdfHelper.AddEmptyPdfCell(territoryTable);

                //(10) Payment Term:
                string paymentTerm="";
                if (ConNew.CapPaymentTerm != null)
                {
                    if (ConNew.CapPaymentTerm.ToLower().Equals("credit"))
                    {
                        string securityDeposit = "";
                        if (String.IsNullOrEmpty(ConNew.CapSecurityDeposit))
                        {
                            securityDeposit = "NA";
                        }
                        else
                        {
                            securityDeposit = base.GetStringByDecimal(Convert.ToDecimal(ConNew.CapSecurityDeposit));
                        }
                        string guaranteeRemark = "";
                        if (String.IsNullOrEmpty(ConNew.CapGuaranteeRemark))
                        {
                            guaranteeRemark = "NA";
                        }
                        else
                        {
                            guaranteeRemark = ConNew.CapGuaranteeRemark;
                        }
                        paymentTerm = @"Credit Term:" + ConNew.CapAccount + "days;Credit Limit:RMB" + base.GetStringByDecimal(Convert.ToDecimal(ConNew.CapCreditLimit)) + " (include VAT); Security Deposit: " + securityDeposit + "; in form of:" + guaranteeRemark;
                    }
                    else 
                    {
                        paymentTerm = ConNew.CapPaymentTerm;
                    }
                }
                PdfHelper.AddEmptyPdfCell(territoryTable);
                PdfHelper.AddPdfCell("(9) Payment Term:", PdfHelper.normalFont, territoryTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(paymentTerm, PdfHelper.answerFont, territoryTable, null);
                PdfHelper.AddEmptyPdfCell(territoryTable);

                //(11) Credit Limit:
                //PdfHelper.AddEmptyPdfCell(territoryTable);
                //PdfHelper.AddPdfCell("(10) Credit Limit:", PdfHelper.normalFont, territoryTable, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddPdfCellWithUnderLine(ConNew.CapCreditLimit, PdfHelper.answerFont, territoryTable, null);
                //PdfHelper.AddEmptyPdfCell(territoryTable);

                //(12) Security Deposit:
                //PdfHelper.AddEmptyPdfCell(territoryTable);
                //PdfHelper.AddPdfCell("(11) Security Deposit:", PdfHelper.normalFont, territoryTable, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddPdfCellWithUnderLine(ConNew.CapSecurityDeposit, PdfHelper.answerFont, territoryTable, null);
                //PdfHelper.AddEmptyPdfCell(territoryTable);

                PdfHelper.AddPdfTable(doc, territoryTable);

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
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapRsmPrintName, PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
             
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConNew.CapRsmDate, null), PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);

                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("NCM:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapNcmPrintName, PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
              
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConNew.CapNcmDate, null), PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);

                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("BUM / NSM:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapNsmPrintName, PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
              
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConNew.CapNsmDate, null), PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);

                PdfHelper.AddPdfTable(doc, sdmApprovalTable);

                #endregion

                #endregion

                #region Section 6- 13

                #region 副标题
                PdfPTable forNcmTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(forNcmTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f }, forNcmTable, null, null);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("For National Channel Manager: Please Complete Section 6- 13", PdfHelper.italicFont)) { FixedHeight = 17f, PaddingTop = 1f, BackgroundColor = BaseColor.PINK },
                    forNcmTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                PdfHelper.AddPdfTable(doc, forNcmTable);

                #endregion

                //#region 6. Credit & Background Check
                //PdfPTable creditCheckTable = new PdfPTable(6);
                //creditCheckTable.SetWidths(new float[] { 4f, 20f, 23f, 20f, 23f, 10f });
                //PdfHelper.InitPdfTableProperty(creditCheckTable);

                ////6. Credit & Background Check
                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { Colspan = 6, FixedHeight = 10f, PaddingBottom = 6f }, creditCheckTable, null, null);
                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("6. Credit & Background Check:", PdfHelper.normalFont)) { Colspan = 6 },
                //    creditCheckTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                //PdfHelper.AddEmptyPdfCell(creditCheckTable);
                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Risk Rating:", PdfHelper.normalFont)) { PaddingLeft = 20f, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                //    creditCheckTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                //PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.answerFont, creditCheckTable, null, null);
                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("D&B Rating:", PdfHelper.normalFont)) { PaddingLeft = 20f, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                //    creditCheckTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                //PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.answerFont, creditCheckTable, null, null);
                //PdfHelper.AddEmptyPdfCell(creditCheckTable);

                //PdfHelper.AddEmptyPdfCell(creditCheckTable);
                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If Risk Rating is 9 or 10, please provide justifications below:", PdfHelper.descFont)) { Colspan = 4, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                //    creditCheckTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                //PdfHelper.AddEmptyPdfCell(creditCheckTable);

                //PdfHelper.AddEmptyPdfCell(creditCheckTable);
                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Justifications:", PdfHelper.normalFont)) { PaddingLeft = 20f, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                //    creditCheckTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                //PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("", PdfHelper.answerFont)) { Colspan = 3 }, creditCheckTable, null, null);
                //PdfHelper.AddEmptyPdfCell(creditCheckTable);

                //PdfHelper.AddPdfTable(doc, creditCheckTable);
                //#endregion

                #region 6. Independent Interview & Site Check:
                PdfPTable interviewTable = new PdfPTable(8);
                interviewTable.SetWidths(new float[] { 4f, 19f, 15f, 10f, 15f, 12f, 15f, 10f });
                PdfHelper.InitPdfTableProperty(interviewTable);

                //6. Independent Interview & Site Check:
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("6. Independent Interview & Site Check:", PdfHelper.normalFont)) { Colspan = 8, FixedHeight = 25f },
                    interviewTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddEmptyPdfCell(interviewTable);
                PdfHelper.AddPdfCell("Time of Interview:", PdfHelper.normalFont, interviewTable, null);
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConNew.CapInterviewDate, null), PdfHelper.answerFont, interviewTable, null, null);
                PdfHelper.AddPdfCell("Venue:", PdfHelper.normalFont, interviewTable, null);
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapVenue, PdfHelper.answerFont, interviewTable, null, null);
                PdfHelper.AddPdfCell("Interviewee:", PdfHelper.normalFont, interviewTable, null);
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapInterview, PdfHelper.answerFont, interviewTable, null, null);
                PdfHelper.AddEmptyPdfCell(interviewTable);

                PdfHelper.AddEmptyPdfCell(interviewTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If there are any particular findings during the interview and site check, please list here:", PdfHelper.descFont)) { Colspan = 6, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, PaddingBottom = 5f },
                    interviewTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(interviewTable);

                PdfHelper.AddEmptyPdfCell(interviewTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Findings:", PdfHelper.normalFont)) { PaddingLeft = 20f, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    interviewTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConNew.CapInterviewFindings, pdfFont.answerChineseFont)) { Colspan = 5 }, interviewTable, null, null);
                PdfHelper.AddEmptyPdfCell(interviewTable);

                PdfHelper.AddPdfTable(doc, interviewTable);
                #endregion

                #region 7. COC/Quality Traning:
                PdfPTable cocTable = new PdfPTable(5);
                cocTable.SetWidths(new float[] { 4f, 30f, 20f, 36f, 10f });
                PdfHelper.InitPdfTableProperty(cocTable);

                //7. COC/Quality Traning
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("7. COC/Quality Traning:", PdfHelper.normalFont)) { Colspan = 5, FixedHeight = 25f },
                    cocTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddEmptyPdfCell(cocTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("COC/Quality Traning Date:", PdfHelper.normalFont)) { PaddingLeft = 20f, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    cocTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConNew.CapCocTraningDate, null), PdfHelper.answerFont, cocTable, null, null);
                PdfHelper.AddEmptyPdfCell(cocTable);
                PdfHelper.AddEmptyPdfCell(cocTable);

                PdfHelper.AddPdfTable(doc, cocTable);
                #endregion

                #region 8. Non-Compete Requirement:
                PdfPTable nonCompeteTable = new PdfPTable(8);
                nonCompeteTable.SetWidths(new float[] { 4f, 20f, 42f, 5f, 7f, 5f, 7f, 10f });
                PdfHelper.InitPdfTableProperty(nonCompeteTable);

                //8. Non-Compete Requirement
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("8. Non-Compete Requirement:", PdfHelper.normalFont)) { Colspan = 8, FixedHeight = 25f },
                    nonCompeteTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddEmptyPdfCell(nonCompeteTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Does the dealer represent a competing product line with BSC currently?", PdfHelper.normalFont)) { Colspan = 2, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    nonCompeteTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                this.AddCheckBox(nonCompeteTable, ConNew.CapNonCompete);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, nonCompeteTable, Rectangle.ALIGN_LEFT);
                this.AddCheckBox(nonCompeteTable, !ConNew.CapNonCompete);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, nonCompeteTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(nonCompeteTable);

                PdfHelper.AddEmptyPdfCell(nonCompeteTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If yes, please state here:", PdfHelper.descFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, PaddingBottom = 5f },
                    nonCompeteTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConNew.CapNonCompeteReason, pdfFont.answerChineseFont)) { Colspan = 5 },
                    nonCompeteTable, null, null);
                PdfHelper.AddEmptyPdfCell(nonCompeteTable);

                PdfHelper.AddEmptyPdfCell(nonCompeteTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(If yes, please ask the dealer to provide a Non-Compete Commitment before appointment process)", PdfHelper.descFont)) { Colspan = 6, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    nonCompeteTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(nonCompeteTable);

                PdfHelper.AddPdfTable(doc, nonCompeteTable);
                #endregion

                #region 9. Sub-Dealers:
                PdfPTable subDealerTable = new PdfPTable(7);
                subDealerTable.SetWidths(new float[] { 4f, 62f, 5f, 7f, 5f, 7f, 10f });
                PdfHelper.InitPdfTableProperty(subDealerTable);

                //9. Sub-Dealers
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("9. Sub-Dealers:", PdfHelper.normalFont)) { Colspan = 7, FixedHeight = 25f },
                    subDealerTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddEmptyPdfCell(subDealerTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Does the dealer have sub-dealers currently?", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    subDealerTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                this.AddCheckBox(subDealerTable, ConNew.CapSubDealers);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, subDealerTable, Rectangle.ALIGN_LEFT);
                this.AddCheckBox(subDealerTable, !ConNew.CapSubDealers);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, subDealerTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(subDealerTable);

                PdfHelper.AddEmptyPdfCell(subDealerTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(If yes, please inform the dealer that our agreement does not allow sub-dealers without BSC prior authorizations )", PdfHelper.descFont)) { Colspan = 5, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    subDealerTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(subDealerTable);

                PdfHelper.AddPdfTable(doc, subDealerTable);
                #endregion

                #region 10. FCPA Concerns:
                PdfPTable fcpaConcernTable = new PdfPTable(8);
                fcpaConcernTable.SetWidths(new float[] { 4f, 30f, 32f, 5f, 7f, 5f, 7f, 10f });
                PdfHelper.InitPdfTableProperty(fcpaConcernTable);

                //10. FCPA Concerns:
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("10. FCPA Concerns:", PdfHelper.normalFont)) { Colspan = 8, FixedHeight = 25f },
                    fcpaConcernTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddEmptyPdfCell(fcpaConcernTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(1) Recommended by Government Officials ?", PdfHelper.normalFont)) { Colspan = 2, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    fcpaConcernTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                this.AddCheckBox(fcpaConcernTable, ConNew.CapFcpaConcernsProperty1);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, fcpaConcernTable, Rectangle.ALIGN_LEFT);
                this.AddCheckBox(fcpaConcernTable, !ConNew.CapFcpaConcernsProperty1);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, fcpaConcernTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(fcpaConcernTable);

                PdfHelper.AddEmptyPdfCell(fcpaConcernTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(2) Company Has Government Background ?", PdfHelper.normalFont)) { Colspan = 2, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    fcpaConcernTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                this.AddCheckBox(fcpaConcernTable, ConNew.CapFcpaConcernsProperty2);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, fcpaConcernTable, Rectangle.ALIGN_LEFT);
                this.AddCheckBox(fcpaConcernTable, !ConNew.CapFcpaConcernsProperty2);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, fcpaConcernTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(fcpaConcernTable);

                PdfHelper.AddEmptyPdfCell(fcpaConcernTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(3) Shareholders Have Government Background ?", PdfHelper.normalFont)) { Colspan = 2, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    fcpaConcernTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                this.AddCheckBox(fcpaConcernTable, ConNew.CapFcpaConcernsProperty3);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, fcpaConcernTable, Rectangle.ALIGN_LEFT);
                this.AddCheckBox(fcpaConcernTable, !ConNew.CapFcpaConcernsProperty3);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, fcpaConcernTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(fcpaConcernTable);

                PdfHelper.AddEmptyPdfCell(fcpaConcernTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(4) Others (please illustrate):", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    fcpaConcernTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConNew.CapFcpaConcernsOther, pdfFont.answerChineseFont)) { Colspan = 5 },
                     fcpaConcernTable, null, null);
                PdfHelper.AddEmptyPdfCell(fcpaConcernTable);

                PdfHelper.AddPdfTable(doc, fcpaConcernTable);
                #endregion

                #region 11. Conflict of Interest:
                PdfPTable conflictIntersetTable = new PdfPTable(8);
                conflictIntersetTable.SetWidths(new float[] { 4f, 30f, 32f, 5f, 7f, 5f, 7f, 10f });
                PdfHelper.InitPdfTableProperty(conflictIntersetTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("11. Conflict of Interest:", PdfHelper.normalFont)) { Colspan = 8, FixedHeight = 25f },
                    conflictIntersetTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddEmptyPdfCell(conflictIntersetTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Does the dealer have conflict of interest issues with BSC current employees?", PdfHelper.normalFont)) { Colspan = 2, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    conflictIntersetTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                this.AddCheckBox(conflictIntersetTable, ConNew.CapDealerConflict);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, conflictIntersetTable, Rectangle.ALIGN_LEFT);
                this.AddCheckBox(conflictIntersetTable, !ConNew.CapDealerConflict);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, conflictIntersetTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(conflictIntersetTable);

                PdfHelper.AddEmptyPdfCell(conflictIntersetTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If yes, please state here:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    conflictIntersetTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConNew.CapDealerConflictReason, pdfFont.answerChineseFont)) { Colspan = 5 },
                     conflictIntersetTable, null, null);
                PdfHelper.AddEmptyPdfCell(conflictIntersetTable);

                PdfHelper.AddPdfTable(doc, conflictIntersetTable);
                #endregion

                #region 12. Conflict of Other Exclusive Dealers:
                PdfPTable conflictDealerTable = new PdfPTable(8);
                conflictDealerTable.SetWidths(new float[] { 4f, 30f, 32f, 5f, 7f, 5f, 7f, 10f });
                PdfHelper.InitPdfTableProperty(conflictDealerTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("12. Conflict of Other Exclusive Dealers:", PdfHelper.normalFont)) { Colspan = 8, FixedHeight = 25f },
                    conflictDealerTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddEmptyPdfCell(conflictDealerTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Does the business proposal above have conflicts with any other current ", PdfHelper.normalFont)) { Colspan = 2, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    conflictDealerTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                this.AddCheckBox(conflictDealerTable, ConNew.CapExclusiveConflict);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, conflictDealerTable, Rectangle.ALIGN_LEFT);
                this.AddCheckBox(conflictDealerTable, !ConNew.CapExclusiveConflict);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, conflictDealerTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(conflictDealerTable);

                PdfHelper.AddEmptyPdfCell(conflictDealerTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("exclusive dealer's contract terms?", PdfHelper.normalFont)) { Colspan = 6 },
                    conflictDealerTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddEmptyPdfCell(conflictDealerTable);

                PdfHelper.AddEmptyPdfCell(conflictDealerTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If yes, please state here:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    conflictDealerTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConNew.CapExclusiveConflictReason, pdfFont.answerChineseFont)) { Colspan = 5 },
                     conflictDealerTable, null, null);
                PdfHelper.AddEmptyPdfCell(conflictDealerTable);

                PdfHelper.AddPdfTable(doc, conflictDealerTable);
                #endregion

                #region NCM Approval
                PdfPTable ncmApprovalTable = new PdfPTable(6);
                ncmApprovalTable.SetWidths(new float[] { 4f, 20f, 23f, 20f, 23f, 10f });
                PdfHelper.InitPdfTableProperty(ncmApprovalTable);
                ncmApprovalTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 6 });

                PdfHelper.AddEmptyPdfCell(ncmApprovalTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("NCM Signature:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT },
                    ncmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(ConNew.CapNcmForPart2PrintName, PdfHelper.answerFont, ncmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
              
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT },
                    ncmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConNew.CapNcmForPart2Date, null), PdfHelper.answerFont, ncmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(ncmApprovalTable);

                ncmApprovalTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 6 });
                PdfHelper.AddPdfTable(doc, ncmApprovalTable);
                #endregion


                if (ConNew.CapDrmPrintName != null && !ConNew.CapDrmPrintName.ToString().Equals(""))
                {
                    #region Local Management Approvals
                    PdfPTable localManagementTable = new PdfPTable(6);
                    localManagementTable.SetWidths(new float[] { 6f, 20f, 25f, 12f, 25f, 12f });
                    PdfHelper.InitPdfTableProperty(localManagementTable);
                    localManagementTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 6 });

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Colspan = 6 }, localManagementTable, null, null);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Sales Division Management Approvals:", PdfHelper.italicFont)) { BackgroundColor = BaseColor.CYAN, FixedHeight = 17f, PaddingTop = 1f, Colspan = 8 },
                        localManagementTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                    PdfHelper.AddEmptyPdfCell(localManagementTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Relationship Manager (if applicable):", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(ConNew.CapDrmPrintName, PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConNew.CapDrmDate, ""), PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(localManagementTable);
                    if (ConNew.CapFcPrintName != null && !ConNew.CapFcPrintName.ToString().Equals(""))
                    {
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Country Controller/Finance Manager:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(ConNew.CapFcPrintName, PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);

                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConNew.CapFcDate, ""), PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                    }
                    if (ConNew.CapCdPrintName != null && !ConNew.CapCdPrintName.ToString().Equals(""))
                    {
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Country General Manager Director:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(ConNew.CapCdPrintName, PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);

                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConNew.CapCdDate, ""), PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                    }
                    localManagementTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 6 });
                    PdfHelper.AddPdfTable(doc, localManagementTable);

                    #endregion
                }

                if (ConNew.CapVpfPrintName != null && !ConNew.CapVpfPrintName.ToString().Equals(""))
                {
                    #region Regional Management Approvals
                    PdfPTable regionalManagementTable = new PdfPTable(6);
                    regionalManagementTable.SetWidths(new float[] { 6f, 20f, 25f, 12f, 25f, 12f });
                    PdfHelper.InitPdfTableProperty(regionalManagementTable);
                    regionalManagementTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 6 });

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Colspan = 6 }, regionalManagementTable, null, null);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Regional Management Approvals:", PdfHelper.italicFont)) { BackgroundColor = BaseColor.CYAN, FixedHeight = 17f, PaddingTop = 1f, Colspan = 8 },
                        regionalManagementTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                    PdfHelper.AddEmptyPdfCell(regionalManagementTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Region Controller /VP \r\n Finance Asia-Pacific:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, regionalManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(ConNew.CapVpfPrintName, PdfHelper.answerFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, regionalManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConNew.CapVpfDate, ""), PdfHelper.answerFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(regionalManagementTable);

                    PdfHelper.AddEmptyPdfCell(regionalManagementTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("EVP & President,\r\n Asia-Pacific:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, regionalManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(ConNew.CapVpapPrintName, PdfHelper.answerFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, regionalManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConNew.CapVpapDate, ""), PdfHelper.answerFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(regionalManagementTable);

                    PdfHelper.AddPdfTable(doc, regionalManagementTable);

                    #endregion
                }
                #endregion

                #region 授权
                doc.NewPage();

                string content = "";
                if (isArea)
                {
                    content = @"Attachment of Form 3 -- Exclude Territory:";
                }
                else 
                {
                    content = @"Attachment of Form 3 -- Territory:";
                }
                Chunk chunkAtt = new Chunk(content, PdfHelper.normalFont);
                Phrase phraseAtt = new Phrase();
                phraseAtt.Add(chunkAtt);
                Paragraph paragraphAtt = new Paragraph();
                paragraphAtt.IndentationLeft = 20f;
                paragraphAtt.KeepTogether = true;
                paragraphAtt.Alignment = Element.ALIGN_JUSTIFIED;

                paragraphAtt.Add(phraseAtt);
                paragraphAtt.Add(new Paragraph(" "));
                doc.Add(paragraphAtt);

                Chunk hospCnChunk = null;
                Chunk hospEnChunk = null;
                Phrase hospPhrase = null;
                Paragraph hospParagraph = null;
                PdfHelper pdflp = new PdfHelper();

                if (isArea)
                {
                    DataTable ExpHos = _contractBll.GetPartAreaExcHospitalTemp(obj).Tables[0];
                    for (int i = 0; i < ExpHos.Rows.Count; i++)
                    {
                        hospCnChunk = new Chunk(ExpHos.Rows[i]["HosHospitalName"].ToString() + "   ", pdflp.answerChineseFont);
                        hospEnChunk = new Chunk("(" + ExpHos.Rows[i]["HosHospitalNameEN"].ToString() + ")", PdfHelper.normalFont);
                        hospPhrase = new Phrase();
                        hospPhrase.Add(new Chunk((i + 1).ToString() + ".   ", PdfHelper.normalFont));
                        hospPhrase.Add(hospCnChunk);
                        hospPhrase.Add(hospEnChunk);
                        hospParagraph = new Paragraph();
                        hospParagraph.IndentationLeft = 20f;
                        hospParagraph.KeepTogether = true;
                        hospParagraph.Alignment = Element.ALIGN_JUSTIFIED;

                        hospParagraph.Add(hospPhrase);
                        doc.Add(hospParagraph);
                    }
                }
                else
                {
                    for (int i = 0; i < dtTerritorynew.Rows.Count; i++)
                    {
                        hospCnChunk = new Chunk(dtTerritorynew.Rows[i]["HospitalName"].ToString() + "   ", pdflp.answerChineseFont);
                        hospEnChunk = new Chunk("(" + dtTerritorynew.Rows[i]["HospitalENName"].ToString() + ")", PdfHelper.normalFont);
                        hospPhrase = new Phrase();
                        hospPhrase.Add(new Chunk((i + 1).ToString() + ".   ", PdfHelper.normalFont));
                        hospPhrase.Add(hospCnChunk);
                        hospPhrase.Add(hospEnChunk);
                        hospParagraph = new Paragraph();
                        hospParagraph.IndentationLeft = 20f;
                        hospParagraph.KeepTogether = true;
                        hospParagraph.Alignment = Element.ALIGN_JUSTIFIED;

                        hospParagraph.Add(hospPhrase);
                        doc.Add(hospParagraph);
                    }
                }

                #endregion
                //this.InsertAttachment(fileName);
                //Ext.Msg.Alert("Message", "生成成功！<br />请至【附件信息】中查阅").Show();
               // return fileName;
            }
            catch (Exception ex)
            {
                //Ext.Msg.Alert("Error","发生错误！").Show();
                Console.WriteLine(ex.Message);
               // return string.Empty;
            }
            finally
            {
                doc.Close();
            }

            DownloadFileForDCMS(fileName, "Appendix_1.pdf", "DCMS");
        }

        private void InsertAttachment(string fileName)
        {
            Attachment newAttachment = new Attachment();
            newAttachment.Id = Guid.NewGuid();
            newAttachment.MainId = new Guid(this.hdCmID.Value.ToString());
            newAttachment.Name = "APPENDIX_I.pdf";
            newAttachment.Url = fileName;
            newAttachment.Type = ContractAttachmentType.ApSystemCreate.ToString();//"SystemCreate";
            newAttachment.UploadDate = DateTime.Now;
            newAttachment.UploadUser = new Guid(_context.User.Id);

            attachmentBLL.AddAttachment(newAttachment);
        }

        private void AddCheckBox(PdfPTable table, string key, string value)
        {
            #region Public Element
            PdfPCell noSelectCell = PdfHelper.GetNoSelectImageCell();
            PdfPCell SelectCell = PdfHelper.GetYesSelectImageCell();
            #endregion

            if (!string.IsNullOrEmpty(key) && value.ToUpper().Equals(key.ToUpper()))
            {
                //选中
                PdfHelper.AddImageCell(SelectCell, table);
            }
            else
            {
                //未选中
                PdfHelper.AddImageCell(noSelectCell, table);
            }
        }

        private void AddCheckBox(PdfPTable table, bool? check)
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
                    PdfHelper.AddImageCell(SelectCell, table);
                }
                else
                {
                    //未选中
                    PdfHelper.AddImageCell(noSelectCell, table);
                }
            }
            else
            {
                //未选中
                PdfHelper.AddImageCell(noSelectCell, table);
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
