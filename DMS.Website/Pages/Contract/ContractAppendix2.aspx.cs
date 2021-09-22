using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using DMS.Website.Common;
using DMS.Business.Contract;
using DMS.Model;
using DMS.Common;
using Lafite.RoleModel.Domain;
using System.Collections.Generic;
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
    using System.Web;

    public partial class ContractAppendix2 : BasePage
    {
        private IContractAmendmentService _amendment = new ContractAmendmentService();
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
            if (this.cbTerritory.Checked)
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
            if (this.cbQuota.Checked)
            {
                DataTable dtQuotas = _contractBll.GetAopDealersByQueryByContractId(new Guid(this.hdContractID.Value.ToString())).Tables[0];
                if (dtQuotas.Rows.Count > 0)
                {
                    this.QuotaNew.DataSource = dtQuotas;
                    this.QuotaNew.DataBind();
                }
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
            if (dtQuotasHospital.Rows.Count == 0) 
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
            if (this.cbQuotaHospital.Checked)
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
            if (this.cbQuotaHospital.Checked)
            {
                int totalCount = 0;
                DataTable dtQuotasHospitalProduct = _contractBll.GetICAopDealersHospitalUnitByQuery(new Guid(this.hdContractID.Value.ToString()), (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
                (this.AopHospitalProductNew.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

                this.AopHospitalProductNew.DataSource = dtQuotasHospitalProduct;
                this.AopHospitalProductNew.DataBind();
            }
        }

        #endregion

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

        private void BindPageData()
        {
            ContractAmendment amendment = _amendment.GetContractAmendmentByID(new Guid(this.hdContractID.Value.ToString()));
            DataTable dtDivision = _contractBll.GetDivision(String.Empty).Tables[0];
            #region 赋值
            if (dtDivision.Rows.Count > 0)
            {
                this.rgDivision.Items.Clear();
                for (int i = 0; i < dtDivision.Rows.Count; i++)
                {
                    Radio rd = new Radio();
                    rd.ReadOnly = true;
                    rd.ID = "radioDivision" + dtDivision.Rows[i]["DivisionName"].ToString();
                    rd.BoxLabel = dtDivision.Rows[i]["DivisionName"].ToString();
                    if (amendment.CamDivision != null)
                    {
                        if (amendment.CamDivision.ToLower().Equals(dtDivision.Rows[i]["DivisionName"].ToString().ToLower()))
                        {
                            rd.Checked = true;
                            this.hdDivisionId.Value = dtDivision.Rows[i]["DivisionCode"].ToString();

                            if (dtDivision.Rows[i]["DivisionName"].ToString().ToLower().Equals("cardio") || dtDivision.Rows[i]["DivisionName"].ToString().ToLower().Equals("sh") || (amendment.CamMarketType != null && amendment.CamMarketType.ToString().Equals("1")))
                            {
                                this.cbQuota.BoxLabel = "Purchase Quota (CNY, exclude VAT), " + SR.Const_ExchangeRate;
                                this.cbQuotaHospital.BoxLabel = "Purchase Quota By Hospital (CNY, exclude VAT), " + SR.Const_ExchangeRate;

                                this.gpQuotaHospitalOld.Hidden = false;
                                this.gpHospitalProductOld.Hidden = true;
                                this.gpQuotaHospitalNew.Hidden = false;
                                this.gpAopHospitalProductNew.Hidden = true;
                            }
                            else
                            {
                                this.gpQuotaHospitalOld.Hidden = false;
                                this.gpHospitalProductOld.Hidden = true;
                                this.gpQuotaHospitalNew.Hidden = false;
                                this.gpAopHospitalProductNew.Hidden = true;
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

            if (amendment != null) 
            {
                this.laSubBU.Text = amendment.CamSubdepName;
                this.hdDmaId.Text = amendment.CamDmaId.ToString();
                this.hdIsEmerging.Value = amendment.CamMarketType;
                this.tfDealerName.Text = amendment.CamDealerName;
                this.hdSubDepCode.Value = amendment.CamSubDepid;
                if (amendment.CamAgreementEffectiveDate != null)
                {
                    dfAgreeEffectiveDate.Value = Convert.ToDateTime(amendment.CamAgreementEffectiveDate).ToShortDateString();
                }
                if (amendment.CamAgreementExpirationDate != null)
                {
                    dfAgreeExpirationDate.Value = Convert.ToDateTime(amendment.CamAgreementExpirationDate).ToShortDateString();
                }
                if (amendment.CamAmendmentEffectiveDate != null)
                {
                    dfAmendEffectiveDate.Value = Convert.ToDateTime(amendment.CamAmendmentEffectiveDate).ToShortDateString();
                }
                if (amendment.CamStandardAmendment != null) 
                {
                    this.cbStandard.Checked = Convert.ToBoolean(amendment.CamStandardAmendment);
                }
                
                if (!String.IsNullOrEmpty(amendment.CamProductLineOld)) 
                {
                    if (amendment.CamProductLineOld.ToLower().Equals("all"))
                    {
                        this.tfProductLine.Text = "All products ";
                    }
                    else 
                    {
                        this.tfProductLine.Text = amendment.CamProductLineOld == null ? "" : ParseTags(amendment.CamProductLineOld.Replace("&emsp;", "").Replace("<br/>", ""));
                    }
                }
                this.cbProductLine.Checked = (amendment.CamProductLineIsChange==null? false :amendment.CamProductLineIsChange.Value);
                if (GetCheckDate(amendment.CamProductLineIsChange))
                {
                    if (base.GetObjectDate(amendment.CamProductLineNew).ToLower().Equals("all"))
                    {
                        this.tfChangedProductLine.Text = "All products of " + amendment.CamSubdepName;
                        if (amendment.CamProductLineRemarks != null)
                        {
                            this.tfProductLineRemarks.Text = ParseTags(amendment.CamProductLineRemarks.ToString().Replace("&emsp;", "").Replace("<br/>", ""));
                        }
                    }
                    else
                    {
                        this.tfChangedProductLine.Text = base.GetObjectDate(amendment.CamProductLineNew == null ? "" : ParseTags(amendment.CamProductLineNew.Replace("&emsp;", "").Replace("<br/>", "")));
                        if (amendment.CamProductLineRemarks != null)
                        {
                            this.tfProductLineRemarks.Text = base.GetObjectDate(ParseTags(amendment.CamProductLineRemarks).Replace("&emsp;", "").Replace("<br/>", ""));
                        }
                    }
                }
                //this.tfProductLineRemarks.Text = amendment.CamProductLineRemarks.Replace("&emsp;", "").Replace("<br/>", "");
                //this.tfTerritoryRemarks.Text = amendment.CamTerritoryRemarks;
                //this.tfQuotaRemarks.Text = amendment.CamQuotaRemakrs;

                tfOATPrices.Text = amendment.CamPriceOld == null ? "" : ParseTags(amendment.CamPriceOld.ToString().Replace("&emsp;", "").Replace("<br/>", ""));
                tfChangedPrices.Text = amendment.CamPriceNew == null ? "" : (ParseTags(amendment.CamPriceNew.ToString().Replace("&emsp;", "").Replace("<br/>", "")) + "% off standard price list");
                this.cbPrices.Checked = amendment.CamPriceIsChange == null ? false : amendment.CamPriceIsChange.Value;

                tfRemarksPrices.Text = amendment.CamPriceRemarks == null ? "" : ParseTags(amendment.CamPriceRemarks.Replace("&emsp;", "").Replace("<br/>", ""));
                tfOATPayment.Text = amendment.CamPaymentOld;
                tfChangedPayment.Text = amendment.CamPaymentNew;
                this.cbPayment.Checked = amendment.CamPaymentIsChange == null ? false : amendment.CamPaymentIsChange.Value;
                tfRemarksPayment.Text = amendment.CamPaymentRemarks;

                if (amendment.CamHasConflict != null) 
                {
                    if (Convert.ToBoolean(amendment.CamHasConflict))
                    {
                        this.radioHasConflictYes.Checked = true;
                    }
                    else 
                    {
                        this.radioHasConflictNo.Checked = true;
                    }
                }
                this.tfHasConflictRemarks.Text = amendment.CamConflictRemarks;
                this.tfBusinessHandover.Text = amendment.CamBusinessHandover;

                this.cbTerritory.Checked = amendment.CamTerritoryIsChange == null ? false : amendment.CamTerritoryIsChange.Value;

                this.cbQuota.Checked = amendment.CamQuotaIsChange == null ? false : amendment.CamQuotaIsChange.Value;
                this.cbQuotaHospital.Checked = amendment.CamQuotaIsChange == null ? false : amendment.CamQuotaIsChange.Value;

                this.cbSpecialAmendment.Checked = amendment.CamSpecialIsChange == null ? false : amendment.CamSpecialIsChange.Value;

                string SpecialRemrak="";
                if (amendment.CamSpecialAmendment != null)
                {
                    if (!amendment.CamSpecialAmendment.ToString().Equals("NA"))
                    {
                        SpecialRemrak = amendment.CamSpecialAmendment + "% of the quarter purchase ammount.  ";
                    }
                    this.tfSpecialAmendmentRemraks.Text = SpecialRemrak + amendment.CamSpecialAmendmentRemraks;
                }
                if (amendment.CamAmendmentReason!=null)
                this.tfAmendmentReasons.Text = amendment.CamAmendmentReason.ToString();
            }

            #endregion

            #region 补充协议权限
            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation.ToString()) && amendment.CamStatus != null && amendment.CamStatus.Equals(ContractStatus.Completed.ToString()))
            {
                if (this.hdDealerType.Value.Equals(DealerType.T1.ToString()) || this.hdDealerType.Value.Equals(DealerType.LP.ToString()))
                {
                    this.btnSupplementary.Hidden = false;
                }
            }

            if (RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString())) 
            {
                if (this.hdDealerType.Value.Equals(DealerType.T2.ToString()) && amendment.CamStatus != null && amendment.CamStatus.Equals(ContractStatus.Completed.ToString()))
                {
                    this.btnSupplementary.Hidden = true;
                }
            }
            #endregion
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

        private bool GetCheckDate(bool? value) 
        {
            if (value != null)
            {
                return value.Value;
            }
            else 
            {
                return false;
            }
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
                ContractAmendment ConEdit = _amendment.GetContractAmendmentByID(new Guid(this.hdContractID.Value.ToString()));
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hdContractID.Value.ToString()); //合同ID
                DataTable provinces = _contractBll.GetProvincesForAreaSelected(obj).Tables[0];
                DataTable dtTerritorynew = _contractBll.GetContractTerritoryByContractId(new Guid(this.hdContractID.Value.ToString())).Tables[0];


                if (provinces.Rows.Count > 0) 
                {
                    isArear = true;
                }
                string oldTerritory = "";
                string newTerritory = "";

                if (!isArear)
                {

                    HospitalListHistory history = new HospitalListHistory();
                    history.ChangeToContractid = new Guid(this.hdContractID.Value.ToString());
                    DataTable dtTerritoryold = _contractBll.GetHistoryAuthorizedHospital(history).Tables[0];
                    if (dtTerritoryold.Rows.Count == 0 && !this.hdContStatus.Value.ToString().Equals("Completed"))
                    {
                        Hashtable table = new Hashtable();
                        table.Add("DivisionId", this.hdDivisionId.Value.ToString());
                        table.Add("SubDepCode", this.hdSubDepCode.Value.ToString());
                        table.Add("DmaId", this.hdDmaId.Value.ToString());
                        if (!this.hdIsEmerging.Value.ToString().Equals("2"))
                        {
                            table.Add("IsEmerging", this.hdIsEmerging.Value.ToString().Equals("") ? "0" : this.hdIsEmerging.Value.ToString());
                        }

                        dtTerritoryold = _contractBll.GetFormalAuthorizedHospital(table).Tables[0];
                    }


                    for (int i = 0; i < dtTerritoryold.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            oldTerritory = dtTerritoryold.Rows.Count + "Hospital(s) \r\n";
                        }
                        oldTerritory = oldTerritory + (i + 1) + ". " + dtTerritoryold.Rows[i]["HospitalNameEN"].ToString() + "\r\n";
                    }
                    
                    for (int i = 0; i < dtTerritorynew.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            newTerritory = dtTerritorynew.Rows.Count + "Hospital(s) \r\n";
                        }
                        newTerritory = newTerritory + (i + 1) + ". " + dtTerritorynew.Rows[i]["HospitalENName"].ToString() + "\r\n";
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
                        oldTerritory = oldTerritory + (i + 1) + ". " + oldprovinces.Rows[i]["Description"].ToString() + "\r\n";
                    }

                    for (int i = 0; i < provinces.Rows.Count; i++)
                    {
                        newTerritory = newTerritory + (i + 1) + ". " + provinces.Rows[i]["Description"].ToString() + "\r\n";
                    }

                    DataTable queryOldHos = _contractBll.GetPartAreaExcHospitalOld(objArea).Tables[0];
                    for (int i = 0; i < queryOldHos.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            oldTerritory += ("\r\n" + " Regional Exclusion Of Hospitals" + "\r\n");
                        }
                        oldTerritory += (queryOldHos.Rows[i]["HosHospitalNameEN"].ToString() + "\r\n");
                    }

                    DataTable queryNewHos = _contractBll.GetPartAreaExcHospitalTemp(obj).Tables[0];
                    for (int i = 0; i < queryNewHos.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            newTerritory += ("\r\n" + " Regional Exclusion Of Hospitals" + "\r\n");
                        }
                        newTerritory += (queryNewHos.Rows[i]["HosHospitalNameEN"].ToString() + "\r\n");
                    }
                }
              

                string oldQuotasString = "";
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
                    oldQuotasString = oldQuotasString + " [" + dtQuotasOld.Rows[i]["Year"].ToString()
                                        + ":  Q1:" + GetStringByDecimal(dtQuotasOld.Rows[i]["Q1"].ToString())
                                        + " Q2:" + GetStringByDecimal(dtQuotasOld.Rows[i]["Q2"].ToString())
                                        + " Q3:" + GetStringByDecimal(dtQuotasOld.Rows[i]["Q3"].ToString())
                                        + " Q4:" + GetStringByDecimal(dtQuotasOld.Rows[i]["Q4"].ToString())
                                        + "   Total:" + GetStringByDecimal(dtQuotasOld.Rows[i]["Amount_Y"].ToString())
                                        + "] \r\n";

                }
                if (!oldQuotasString.Equals(""))
                {
                    oldQuotasString += "\r\n(by CNY .BSC SFX Rate:USD 1=CNY 6.15)";
                }

                string newQuotasString = "";
                DataTable dtQuotasnew = _contractBll.GetAopDealersByQueryByContractId(new Guid(this.hdContractID.Value.ToString())).Tables[0];
                for (int i = 0; i < dtQuotasnew.Rows.Count; i++) 
                {
                    newQuotasString = newQuotasString + " [" + dtQuotasnew.Rows[i]["Year"].ToString()
                                        + ":  Q1:" + GetStringByDecimal(dtQuotasnew.Rows[i]["Q1"].ToString())
                                        + " Q2:" + GetStringByDecimal(dtQuotasnew.Rows[i]["Q2"].ToString())
                                        + " Q3:" + GetStringByDecimal(dtQuotasnew.Rows[i]["Q3"].ToString())
                                        + " Q4:" + GetStringByDecimal(dtQuotasnew.Rows[i]["Q4"].ToString())
                                        + "    Total:" + GetStringByDecimal(dtQuotasnew.Rows[i]["Amount_Y"].ToString())
                                        + "] \r\n";
                }
                if (!newQuotasString.Equals("")) 
                {
                    newQuotasString += "\r\n(by CNY .BSC SFX Rate:USD 1=CNY 6.15)";
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
                PdfPCell titleCell = new PdfPCell(new Paragraph("BSC China & HK Dealer Agreement Amendment Application Form ", PdfHelper.boldFont));
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
                PdfHelper.AddImageCell(this.AddCheckBox(ConEdit.CamDivision, DivisionName.Cardio.ToString()), divisionTable);
                PdfHelper.AddPdfCell("Cardio", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //CRM
                PdfHelper.AddImageCell(this.AddCheckBox(ConEdit.CamDivision, DivisionName.CRM.ToString()), divisionTable);
                PdfHelper.AddPdfCell("CRM", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Endo
                PdfHelper.AddImageCell(this.AddCheckBox(ConEdit.CamDivision, DivisionName.Endo.ToString()), divisionTable);
                PdfHelper.AddPdfCell("Endo", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //EP
                PdfHelper.AddImageCell(this.AddCheckBox(ConEdit.CamDivision, DivisionName.EP.ToString()), divisionTable);
                PdfHelper.AddPdfCell("EP", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //PI
                PdfHelper.AddImageCell(this.AddCheckBox(ConEdit.CamDivision, DivisionName.PI.ToString()), divisionTable);
                PdfHelper.AddPdfCell("PI", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Uro
                PdfHelper.AddImageCell(this.AddCheckBox(ConEdit.CamDivision, DivisionName.Uro.ToString()), divisionTable);
                PdfHelper.AddPdfCell("Uro", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //Asthma
                PdfHelper.AddImageCell(this.AddCheckBox(ConEdit.CamDivision, DivisionName.AS.ToString()), divisionTable);
                PdfHelper.AddPdfCell("Asthma", PdfHelper.normalFont, divisionTable, Rectangle.ALIGN_LEFT);

                //SH
                PdfHelper.AddImageCell(this.AddCheckBox(ConEdit.CamDivision, DivisionName.SH.ToString()), divisionTable);
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

                #region 2. Basic Information of the Dealer
                PdfPTable basicDealerInfoTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(basicDealerInfoTable);

                //Dealer Info Label
                PdfHelper.AddPdfCell("2. Basic Information of the Current Agreement:",
                    PdfHelper.normalFont, basicDealerInfoTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, basicDealerInfoTable);

                #region Dealer Name
                //Dealer Name
                PdfPTable dealerNameTable = new PdfPTable(4);
                dealerNameTable.SetWidths(new float[] { 4f, 27f, 64f, 10f });
                PdfHelper.InitPdfTableProperty(dealerNameTable);
                PdfHelper.AddEmptyPdfCell(dealerNameTable);

                //Dealer Name 
                PdfHelper.AddPdfCell("Dealer Name:", PdfHelper.normalFont, dealerNameTable, Rectangle.ALIGN_LEFT);
                //Dealer Name Answer
                PdfHelper.AddPdfCellWithUnderLine(ConEdit.CamDealerName, pdfFont.answerChineseFont, dealerNameTable, null);

                PdfHelper.AddEmptyPdfCell(dealerNameTable);
                PdfHelper.AddPdfTable(doc, dealerNameTable);

                #endregion

                #region Agreement Info(Date)
                PdfPTable agreementInfoTable = new PdfPTable(7);
                agreementInfoTable.SetWidths(new float[] { 4f, 27f, 16f, 4f, 27f, 16f, 10f });
                PdfHelper.InitPdfTableProperty(agreementInfoTable);
                //Agreement Effective Date and Expiration Date
                PdfHelper.AddEmptyPdfCell(agreementInfoTable);

                PdfHelper.AddPdfCell("Agreement Effective Date:", PdfHelper.normalFont, agreementInfoTable, Rectangle.ALIGN_LEFT);
                //Agreement Effective Date:
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConEdit.CamAgreementEffectiveDate, null), PdfHelper.answerFont, agreementInfoTable, null);
                //Agreement Expiration Date:
                PdfHelper.AddEmptyPdfCell(agreementInfoTable);
                PdfHelper.AddPdfCell("Agreement Expiration Date:", PdfHelper.normalFont, agreementInfoTable, Rectangle.ALIGN_LEFT);
                //Agreement Expiration Date:
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConEdit.CamAgreementExpirationDate, null), PdfHelper.answerFont, agreementInfoTable, null);

                //Empty Cell
                PdfHelper.AddEmptyPdfCell(agreementInfoTable);
                PdfHelper.AddPdfTable(doc, agreementInfoTable);
                #endregion

                #region Amendment Info(Date)
                PdfPTable amendmentInfoTable = new PdfPTable(7);
                amendmentInfoTable.SetWidths(new float[] { 4f, 27f, 16f, 4f, 27f, 16f, 10f });
                PdfHelper.InitPdfTableProperty(amendmentInfoTable);

                //Amendment Effective Date:
                PdfHelper.AddEmptyPdfCell(amendmentInfoTable);
                PdfHelper.AddPdfCell("Amendment Effective Date:", PdfHelper.normalFont, amendmentInfoTable, Rectangle.ALIGN_LEFT);
                //Amendment Effective Date:
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConEdit.CamAmendmentEffectiveDate, null), PdfHelper.answerFont, amendmentInfoTable, null);

                PdfHelper.AddEmptyPdfCell(amendmentInfoTable);
                PdfHelper.AddEmptyPdfCell(amendmentInfoTable);
                PdfHelper.AddEmptyPdfCell(amendmentInfoTable);
                //Empty Cell
                PdfHelper.AddEmptyPdfCell(amendmentInfoTable);
                PdfHelper.AddPdfTable(doc, amendmentInfoTable);
                #endregion

                #region Reason
                //Reason
                PdfPTable reasonTable = new PdfPTable(4);
                reasonTable.SetWidths(new float[] { 4f, 27f, 64f, 10f });
                PdfHelper.InitPdfTableProperty(reasonTable);
                PdfHelper.AddEmptyPdfCell(reasonTable);

                //Reasons
                PdfHelper.AddPdfCell("Purpose:", PdfHelper.normalFont, reasonTable, Rectangle.ALIGN_LEFT);
                //Reasons Answer
                PdfHelper.AddPdfCellWithUnderLine(ConEdit.CamAmendmentReason, pdfFont.answerChineseFont, reasonTable, null);

                PdfHelper.AddEmptyPdfCell(reasonTable);
                PdfHelper.AddPdfTable(doc, reasonTable);

                #endregion


                #endregion

                #region 3. Agreement Term Amendment Descriptions:
                PdfPTable supportDocTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(supportDocTable);

                //Agreement Term Amendment Descriptions Label
                PdfHelper.AddPdfCell("3. Agreement Term Amendment Descriptions:", PdfHelper.normalFont, supportDocTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, supportDocTable);

                //Standard Term Amendment:
                PdfPTable standardTermTable = new PdfPTable(3);
                standardTermTable.SetWidths(new float[] { 4f, 4f, 96f });
                PdfHelper.InitPdfTableProperty(standardTermTable);
                PdfHelper.AddEmptyPdfCell(standardTermTable);

                //CamStandardAmendment
                PdfHelper.AddImageCell(this.AddCheckBox(ConEdit.CamStandardAmendment), standardTermTable);
                PdfHelper.AddPdfCell("Standard Term Amendment:", PdfHelper.italicFont, standardTermTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, standardTermTable);

                //Standard Term Amendment Grid:
                PdfPTable standardTermGridTable = new PdfPTable(6);
                standardTermGridTable.SetWidths(new float[] { 5f, 4f, 16f, 25f, 25f, 25f });
                PdfHelper.InitPdfTableProperty(standardTermGridTable);

                //表头
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.normalFont)) {  Colspan = 2, BackgroundColor = BaseColor.GRAY }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Original Agreement Term", PdfHelper.normalFont)) {  Colspan = 1, BackgroundColor = BaseColor.GRAY }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Changed To", PdfHelper.normalFont)) { Colspan = 1, BackgroundColor = BaseColor.GRAY }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Remarks", PdfHelper.normalFont)) { Colspan = 1, BackgroundColor = BaseColor.GRAY }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM, true, true, true, true);
                //Product Line
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderCenter(this.AddCheckBox(ConEdit.CamProductLineIsChange), standardTermGridTable, null, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Product Line", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(ConEdit.CamProductLineOld == null ? "0" : ParseTags(ConEdit.CamProductLineOld.Replace("&emsp;", "").Replace("<br/>", "")), PdfHelper.answerFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(this.tfChangedProductLine.Text, PdfHelper.answerFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConEdit.CamProductLineRemarks == null ? "" : ParseTags(ConEdit.CamProductLineRemarks.Replace("&emsp;", "").Replace("<br/>", "")), pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);
                //Prices
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderCenter(this.AddCheckBox(ConEdit.CamPriceIsChange), standardTermGridTable, null, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Prices", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(ConEdit.CamPriceOld == null ? "" : ParseTags(ConEdit.CamPriceOld.Replace("&emsp;", "").Replace("<br/>", "")), PdfHelper.answerFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                string strPrice = "";
                if (ConEdit.CamPriceNew != null) 
                {
                    strPrice = ConEdit.CamPriceNew + "% off standard price list";
                }
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(strPrice, PdfHelper.answerFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConEdit.CamPriceRemarks == null ? "" : ParseTags(ConEdit.CamPriceRemarks.Replace("&emsp;", "").Replace("<br/>", "")), pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);
                //Territory (Hospitals)
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderCenter(this.AddCheckBox(ConEdit.CamTerritoryIsChange), standardTermGridTable, null, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Territory (Hospitals)", PdfHelper.answerFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(oldTerritory, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(ConEdit.CamTerritoryIsChange.Value ? newTerritory : "", pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);
                //Purchase Quota
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderCenter(this.AddCheckBox(ConEdit.CamQuotaIsChange), standardTermGridTable, null, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Purchase Quota", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(oldQuotasString, PdfHelper.answerFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(ConEdit.CamQuotaIsChange.Value?newQuotasString:"", PdfHelper.answerFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);


                //Special Program Amendment:
                string SpecialRemrak = "";
                if (ConEdit.CamSpecialAmendment != null)
                {
                    if (!ConEdit.CamSpecialAmendment.ToString().Equals("NA"))
                    {
                        SpecialRemrak = ConEdit.CamSpecialAmendment + "% of the quarter purchase ammount.  ";
                    }
                }
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderCenter(this.AddCheckBox(Convert.ToBoolean(ConEdit.CamSpecialIsChange)), standardTermGridTable, null, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Special Sales Program", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(ConEdit.CamSpecialOld, PdfHelper.answerFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(SpecialRemrak, PdfHelper.answerFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConEdit.CamSpecialAmendmentRemraks, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);
                
                
                //Payment Term
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderCenter(this.AddCheckBox(ConEdit.CamPaymentIsChange), standardTermGridTable, null, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Payment Term", PdfHelper.normalFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(ConEdit.CamPaymentOld, PdfHelper.answerFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Paragraph(ConEdit.CamPaymentNew, PdfHelper.answerFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(ConEdit.CamPaymentRemarks, pdfFont.answerChineseFont)) { Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false, true, true, true);

                PdfHelper.AddPdfTable(doc, standardTermGridTable);


                //Special Program Amendment:
                //PdfPTable specialProgramTable = new PdfPTable(3);
                //specialProgramTable.SetWidths(new float[] { 4f, 4f, 96f });
                //PdfHelper.InitPdfTableProperty(specialProgramTable);
                //PdfHelper.AddEmptyPdfCell(specialProgramTable);

                //PdfHelper.AddImageCell(this.AddCheckBox(Convert.ToBoolean(ConEdit.CamSpecialIsChange)), specialProgramTable);
                //PdfHelper.AddPdfCell("Special Program Amendment:", PdfHelper.italicFont, specialProgramTable, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddPdfTable(doc, specialProgramTable);

                ////Please State Here:
                //PdfPTable pleaseStateHereTable = new PdfPTable(4);
                //pleaseStateHereTable.SetWidths(new float[] { 14f, 27f, 54f, 10f });
                //PdfHelper.InitPdfTableProperty(pleaseStateHereTable);
                //PdfHelper.AddEmptyPdfCell(pleaseStateHereTable);

                ////Please State Here:
                //PdfHelper.AddPdfCell("Please State Here:", PdfHelper.normalFont, pleaseStateHereTable, Rectangle.ALIGN_LEFT);
                ////Please State Here: Answer
                //string SpecialRemrak = "";
                //if (ConEdit.CamSpecialAmendment != null) 
                //{
                //    if (!ConEdit.CamSpecialAmendment.ToString().Equals("NA"))
                //    {
                //        SpecialRemrak = ConEdit.CamSpecialAmendment + "% of the quarter purchase ammount.  ";
                //    }

                //    SpecialRemrak += ConEdit.CamSpecialAmendmentRemraks;
                //}
                //PdfHelper.AddPdfCellWithUnderLine(SpecialRemrak, pdfFont.answerChineseFont, pleaseStateHereTable, null);

                //PdfHelper.AddEmptyPdfCell(pleaseStateHereTable);
                //PdfHelper.AddPdfTable(doc, pleaseStateHereTable);
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
                PdfHelper.AddPdfCellWithUnderLine(ConEdit.CamRsmPrintName, pdfFont.answerChineseFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConEdit.CamRsmDate, null), PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);

                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("NCM:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(ConEdit.CamNcmPrintName, pdfFont.answerChineseFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConEdit.CamNcmDate, null), PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);

                PdfHelper.AddEmptyPdfCell(sdmApprovalTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("BUM / NSM:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(ConEdit.CamNsmPrintName, pdfFont.answerChineseFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, sdmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(base.GetStringByDate(ConEdit.CamNsmDate, null), PdfHelper.answerFont, sdmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
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
                PdfHelper.AddImageCell(this.AddCheckBox(ConEdit.CamHasConflict), nonCompeteTable);
                PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, nonCompeteTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddImageCell(this.AddCheckBox(!ConEdit.CamHasConflict), nonCompeteTable);
                PdfHelper.AddPdfCell("No", PdfHelper.normalFont, nonCompeteTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddEmptyPdfCell(nonCompeteTable);
                //第四行
                PdfHelper.AddEmptyPdfCell(nonCompeteTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If yes, please state it:", PdfHelper.descFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, PaddingBottom = 5f },
                    nonCompeteTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConEdit.CamConflictRemarks, pdfFont.answerChineseFont)) { Colspan = 5 },
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
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If the business proposals above cut down the current product line, territories or purchase quotas of a dealer", PdfHelper.normalFont)) { Colspan = 6, FixedHeight = 25f }, businessHandoverTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(businessHandoverTable);
                //第二行
                PdfHelper.AddEmptyPdfCell(businessHandoverTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("agreement,who will take over the abandoned business from this dealer?", PdfHelper.normalFont)) { Colspan = 6, FixedHeight = 25f }, businessHandoverTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(businessHandoverTable);
                //第三行
                PdfHelper.AddEmptyPdfCell(businessHandoverTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("If yes, please state it:", PdfHelper.descFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, PaddingBottom = 5f }, businessHandoverTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(ConEdit.CamBusinessHandover, pdfFont.answerChineseFont)) { Colspan = 5 }, businessHandoverTable, null, null);
                PdfHelper.AddEmptyPdfCell(businessHandoverTable);

                PdfHelper.AddPdfTable(doc, businessHandoverTable);
                #endregion


                //#region 6.  Supplementary Letter Preparation:
                //PdfPTable conflictDealerTable = new PdfPTable(8);
                //conflictDealerTable.SetWidths(new float[] { 4f, 30f, 32f, 5f, 7f, 5f, 7f, 10f });
                //PdfHelper.InitPdfTableProperty(conflictDealerTable);

                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("6.  Supplementary Letter Preparation: ", PdfHelper.normalFont)) { Colspan = 8, FixedHeight = 25f },
                //    conflictDealerTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                //PdfHelper.AddEmptyPdfCell(conflictDealerTable);
                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Have you drafted a supplementary letter and attached it to this form? ", PdfHelper.normalFont)) { Colspan = 2, FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT },
                //    conflictDealerTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                //PdfHelper.AddImageCell(this.AddCheckBox(ConEdit.CamSupplementaryLetter), conflictDealerTable);
                //PdfHelper.AddPdfCell("Yes", PdfHelper.normalFont, conflictDealerTable, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddImageCell(this.AddCheckBox(!ConEdit.CamSupplementaryLetter), conflictDealerTable);
                //PdfHelper.AddPdfCell("No", PdfHelper.normalFont, conflictDealerTable, Rectangle.ALIGN_LEFT);
                //PdfHelper.AddEmptyPdfCell(conflictDealerTable);

                //PdfHelper.AddPdfTable(doc, conflictDealerTable);
                //#endregion

                #region NCM Approval
                PdfPTable ncmApprovalTable = new PdfPTable(6);
                ncmApprovalTable.SetWidths(new float[] { 4f, 20f, 23f, 20f, 23f, 10f });
                PdfHelper.InitPdfTableProperty(ncmApprovalTable);

                PdfHelper.AddEmptyPdfCell(ncmApprovalTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("NCM Signature:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT },
                    ncmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(ConEdit.CamNcmForPart2PrintName, pdfFont.answerChineseFont, ncmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT },
                    ncmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConEdit.CamNcmForPart2Date, ""), PdfHelper.answerFont, ncmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(ncmApprovalTable);


                PdfHelper.AddEmptyPdfCell(ncmApprovalTable);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Verified By: ", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT },
                    ncmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.answerFont, ncmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT },
                    ncmApprovalTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine("", PdfHelper.answerFont, ncmApprovalTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(ncmApprovalTable);

                PdfHelper.AddPdfTable(doc, ncmApprovalTable);
                #endregion

                #endregion
                if (ConEdit.CamDrmPrintName != null && !ConEdit.CamDrmPrintName.ToString().Equals(""))
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
                    PdfHelper.AddPdfCellWithUnderLine(ConEdit.CamDrmPrintName, pdfFont.answerChineseFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConEdit.CamDrmDate, ""), PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(localManagementTable);
                    if (ConEdit.CamFcPrintName != null && !ConEdit.CamFcPrintName.ToString().Equals(""))
                    {
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Country Controller / Finance Manager:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(ConEdit.CamFcPrintName, pdfFont.answerChineseFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);

                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConEdit.CamFcDate, ""), PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                    }
                    if (ConEdit.CamCdPrintName != null && !ConEdit.CamCdPrintName.ToString().Equals(""))
                    {
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Country General Manager Director:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(ConEdit.CamCdPrintName, pdfFont.answerChineseFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);

                        PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, localManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConEdit.CamCdDate, ""), PdfHelper.answerFont, localManagementTable, null, Rectangle.ALIGN_BOTTOM);
                        PdfHelper.AddEmptyPdfCell(localManagementTable);
                    }

                    localManagementTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 6 });
                    PdfHelper.AddPdfTable(doc, localManagementTable);

                    #endregion
                }

                if (ConEdit.CamVpfPrintName != null && !ConEdit.CamVpfPrintName.ToString().Equals(""))
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
                    PdfHelper.AddPdfCellWithUnderLine(ConEdit.CamVpfPrintName, pdfFont.answerChineseFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, regionalManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConEdit.CamVpfDate, ""), PdfHelper.answerFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(regionalManagementTable);

                    PdfHelper.AddEmptyPdfCell(regionalManagementTable);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("EVP & President,\r\n Asia-Pacific:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, regionalManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(ConEdit.CamVpapPrintName, pdfFont.answerChineseFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = PdfHelper.APPROVAL_FIXED_HEIGHT, PaddingRight = PdfHelper.APPROVAL_PADDING_RIGHT }, regionalManagementTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(GetStringByDate(ConEdit.CamVpapDate, ""), PdfHelper.answerFont, regionalManagementTable, null, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddEmptyPdfCell(regionalManagementTable);

                    PdfHelper.AddPdfTable(doc, regionalManagementTable);

                    #endregion
                }

                if (ConEdit.CamTerritoryIsChange.Value)
                {
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
                    //PdfHelper.AddPdfCell(ConEdit.CamTerritoryRemarks !=null?ConEdit.CamTerritoryRemarks.ToString():"", pdfFont.normalChineseFont, TerritoryReamrkrable, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddEmptyPdfCell(TerritoryReamrkrable);
                    PdfHelper.AddEmptyPdfCell(TerritoryReamrkrable);
                    PdfHelper.AddPdfTable(doc, TerritoryReamrkrable);

                    #endregion
                }
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
            DownloadFileForDCMS(fileName, "Appendix_2.pdf", "DCMS");
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

        private PdfPCell AddCheckBox(string str)
        {
            #region Public Element
            PdfPCell noSelectCell = PdfHelper.GetNoSelectImageCell();
            PdfPCell SelectCell = PdfHelper.GetYesSelectImageCell();
            #endregion

            if (str != null)
            {
                return SelectCell;
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
