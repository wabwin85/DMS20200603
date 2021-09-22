using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using DMS.Model;
using DMS.Business;
using System.Data;
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

    public partial class ContractAppendix3 : BasePage
    {
        private IContractRenewalService _renewal = new ContractRenewalService();
        private IContractMasterBLL _contractBll = new ContractMasterBLL();
     
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (Request.QueryString["ContId"] != null)
                {
                    this.hdContractID.Value = Request.QueryString["ContId"];
                    this.hdDealerType.Value = Request.QueryString["DealerLv"];
                    this.hdContStatus.Value = Request.QueryString["ContStatus"];
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
        }

        #region 绑定经销商授权
        protected void Store_RefreshTerritoryOld(object sender, StoreRefreshDataEventArgs e)
        {
            HospitalListHistory history = new HospitalListHistory();
            history.ChangeToContractid = new Guid(this.hdContractID.Value.ToString());
            DataTable dtTerritory = _contractBll.GetHistoryAuthorizedHospital(history).Tables[0];
            if (dtTerritory.Rows.Count == 0 && !this.hdContStatus.Value.ToString().Equals("Completed"))
            {
                Hashtable table = new Hashtable();
                table.Add("DivisionId", this.hdDivisionId.Value.ToString());
                table.Add("SubDepCode", this.hdSubDepCode.Value.ToString());
                table.Add("DmaId", this.hdDmaId.Value.ToString());
                if (!this.hdIsEmerging.Value.ToString().Equals("2"))
                {
                    table.Add("IsEmerging", this.hdIsEmerging.Value.ToString().Equals("") ? "0" : this.hdIsEmerging.Value.ToString());
                }

                dtTerritory = _contractBll.GetFormalAuthorizedHospital(table).Tables[0];
            }
            if (dtTerritory.Rows.Count > 0)
            {
                this.TerritoryOld.DataSource = dtTerritory;
                this.TerritoryOld.DataBind();
                this.gpTerritoryOld.Title = "Original Agreement Term ( " + dtTerritory.Rows.Count + " Hospitals )";
            }
            else
            {
                this.gpTerritoryOld.Title = "Original Agreement Term ( 0 Hospitals )";
            }
        }

        protected void Store_RefreshTerritoryNew(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable dtTerritory = _contractBll.GetContractTerritoryByContractId(new Guid(this.hdContractID.Value.ToString())).Tables[0];
            if (dtTerritory.Rows.Count > 0)
            {
                this.TerritoryNew.DataSource = dtTerritory;
                this.TerritoryNew.DataBind();
                this.gpTerritoryNew.Title = "Changed To ( " + dtTerritory.Rows.Count + " Hospitals )";
            }
            else
            {
                this.gpTerritoryNew.Title = "Changed To ( 0 Hospitals )";
            }
        }
        #endregion

        #region 绑定经销商指标
        protected void Store_RefreshQuotaOld(object sender, StoreRefreshDataEventArgs e)
        {
            AopDealerHistory history = new AopDealerHistory();
            history.ChangeToContractid = new Guid(this.hdContractID.Value.ToString());
            DataTable dtQuotas = _contractBll.GetHistoryAopDealer(history).Tables[0];

            if (dtQuotas.Rows.Count == 0 && !this.hdContStatus.Value.ToString().Equals("Completed"))
            {
                Hashtable table = new Hashtable();
                table.Add("DivisionId", this.hdDivisionId.Value.ToString());
                table.Add("SubDepCode", this.hdSubDepCode.Value.ToString());
                table.Add("DmaId", this.hdDmaId.Value.ToString());
                table.Add("Year", null);
                table.Add("IsEmerging", this.hdIsEmerging.Value.ToString().Equals("") ? "0" : this.hdIsEmerging.Value.ToString());

                dtQuotas = _contractBll.GetFormalAopDealer(table).Tables[0];
            }
            if (dtQuotas.Rows.Count > 0)
            {
                this.QuotaOld.DataSource = dtQuotas;
                this.QuotaOld.DataBind();
            }
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
        #endregion

        #region 绑定经销商医院指标
        protected void Store_RefreshQuotaHospitalOld(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            AopDealerHospitaHistory history = new AopDealerHospitaHistory();
            history.ChangeToContractid = new Guid(this.hdContractID.Value.ToString());
            DataTable dtQuotasHospital = _contractBll.GetHistoryAopHospital(history, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];

            if (dtQuotasHospital.Rows.Count == 0 && !this.hdContStatus.Value.ToString().Equals("Completed"))
            {
                Hashtable table = new Hashtable();
                table.Add("DivisionId", this.hdDivisionId.Text);
                table.Add("SubDepCode", this.hdSubDepCode.Value.ToString());
                table.Add("DmaId", this.hdDmaId.Text);
                table.Add("Year", null);
                if (!this.hdIsEmerging.Value.ToString().Equals("2"))
                {
                    table.Add("IsEmerging", this.hdIsEmerging.Value.ToString().Equals("") ? "0" : this.hdIsEmerging.Value.ToString());
                }

                dtQuotasHospital = _contractBll.GetFormalAopHospital(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            }
            if (sender is Store)
            {
                Store store1 = (sender as Store);
                (store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                store1.DataSource = dtQuotasHospital;
                store1.DataBind();
            }

        }

        protected void Store_RefreshQuotaHospitalNew(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataTable dtQuotasHospital = _contractBll.GetAopDealersHospitalByQueryByContractId(new Guid(this.hdContractID.Value.ToString()), (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];

            if (sender is Store)
            {
                Store store1 = (sender as Store);
                (store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                store1.DataSource = dtQuotasHospital;
                store1.DataBind();
            }

        }
        #endregion

        #region 绑定医院产品分类指标
        protected void AOPHopsptalProductOld_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            AopicDealerHospitalHistory history = new AopicDealerHospitalHistory();
            history.ChangeToContractid = new Guid(this.hdContractID.Value.ToString());
            System.Data.DataSet dataSource = _contractBll.GetHistoryAopHospitalProduct(history, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            if (dataSource.Tables[0].Rows.Count == 0 && !this.hdContStatus.Value.ToString().Equals("Completed"))
            {
                Hashtable table = new Hashtable();
                table.Add("DivisionId", this.hdDivisionId.Value.ToString());
                table.Add("SubDepCode", this.hdSubDepCode.Value.ToString());
                table.Add("DmaId", this.hdDmaId.Text.ToString());
                table.Add("Year", null);
                if (!this.hdIsEmerging.Value.ToString().Equals("2"))
                {
                    table.Add("IsEmerging", this.hdIsEmerging.Value.ToString().Equals("") ? "0" : this.hdIsEmerging.Value.ToString());
                }

                dataSource = _contractBll.GetFormalAopHospitalProductUnit(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            }
            if (sender is Store)
            {
                Store store1 = (sender as Store);
                (store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                store1.DataSource = dataSource;
                store1.DataBind();
            }
        }

        protected void AOPHopsptalProductNew_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataTable dtQuotasHospitalProduct = _contractBll.GetICAopDealersHospitalUnitByQuery(new Guid(this.hdContractID.Value.ToString()), (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.AopHospitalProductNew.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.AopHospitalProductNew.DataSource = dtQuotasHospitalProduct;
            this.AopHospitalProductNew.DataBind();
        }

        #endregion

        #region 绑定授权到区域

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
                    this.gpTerritoryNew.Hidden = true;
                    this.gpTerritoryOld.Hidden = true;
                    this.gpAreaNew.Hidden = false;
                    this.gpExcludeHosNew.Hidden = false;
                    this.gpAreaOld.Hidden = false;
                    this.gpExcludeHosOld.Hidden = false;
                }
                else
                {
                    this.gpAreaNew.Hidden = true;
                    this.gpExcludeHosNew.Hidden = true;
                    this.gpAreaOld.Hidden = true;
                    this.gpExcludeHosOld.Hidden = true;
                    this.gpTerritoryNew.Hidden = false;
                    this.gpTerritoryOld.Hidden = false;
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

        protected void AreaStoreOld_OnRefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!String.IsNullOrEmpty(this.hdContractID.Value.ToString()))
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hdContractID.Value.ToString()); //合同ID
                obj.Add("DivisionId", this.hdDivisionId.Value.ToString());
                obj.Add("SubDepCode", this.hdSubDepCode.Value.ToString());
                obj.Add("DmaId", this.hdDmaId.Value.ToString());
                DataTable provinces = _contractBll.GetProvincesForAreaSelectedOld(obj).Tables[0];
                AreaStoreOld.DataSource = provinces;
                AreaStoreOld.DataBind();
            }
        }

        protected void ExcludeHospitalStoreOld_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!String.IsNullOrEmpty(this.hdContractID.Value.ToString()))
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hdContractID.Value.ToString()); //合同ID
                obj.Add("DivisionId", this.hdDivisionId.Value.ToString());
                obj.Add("SubDepCode", this.hdSubDepCode.Value.ToString());
                obj.Add("DmaId", this.hdDmaId.Value.ToString());

                DataSet query = _contractBll.GetPartAreaExcHospitalOld(obj);
                this.ExcludeHospitalStoreOld.DataSource = query;
                this.ExcludeHospitalStoreOld.DataBind();
            }
        }

        #endregion

        private void BindPageData()
        {
            ContractRenewal renewal = _renewal.GetContractRenewalByID(new Guid(this.hdContractID.Value.ToString()));
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
                    if (renewal.CreDivision != null)
                    {
                        if (renewal.CreDivision.ToLower().Equals(dtDivision.Rows[i]["DivisionName"].ToString().ToLower()))
                        {
                            rd.Checked = true;
                            this.hdDivisionId.Value = dtDivision.Rows[i]["DivisionCode"].ToString();
                            this.hdDivisionName.Value = dtDivision.Rows[i]["DivisionName"].ToString();
                            if (dtDivision.Rows[i]["DivisionName"].ToString().ToLower().Equals("cardio") || dtDivision.Rows[i]["DivisionName"].ToString().ToLower().Equals("sh") || (renewal.CreMarketType != null && renewal.CreMarketType.ToString().Equals("1")))
                            {
                                this.lbQuota.FieldLabel = "Purchase Quota (CNY, exclude VAT), " + SR.Const_ExchangeRate;
                                //this.cbQuotaHospital.BoxLabel = "Purchase Quota By Hospital (CNY, VAT), " + SR.Const_ExchangeRate;

                                //this.gpQuotaHospitalOld.Hidden = true;
                                //this.gpHospitalProductOld.Hidden = false;
                                //this.gpQuotaHospitalNew.Hidden = true;
                                //this.gpAopHospitalProductNew.Hidden = false;
                            }
                            else
                            {
                                //this.gpQuotaHospitalOld.Hidden = false;
                                //this.gpHospitalProductOld.Hidden = true;
                                //this.gpQuotaHospitalNew.Hidden = false;
                                //this.gpAopHospitalProductNew.Hidden = true;
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

            if (renewal != null)
            {
                this.laSubBU.Text = renewal.CreSubdepName;
                this.hdDmaId.Text = renewal.CreDmaId.ToString();
                this.hdIsEmerging.Value = renewal.CreMarketType;
                this.hdSubDepCode.Value = renewal.CreSubDepid;
                this.tfDealerName.Text = renewal.CreDealerName;

                this.tfContractTypeOld.Text = renewal.CreContractTypeCurrent;
                this.tfContractTypeNew.Text = renewal.CreContractTypeRenewal;
                this.tfContractTypeRemarks.Text = renewal.CreContractTypeRemarks;

                this.tfBSCEntityOld.Text = renewal.CreBscEntityCurrent;
                this.tfBSCEntityNew.Text = renewal.CreBscEntityRenewal;
                this.tfBSCEntityRemarks.Text = renewal.CreBscEntityRemarks;

                this.tfExclusivenessOld.Text = renewal.CreExclusivenessCurrent;
                this.tfExclusivenessNew.Text = renewal.CreExclusivenessRenewal;
                this.tfExclusivenessRemarks.Text = renewal.CreExclusivenessRemarks;

                this.tfAgreementTermOld.Text = (renewal.CreAgrmtEffectiveDateCurrent == null ? "" : ( Convert.ToDateTime(renewal.CreAgrmtEffectiveDateCurrent).ToShortDateString())) + (renewal.CreAgrmtExpirationDateCurrent == null ? "" : ("To  " + Convert.ToDateTime(renewal.CreAgrmtExpirationDateCurrent.ToString()).ToShortDateString()));
                this.tfAgreementTermNew.Text = renewal.CreAgrmtEffectiveDateRenewal == null ? "" : ( Convert.ToDateTime(renewal.CreAgrmtEffectiveDateRenewal).ToShortDateString()) + (renewal.CreAgrmtExpirationDateRenewal == null ? "" : ("To  " + Convert.ToDateTime(renewal.CreAgrmtExpirationDateRenewal.ToString()).ToShortDateString()));
                this.tfAgreementTermRemarks.Text = renewal.CreAgreementTermRemarks;

                this.tfPricesOld.Text = String.IsNullOrEmpty(renewal.CrePricesCurrent) ? "" : (ParseTags(renewal.CrePricesCurrent.Replace("&emsp;", "").Replace("<br/>", "")) + "% off standard price list.");
                this.tfPricesNew.Text = String.IsNullOrEmpty(renewal.CrePricesRenewal) ? "" : (ParseTags(renewal.CrePricesRenewal.Replace("&emsp;", "").Replace("<br/>", "")) + "% off standard price list.");
                this.tfPricesRemarks.Text = renewal.CrePricesRemarks;

                this.tfSpecialSalesOld.Text = String.IsNullOrEmpty(renewal.CreSpecialSalesCurrent) ? "NA" : (renewal.CreSpecialSalesCurrent + "% of the quarter purchase ammount.");
                this.tfSpecialSalesNew.Text = String.IsNullOrEmpty(renewal.CreSpecialSalesRenewal) ? "NA" : (renewal.CreSpecialSalesRenewal + "% of the quarter purchase ammount.");
                this.tfSpecialSalesRemarks.Text = renewal.CreSpecialSalesRemarks;

                this.tfPaymentTermOld.Text = renewal.CrePaymentCurrent;
                this.tfPaymentTermNew.Text = renewal.CrePaymentRenewal;
                this.tfPaymentTermRemarks.Text = renewal.CrePaymentRemarks;

                this.tfCreditLimitsOld.Text = renewal.CreCreditLimitsCurrent == null ? "" : renewal.CreCreditLimitsCurrent.ToString();
                this.tfCreditLimitsNew.Text = renewal.CreCreditLimitsRenewal == null ? "" : renewal.CreCreditLimitsRenewal.ToString();
                this.tfCreditLimitsRemarks.Text = renewal.CreCreditLimitsRemarks;

                this.tfSecurityDepositOld.Text = renewal.CreSecurityDepositCurrent;
                this.tfSecurityDepositNew.Text = renewal.CreSecurityDepositRenewal;
                this.tfSecurityDepositRemarks.Text = renewal.CreSecurityDepositRemarks;
                
                this.tfTerritoryRemarks.Text = renewal.CreTerritoryRemarks;
                this.tfQuotaRemarks.Text = renewal.CreQuotaRemakrs;

                if (renewal.CreHasConflict != null)
                {
                    if (Convert.ToBoolean(renewal.CreHasConflict))
                    {
                        this.radioHasConflictYes.Checked = true;
                    }
                    else
                    {
                        this.radioHasConflictNo.Checked = true;
                    }
                }
                this.tfHasConflictRemarks.Text = renewal.CreConflictRemarks;
                this.tfBusinessHandover.Text = renewal.CreBusinessHandover;

                //if (renewal.CreHasiaf != null)
                //{
                //    if (Convert.ToBoolean(renewal.CreHasiaf))
                //    {
                //        this.radioIAFYes.Checked = true;
                //    }
                //    else
                //    {
                //        this.radioIAFNo.Checked = true;
                //    }
                //}

                //产品线
                if (!String.IsNullOrEmpty(renewal.CreProductLineOld)) 
                {
                    if (renewal.CreProductLineOld.ToLower().Equals("all"))
                    {
                        this.tfProductLineOld.Text = "All products of " + renewal.CreSubdepName;
                    }
                    else 
                    {
                        this.tfProductLineOld.Text = renewal.CreProductLineOld == null ? "" : ParseTags(renewal.CreProductLineOld.Replace("&emsp;", "").Replace("<br/>", ""));
                    }
                }
                if (!String.IsNullOrEmpty(renewal.CreProductLineNew))
                {
                    if (renewal.CreProductLineNew.ToLower().Equals("all"))
                    {
                        this.tfProductLineNew.Text = "All products of " + renewal.CreSubdepName;
                    }
                    else
                    {
                        this.tfProductLineNew.Text = renewal.CreProductLineNew == null ? "" : ParseTags(renewal.CreProductLineNew.Replace("&emsp;", "").Replace("<br/>", ""));
                    }
                }
                this.tfProductLineRemarks.Text = renewal.CreProductLineRemarks == null ? "" : ParseTags(renewal.CreProductLineRemarks.Replace("&emsp;", "").Replace("<br/>", ""));

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
            string fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
            string targetPath = Server.MapPath(PdfHelper.FILE_PATH + fileName);

            Document doc = new Document(iTextSharp.text.PageSize.A4, 36, 36, 12, 12);
            try
            {
                bool isArear = false;
                ContractRenewal ConRen = _renewal.GetContractRenewalByID(new Guid(this.hdContractID.Value.ToString()));
                DataTable dtTerritorynew = _contractBll.GetContractTerritoryByContractId(new Guid(this.hdContractID.Value.ToString())).Tables[0];
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hdContractID.Value.ToString()); //合同ID
                DataTable provinces = _contractBll.GetProvincesForAreaSelected(obj).Tables[0];

                if (provinces.Rows.Count > 0)
                {
                    isArear = true;
                }

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
                PdfPCell titleCell = new PdfPCell(new Paragraph("BSC China & HK Dealer Agreement Renewal Application Form", PdfHelper.boldFont));
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

                PdfPCell recCell = new PdfPCell(new Paragraph("For Requestor: Please Complete Section 1 - 3", PdfHelper.italicFont));
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
                PdfHelper.AddImageCell(this.AddCheckBox(ConRen.CreDivision, DivisionName.Cardio.ToString()), divisionTable);
                PdfHelper.AddPdfCell("Cardio", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //CRM
                PdfHelper.AddImageCell(this.AddCheckBox(ConRen.CreDivision, DivisionName.CRM.ToString()), divisionTable);
                PdfHelper.AddPdfCell("CRM", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Endo
                PdfHelper.AddImageCell(this.AddCheckBox(ConRen.CreDivision, DivisionName.Endo.ToString()), divisionTable);
                PdfHelper.AddPdfCell("Endo", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //EP
                PdfHelper.AddImageCell(this.AddCheckBox(ConRen.CreDivision, DivisionName.EP.ToString()), divisionTable);
                PdfHelper.AddPdfCell("EP", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //PI
                PdfHelper.AddImageCell(this.AddCheckBox(ConRen.CreDivision, DivisionName.PI.ToString()), divisionTable);
                PdfHelper.AddPdfCell("PI", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Uro
                PdfHelper.AddImageCell(this.AddCheckBox(ConRen.CreDivision, DivisionName.Uro.ToString()), divisionTable);
                PdfHelper.AddPdfCell("NV", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Asthma
                PdfHelper.AddImageCell(this.AddCheckBox(ConRen.CreDivision, DivisionName.AS.ToString()), divisionTable);
                PdfHelper.AddPdfCell("Asthma", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //SH
                PdfHelper.AddImageCell(this.AddCheckBox(ConRen.CreDivision, DivisionName.SH.ToString()), divisionTable);
                PdfHelper.AddPdfCell("SH", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Empty
                PdfHelper.AddEmptyPdfCell(divisionTable);

                PdfHelper.AddPdfTable(doc, divisionTable);

                PdfPTable divisionRec_Table = new PdfPTable(5);
                PdfHelper.InitPdfTableProperty(divisionRec_Table);
                divisionRec_Table.SetWidths(new float[] { 20f, 25f, 20f, 25f, 10f });

                //Empty Cell
                PdfHelper.AddEmptyPdfCell(divisionRec_Table);

                PdfHelper.AddPdfTable(doc, divisionRec_Table);
                #endregion

                #region 2.  Dealer Name:
                PdfPTable basicDealerInfoTable = new PdfPTable(3);
                PdfHelper.InitPdfTableProperty(basicDealerInfoTable);
                basicDealerInfoTable.SetWidths(new float[] { 20f, 90f, 10f });

                //Dealer Info Label
                PdfHelper.AddPdfCell("2.  Dealer Name:", PdfHelper.normalFont, basicDealerInfoTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(ConRen.CreDealerName, pdfFont.answerChineseFont, basicDealerInfoTable, null);
                PdfHelper.AddEmptyPdfCell(basicDealerInfoTable);
                PdfHelper.AddPdfTable(doc, basicDealerInfoTable);

                #endregion

                #region 3.  Agreement Renewal Proposals:
                PdfPTable supportDocTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(supportDocTable);

                //Agreement Renewal Proposals:
                PdfHelper.AddPdfCell("3.  Agreement Renewal Proposals:", PdfHelper.normalFont, supportDocTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, supportDocTable);


                //Agreement Renewal Proposals Grid:
                PdfPTable standardTermGridTable = new PdfPTable(5);
                standardTermGridTable.SetWidths(new float[] { 4f, 25f, 25f, 25f, 25f });
                PdfHelper.InitPdfTableProperty(standardTermGridTable);

                //表头
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, BackgroundColor = BaseColor.GRAY }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Current Agreement Term", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 1, BackgroundColor = BaseColor.GRAY }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Renewal Term", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 1, BackgroundColor = BaseColor.GRAY }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Remarks", PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 1, BackgroundColor = BaseColor.GRAY }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true, true, true, true);
                //Contract Type
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Contract Type", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(ConRen.CreContractTypeCurrent, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(ConRen.CreContractTypeRenewal, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConRen.CreContractTypeRemarks, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);
                //BSC Entity
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("BSC Entity", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(ConRen.CreBscEntityCurrent, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(ConRen.CreBscEntityRenewal, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConRen.CreBscEntityRemarks, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);
                //Exclusiveness
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Exclusiveness", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(ConRen.CreExclusivenessCurrent, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(ConRen.CreExclusivenessRenewal, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConRen.CreExclusivenessRemarks, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);
                //Agreement Term
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Agreement Term", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(base.GetStringByDate(ConRen.CreAgrmtEffectiveDateCurrent, null) + "\r\n To  " + base.GetStringByDate(ConRen.CreAgrmtExpirationDateCurrent, null), pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(base.GetStringByDate(ConRen.CreAgrmtEffectiveDateRenewal, null) + "\r\n To  " + base.GetStringByDate(ConRen.CreAgrmtExpirationDateRenewal, null), pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConRen.CreAgreementTermRemarks, pdfFont.answerChineseFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);
                //Product Line
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                string newProductline="";
                if (ConRen.CreProductLineNew != null) 
                {
                    if (ConRen.CreProductLineNew.ToString().ToLower().Equals("all"))
                    {
                        newProductline = "All products of " + this.hdDivisionName.Value;
                    }
                    else if (ConRen.CreProductLineNew.ToString().ToLower().Equals("partial"))
                    {
                        newProductline = "Partial";
                    }
                }
                string oldProductline = "";
                if (ConRen.CreProductLineOld != null)
                {
                    if (ConRen.CreProductLineOld.ToString().ToLower().Equals("all"))
                    {
                        oldProductline = "All products of " + this.hdDivisionName.Value;
                    }
                    else
                    {
                        oldProductline = ConRen.CreProductLineOld == null ? "" : ParseTags(ConRen.CreProductLineOld.Replace("&emsp;", "").Replace("<br/>", ""));
                    }
                }
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Product Line", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(oldProductline, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(newProductline, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConRen.CreProductLineRemarks == null ? "" : ParseTags(ConRen.CreProductLineRemarks.Replace("&emsp;", "").Replace("<br/>", "")), pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);
                //Prices
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                string pricesCurrent = "";
                if (ConRen.CrePricesCurrent != null && !ConRen.CrePricesCurrent.ToString().Equals("NA")) 
                {
                    pricesCurrent = ParseTags(ConRen.CrePricesCurrent.ToString().Replace("&emsp;", "").Replace("<br/>", "")) + "% off standard price list";
                }

                string pricesRenewal = "";
                if (ConRen.CrePricesRenewal != null && !ConRen.CrePricesRenewal.ToString().Equals("NA"))
                {
                    pricesRenewal = ParseTags(ConRen.CrePricesRenewal.ToString().Replace("&emsp;", "").Replace("<br/>", "")) + "% off standard price list";
                }

                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Prices", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(pricesCurrent == "" ? ConRen.CrePricesCurrent : pricesCurrent, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(pricesRenewal == "" ? ConRen.CrePricesRenewal : pricesRenewal, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConRen.CrePricesRemarks == null ? "" : ParseTags(ConRen.CrePricesRemarks.Replace("&emsp;", "").Replace("<br/>", "")), pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);
                //Territory (Hospitals)
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                string territorOld = "";
                string territorNew = "";

                if (!isArear)
                {
                    HospitalListHistory history = new HospitalListHistory();
                    history.ChangeToContractid = new Guid(this.hdContractID.Value.ToString());
                    DataTable dtTerritoryOld = _contractBll.GetHistoryAuthorizedHospital(history).Tables[0];
                    if (dtTerritoryOld.Rows.Count == 0 && !this.hdContStatus.Value.ToString().Equals("Completed"))
                    {
                        Hashtable table = new Hashtable();
                        table.Add("DivisionId", this.hdDivisionId.Value.ToString());
                        table.Add("SubDepCode", this.hdSubDepCode.Value.ToString());
                        table.Add("DmaId", this.hdDmaId.Value.ToString());
                        if (!this.hdIsEmerging.Value.ToString().Equals("2"))
                        {
                            table.Add("IsEmerging", this.hdIsEmerging.Value.ToString().Equals("") ? "0" : this.hdIsEmerging.Value.ToString());
                        }

                        dtTerritoryOld = _contractBll.GetFormalAuthorizedHospital(table).Tables[0];
                    }

                    for (int i = 0; i < dtTerritoryOld.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            territorOld = dtTerritoryOld.Rows.Count + " Hospitals\r\n";
                        }
                        territorOld += (i + 1 + ". " + dtTerritoryOld.Rows[i]["HospitalNameEN"].ToString() + "\r\n");
                    }
                    for (int i = 0; i < dtTerritorynew.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            territorNew = dtTerritorynew.Rows.Count + " Hospitals\r\n";
                        }
                        territorNew += (i + 1 + ". " + dtTerritorynew.Rows[i]["HospitalENName"].ToString() + "\r\n");
                    }
                }
                else 
                {
                    Hashtable objArea = new Hashtable();
                    objArea.Add("ContractId", this.hdContractID.Value.ToString()); //合同ID
                    objArea.Add("DivisionId", this.hdDivisionId.Value.ToString());
                    objArea.Add("SubDepCode", this.hdSubDepCode.Value.ToString());
                    objArea.Add("DmaId", this.hdDmaId.Value.ToString());
                    DataTable oldprovinces = _contractBll.GetProvincesForAreaSelectedOld(objArea).Tables[0];
                    for (int i = 0; i < oldprovinces.Rows.Count; i++)
                    {
                        territorOld = territorOld + (i + 1) + ". " + oldprovinces.Rows[i]["Description"].ToString() + "\r\n";
                    }

                    for (int i = 0; i < provinces.Rows.Count; i++)
                    {
                        territorNew = territorNew + (i + 1) + ". " + provinces.Rows[i]["Description"].ToString() + "\r\n";
                    }

                    DataTable queryOldHos = _contractBll.GetPartAreaExcHospitalOld(objArea).Tables[0];
                    for (int i = 0; i < queryOldHos.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            territorOld += ("\r\n" + " Regional Exclusion Of Hospitals" + "\r\n");
                        }
                        territorOld += (queryOldHos.Rows[i]["HosHospitalNameEN"].ToString() + "\r\n");
                    }

                    DataTable queryNewHos = _contractBll.GetPartAreaExcHospitalTemp(obj).Tables[0];
                    for (int i = 0; i < queryNewHos.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            territorNew += ("\r\n" + " Regional Exclusion Of Hospitals" + "\r\n");
                        }
                        territorNew += (queryNewHos.Rows[i]["HosHospitalNameEN"].ToString() + "\r\n");
                    }
                }
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Territory (Hospitals)", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(territorOld, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(territorNew, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConRen.CreTerritoryRemarks, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);
               
                //Purchase Quota
                string quotasOld = "";
                string quotasNew = "";
                AopDealerHistory historyAop = new AopDealerHistory();
                historyAop.ChangeToContractid = new Guid(this.hdContractID.Value.ToString());
                DataTable dtQuotasOld = _contractBll.GetHistoryAopDealer(historyAop).Tables[0];
                if (dtQuotasOld.Rows.Count == 0 && !this.hdContStatus.Value.ToString().Equals("Completed"))
                {
                    Hashtable table = new Hashtable();
                    table.Add("DivisionId", this.hdDivisionId.Value.ToString());
                    table.Add("SubDepCode", this.hdSubDepCode.Value.ToString());
                    table.Add("DmaId", this.hdDmaId.Value.ToString());
                    table.Add("Year", null);
                    table.Add("IsEmerging", this.hdIsEmerging.Value.ToString().Equals("") ? "0" : this.hdIsEmerging.Value.ToString());

                    dtQuotasOld = _contractBll.GetFormalAopDealer(table).Tables[0];
                }
                
                for (int i = 0; i < dtQuotasOld.Rows.Count; i++) 
                {
                    quotasOld = quotasOld + dtQuotasOld.Rows[i]["Year"].ToString() 
                        + ": [ Q1:" + GetStringByDecimal(dtQuotasOld.Rows[i]["Q1"].ToString()) 
                        + "; Q2:" + GetStringByDecimal(dtQuotasOld.Rows[i]["Q2"].ToString()) 
                        + "; Q3:" + GetStringByDecimal(dtQuotasOld.Rows[i]["Q3"].ToString())
                        + "; Q4:" + GetStringByDecimal(dtQuotasOld.Rows[i]["Q4"].ToString())
                        + ";   Total:" + GetStringByDecimal(dtQuotasOld.Rows[i]["Amount_Y"].ToString())
                        + "] \r\n";
                }
                if (!quotasOld.Equals("")) 
                {
                    quotasOld += "\r\n (by CNY .BSC SFX Rate:USD 1=CNY 6.15)";
                }

                DataTable dtQuotasNew = _contractBll.GetAopDealersByQueryByContractId(new Guid(this.hdContractID.Value.ToString())).Tables[0];
                
                for (int i = 0; i < dtQuotasNew.Rows.Count; i++)
                {
                    quotasNew = quotasNew + dtQuotasNew.Rows[i]["Year"].ToString() 
                        + ": [ Q1:" + GetStringByDecimal(dtQuotasNew.Rows[i]["Q1"].ToString()) 
                        + "; Q2:" + GetStringByDecimal(dtQuotasNew.Rows[i]["Q2"].ToString()) 
                        + "; Q3:" + GetStringByDecimal(dtQuotasNew.Rows[i]["Q3"].ToString()) 
                        + "; Q4:" + GetStringByDecimal(dtQuotasNew.Rows[i]["Q4"].ToString())
                        + ";   Total:" + GetStringByDecimal(dtQuotasNew.Rows[i]["Amount_Y"].ToString()) 
                        + "] \r\n";
                }
                if (!quotasNew.Equals(""))
                {
                    quotasNew += "\r\n (by CNY .BSC SFX Rate:USD 1=CNY 6.15)";
                }

                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Purchase Quota", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(quotasOld, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(quotasNew, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConRen.CreQuotaRemakrs, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);
                //Special Sales Program
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                string specialCurrent = "";
                if (ConRen.CreSpecialSalesCurrent != null && !ConRen.CreSpecialSalesCurrent.ToString().Equals("NA"))
                {
                    specialCurrent = ConRen.CreSpecialSalesCurrent.ToString() + "% of the quarter purchase ammount.";
                }

                string specialRenewal = "";
                if (ConRen.CreSpecialSalesRenewal != null && !ConRen.CreSpecialSalesRenewal.ToString().Equals("NA"))
                {
                    specialRenewal = ConRen.CreSpecialSalesRenewal.ToString() + "% of the quarter purchase ammount.";
                }
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Special Sales Program", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(specialCurrent, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(specialRenewal, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConRen.CreSpecialSalesRemarks, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);
                // Payment Term
                string oldPaymentString = "";
                if (ConRen.CrePaymentCurrent != null && ConRen.CrePaymentCurrent.ToString().Equals("Credit"))
                {
                    oldPaymentString = "Credit Term:" + ConRen.CreAccountCurrent + "days;Credit Limit:RMB" + ConRen.CreCreditLimitsCurrent + " (include VAT); Security Deposit: " + (String.IsNullOrEmpty(ConRen.CreSecurityDepositCurrent)?"NA":ConRen.CreSecurityDepositCurrent.ToString()) + "; in form of:" + (String.IsNullOrEmpty(ConRen.CreGuaranteeWayCurrent) ? "NA" : ConRen.CreGuaranteeWayCurrent.ToString());
                }
                else
                {
                    oldPaymentString = ConRen.CrePaymentCurrent.ToString();
                }
                string newPaymentString = "";
                if (ConRen.CrePaymentRenewal != null && ConRen.CrePaymentRenewal.ToString().Equals("Credit"))
                {
                    newPaymentString = "Credit Term:" + ConRen.CreAccountRenewal + "days;Credit Limit:RMB" + ConRen.CreCreditLimitsRenewal + " (include VAT); Security Deposit: " + (String.IsNullOrEmpty(ConRen.CreSecurityDepositRenewal)?"NA":ConRen.CreSecurityDepositRenewal.ToString()) + "; in form of:" + (String.IsNullOrEmpty(ConRen.CreGuaranteeWayRenewal) ? "NA" : ConRen.CreGuaranteeWayRenewal.ToString());
                }
                else 
                {
                    newPaymentString = String.IsNullOrEmpty(ConRen.CrePaymentRenewal) ? "" : ConRen.CrePaymentRenewal.ToString();
                }
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Payment Term", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(oldPaymentString, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(newPaymentString, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConRen.CrePaymentRemarks, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);
                ////Credit Limits
                //PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                //PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Credit Limits", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                //PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(base.GetStringByDecimal(ConRen.CreCreditLimitsCurrent), pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                //PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(base.GetStringByDecimal(ConRen.CreCreditLimitsRenewal), pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                //PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConRen.CreCreditLimitsRemarks, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);
                ////Security Deposit
                //PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                //PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph("Security Deposit", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                //PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(ConRen.CreSecurityDepositCurrent, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                //PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(ConRen.CreSecurityDepositRenewal, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                //PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConRen.CreSecurityDepositRemarks, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);

                PdfHelper.AddPdfTable(doc, standardTermGridTable);



                #endregion

                #region Sales Division Management Approvals
                PdfPTable sdmApprovalTable = new PdfPTable(6);
                sdmApprovalTable.SetWidths(new float[] { 4f, 20f, 23f, 20f, 23f, 10f });
                PdfHelper.InitPdfTableProperty(sdmApprovalTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Colspan = 6 }, sdmApprovalTable, null, null);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Sales Division Management Approvals:", PdfHelper.italicFont)) { BackgroundColor = BaseColor.CYAN, FixedHeight = 17f, PaddingTop = 1f, Colspan = 8 },
                    sdmApprovalTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("ZSM / RSM / Applicant:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(ConRen.CreRsmPrintName, pdfFont.answerChineseFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
               
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConRen.CreRsmDate,""), PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);

                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("NCM:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(ConRen.CreNcmPrintName, pdfFont.answerChineseFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
               
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConRen.CreNcmDate,""), PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);

                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("BUM / NSM:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(ConRen.CreNsmPrintName, pdfFont.answerChineseFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
             
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConRen.CreNsmDate,""), PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);

                PdfHelper.AddPdfTable(doc, sdmApprovalTable);

                #endregion

                #endregion

                #region Section 6- 13

                #region 副标题
                PdfPTable forNcmTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(forNcmTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f }, forNcmTable, null, null);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("For National Channel Manager: Please Complete Section 4 - 6", PdfHelper.italicFont)) { FixedHeight = 17f, PaddingTop = 1f, BackgroundColor = BaseColor.PINK },
                    forNcmTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                PdfHelper.AddPdfTable(doc, forNcmTable);

                #endregion

                #region 4.  Conflict of Other Exclusive Dealers:
                PdfPTable nonCompeteTable = new PdfPTable(8);
                nonCompeteTable.SetWidths(new float[] { 4f, 20f, 42f, 5f, 7f, 5f, 7f, 10f });
                PdfHelper.InitPdfTableProperty(nonCompeteTable);

                //4.  Conflict of Other Exclusive Dealers: 
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("4.  Conflict of Other Exclusive Dealers: ", PdfHelper.normalFont)) { Colspan = 8, FixedHeight = 25f }, nonCompeteTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                //第一行
                PdfHelper.AddEmptyPdfCell(nonCompeteTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If the business proposals above increase the current product line or territory of a dealer agreement, will it have", PdfHelper.normalFont)) { Colspan = 6, FixedHeight = 25f }, nonCompeteTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(nonCompeteTable);
                //第二行
                PdfHelper.AddEmptyPdfCell(nonCompeteTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("conflicts with any other current dealers' exclusive contract terms, or will it have potential conflicts with any newly", PdfHelper.normalFont)) { Colspan = 6, FixedHeight = 25f }, nonCompeteTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(nonCompeteTable);
                //第三行
                PdfHelper.AddEmptyPdfCell(nonCompeteTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("appointed dealers?", PdfHelper.normalFont)) { Colspan = 2, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                    nonCompeteTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddImageCell(this.AddCheckBox(ConRen.CreHasConflict), nonCompeteTable);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, nonCompeteTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(!ConRen.CreHasConflict), nonCompeteTable);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, nonCompeteTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(nonCompeteTable);
                //第四行
                PdfHelper.AddEmptyPdfCell(nonCompeteTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If yes, please state it:", PdfHelper.descFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, PaddingBottom = 5f },
                    nonCompeteTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConRen.CreConflictRemarks, pdfFont.answerChineseFont)) { Colspan = 5 },
                    nonCompeteTable, null, null);
                PdfHelper.AddEmptyPdfCell(nonCompeteTable);

                PdfHelper.AddPdfTable(doc, nonCompeteTable);
                #endregion


                #region 5.  Business Handover:
                PdfPTable businessHandoverTable = new PdfPTable(8);
                businessHandoverTable.SetWidths(new float[] { 4f, 20f, 42f, 5f, 7f, 5f, 7f, 10f });
                PdfHelper.InitPdfTableProperty(businessHandoverTable);

                //5.  Business Handover:
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("5.  Business Handover: ", PdfHelper.normalFont)) { Colspan = 8, FixedHeight = 25f }, businessHandoverTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                //第一行
                PdfHelper.AddEmptyPdfCell(businessHandoverTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If the business proposals above cut down the current product line or territory of a dealer agreement, who will", PdfHelper.normalFont)) { Colspan = 6, FixedHeight = 25f }, businessHandoverTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(businessHandoverTable);
                //第二行
                PdfHelper.AddEmptyPdfCell(businessHandoverTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("take over the abandoned business from this dealer?", PdfHelper.normalFont)) { Colspan = 6, FixedHeight = 25f }, businessHandoverTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(businessHandoverTable);
                //第三行
                PdfHelper.AddEmptyPdfCell(businessHandoverTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If so, please indicate:   ", PdfHelper.descFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, PaddingBottom = 5f }, businessHandoverTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConRen.CreBusinessHandover, pdfFont.answerChineseFont)) { Colspan = 5 }, businessHandoverTable, null, null);
                PdfHelper.AddEmptyPdfCell(businessHandoverTable);

                PdfHelper.AddPdfTable(doc, businessHandoverTable);
                #endregion


                //#region 6.  IAF Package Preparations:
                //PdfPTable conflictDealerTable = new PdfPTable(8);
                //conflictDealerTable.SetWidths(new float[] { 4f, 30f, 32f, 5f, 7f, 5f, 7f, 10f });
                //PdfHelper.InitPdfTableProperty(conflictDealerTable);

                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("6.  IAF Package Preparations:  ", PdfHelper.normalFont)) { Colspan = 8, FixedHeight = 25f },
                //    conflictDealerTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                //PdfHelper.AddEmptyPdfCell(conflictDealerTable);
                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Have you consolidated Dealer Renewal IAF and attached it to this form?  ", PdfHelper.normalFont)) { Colspan = 2, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                //    conflictDealerTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                //PdfHelper.AddImageCell(this.AddCheckBox(ConRen.CreHasiaf), conflictDealerTable);
                //PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, conflictDealerTable, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddImageCell(this.AddCheckBox(!ConRen.CreHasiaf), conflictDealerTable);
                //PdfHelper.AddPdfCell("No", PdfHelper.normalFont, conflictDealerTable, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddEmptyPdfCell(conflictDealerTable);

                //PdfHelper.AddPdfTable(doc, conflictDealerTable);
                //#endregion

                #region NCM Approval
                PdfPTable ncmApprovalTable = new PdfPTable(6);
                ncmApprovalTable.SetWidths(new float[] { 4f, 20f, 23f, 20f, 23f, 10f });
                PdfHelper.InitPdfTableProperty(ncmApprovalTable);
                ncmApprovalTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 6 });

                PdfHelper.AddEmptyPdfCell(ncmApprovalTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("NCM Signature:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT },
                    ncmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(ConRen.CreNcmForPart2PrintName, pdfFont.answerChineseFont, ncmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT },
                    ncmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConRen.CreNcmForPart2Date, ""), PdfHelper.answerFont, ncmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(ncmApprovalTable);

                ncmApprovalTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 6 });
                PdfHelper.AddPdfTable(doc, ncmApprovalTable);
                #endregion

                if (ConRen.CreDrmPrintName != null && !ConRen.CreDrmPrintName.ToString().Equals(""))
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
                    PdfHelper.AddPdfCellWithUnderLine(ConRen.CreDrmPrintName, pdfFont.answerChineseFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConRen.CreDrmDate, ""), PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(localManagementTable);
                    if (ConRen.CreFcPrintName != null && !ConRen.CreFcPrintName.ToString().Equals(""))
                    {
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Country Controller / Finance Manager:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(ConRen.CreFcPrintName, pdfFont.answerChineseFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);

                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConRen.CreFcDate, ""), PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                    }
                    if (ConRen.CreCdPrintName != null && !ConRen.CreCdPrintName.ToString().Equals(""))
                    {
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Country General Manager Director:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(ConRen.CreCdPrintName, pdfFont.answerChineseFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);

                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConRen.CreCdDate, ""), PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                    }
                    localManagementTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 6 });
                    PdfHelper.AddPdfTable(doc, localManagementTable);

                    #endregion
                }

                if (ConRen.CreVpfPrintName != null && !ConRen.CreVpfPrintName.ToString().Equals(""))
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
                    PdfHelper.AddPdfCellWithUnderLine(ConRen.CreVpfPrintName, PdfHelper.answerFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, regionalManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConRen.CreVpfDate, ""), PdfHelper.answerFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(regionalManagementTable);

                    PdfHelper.AddEmptyPdfCell(regionalManagementTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("EVP & President,\r\n Asia-Pacific:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, regionalManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(ConRen.CreVpapPrintName, PdfHelper.answerFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, regionalManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConRen.CreVpapDate, ""), PdfHelper.answerFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(regionalManagementTable);

                    PdfHelper.AddPdfTable(doc, regionalManagementTable);

                    #endregion
                }

                #region 授权
                doc.NewPage();

                string content = @"Territory:";
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

                PdfPTable TerritoryReamrkrable = new PdfPTable(3);
                TerritoryReamrkrable.SetWidths(new float[] { 4f, 86f, 10f });
                PdfHelper.InitPdfTableProperty(TerritoryReamrkrable);
                PdfHelper.AddEmptyPdfCell(TerritoryReamrkrable);
                PdfHelper.AddPdfCell(ConRen.CreTerritoryRemarks != null ? ConRen.CreTerritoryRemarks.ToString() : "", pdfFont.normalChineseFont, TerritoryReamrkrable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(TerritoryReamrkrable);
                PdfHelper.AddPdfTable(doc, TerritoryReamrkrable);

                #endregion

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
            DownloadFileForDCMS(fileName, "Appendix_3.pdf", "DCMS");
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
