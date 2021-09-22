using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Contract
{
    using DMS.Model;
    using DMS.Business;
    using DMS.Business.Cache;
    using DMS.Common;
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using Microsoft.Practices.Unity;
    using System.Data;
    using System.Collections;
    public partial class ContractDealerHospitalProductAOPQuery : BasePage
    {
        private IContractMasterBLL _contractMasterBll = new ContractMasterBLL();
        private IContractCommonBLL _contractCommon = new ContractCommonBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (this.Request.QueryString["InstanceID"] != null &&
                    this.Request.QueryString["DivisionID"] != null &&
                    this.Request.QueryString["TempDealerID"] != null &&
                    this.Request.QueryString["EffectiveDate"] != null &&
                    this.Request.QueryString["ExpirationDate"] != null &&
                    this.Request.QueryString["PartsContractCode"] != null &&
                    this.Request.QueryString["ContractType"] != null)
                {
                    this.hidContractID.Text = this.Request.QueryString["InstanceID"];
                    this.hidDivisionID.Text = this.Request.QueryString["DivisionID"];
                    this.hidDealerID.Text = this.Request.QueryString["TempDealerID"];
                    this.HidEffectiveDate.Text = this.Request.QueryString["EffectiveDate"];
                    this.HidExpirationDate.Text = this.Request.QueryString["ExpirationDate"];
                    this.hidContractType.Text = this.Request.QueryString["ContractType"].ToString();
                    this.hidPartsContractCode.Text = this.Request.QueryString["PartsContractCode"];//合同分类Code

                    if (this.Request.QueryString["IsEmerging"] != null)
                    {
                        this.hidIsEmerging.Text = this.Request.QueryString["IsEmerging"].ToString();
                    }
                    else
                    {
                        this.hidIsEmerging.Text = "0";
                    }

                    SetInitialValue();
                    BindPageModel();
                }
            }
        }

        protected void ExportHospitalExcel(object sender, EventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.hidContractID.Text);
            DataTable dt = _contractMasterBll.ExportHospitalProductAOP(obj).Tables[0];
            Excel(dt, "DealerHospitalProductAOP.xls"); 
        }

        protected void ExportDealerExcel(object sender, EventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.hidContractID.Text);
            DataTable dt = _contractMasterBll.ExportAopDealersByQuery(obj).Tables[0];
            Excel(dt, "DealerAOP.xls");
        }

        #region Store
        public void AOPProductClass_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text);
                DataTable dt = _contractCommon.QueryAuthorizationClassificationQuotaByQuery(obj).Tables[0];
                AOPProductClassStore.DataSource = dt;
                AOPProductClassStore.DataBind();
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }
        public void AOPStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            try
            {
                int totalCount = 0;
                Hashtable obj = GetQueryCondition();
                obj.Add("ContractId", this.hidContractID.Text);
                obj.Add("DealerDmaId", this.hidDealerID.Text);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);

                int start = 0; int limit = this.PagingToolBarAOP.PageSize;
                if (e.Start > -1)
                {
                    start = e.Start;
                    limit = e.Limit;
                }
                DataTable dt = _contractCommon.QueryHospitalProductAOPTemp2(obj, start, limit, out totalCount).Tables[0];
                if (sender is Store)
                {
                    Store store1 = (sender as Store);
                    (store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                    store1.DataSource = dt;
                    store1.DataBind();
                }
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }
        public void AOPDealerStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            try
            {
                int totalCount = 0;
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text);
                obj.Add("DealerDmaId", this.hidDealerID.Text);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);

                DataTable dt = _contractMasterBll.QueryHospitalProductByDealerTotleAOP(obj).Tables[0];
                if (sender is Store)
                {
                    Store store1 = (sender as Store);
                    (store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                    store1.DataSource = dt;
                    store1.DataBind();
                }

            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }
        #endregion

        #region Function
        private string ProductLineId(string divisionID)
        {
            string productLineId = "00000000-0000-0000-0000-000000000000";
            Hashtable obj = new Hashtable();
            obj.Add("DivisionID", divisionID);
            obj.Add("IsEmerging", "0");
            DataTable dtProductLine = _contractMasterBll.GetProductLineByDivisionID(obj).Tables[0];
            if (dtProductLine.Rows.Count > 0)
            {
                productLineId = dtProductLine.Rows[0]["AttributeID"].ToString();
            }
            return productLineId;
        }
        private string PartsContractId(string PartsContractCode)
        {
            string partsContractId = "00000000-0000-0000-0000-000000000000";
            Hashtable obj = new Hashtable();
            obj.Add("PartsContractCode", PartsContractCode);
            obj.Add("ProductYear", Convert.ToDateTime(this.HidEffectiveDate.Text).Year.ToString());
            ClassificationContract pcc = _contractCommon.GetPartContractIdByCCCode(obj)[0];
            if (pcc != null)
            {
                partsContractId = pcc.Id.ToString();
            }
            return partsContractId;
        }
        private void SetInitialValue()
        {
            // 1. 获取产品线ID
            this.hidProductLineId.Text = ProductLineId(this.Request.QueryString["DivisionID"].ToString());
            // 2. 获取合同年份跨度
            int Effective = Convert.ToDateTime(this.HidEffectiveDate.Text).Year;
            int Expiration = Convert.ToDateTime(this.HidExpirationDate.Text).Year;
            this.hidMinYear.Text = Effective.ToString();
            string year = null;

            for (int getYear = Effective; getYear <= Expiration; getYear++)
            {
                year += (getYear.ToString() + ',');
            }
            this.hidYearString.Text = year;
            // 3.获取合同起始年份上一年
            //this.hidMinYear.Text = (Effective - 1).ToString();

            //4.获取合同分类ID
            this.hidPartsContractId.Text = PartsContractId(this.hidPartsContractCode.Text);

            // 5.获取指标能够维护开始月份 a》Appointment：合同开始月份    b》Renewal：合同开始月份     c》Amendment：系统时间+14天与合同时间比较，取较大月份
            this.hidBeginYearMinMonth.Text = Convert.ToDateTime(this.HidEffectiveDate.Text).Month.ToString();

        }
        public void BindPageModel() 
        {
            int month = Convert.ToInt32(this.hidBeginYearMinMonth.Text.ToString());
            int dealer = 9;
            int hospital = 15;
            int hospital1 = 17;
            int hospital2 = 16;
            for (int i = 0; i < month - 1; i++)
            {
                this.GridDealerAop.ColumnModel.SetHidden(dealer, true);
                this.GridPanelAOPStore.ColumnModel.SetHidden(hospital, true);
                this.GridPanelAOPStore.ColumnModel.SetHidden(hospital1, true);
                this.GridPanelAOPStore.ColumnModel.SetHidden(hospital2, true);
                dealer += 3;
                hospital += 3;
                hospital1 += 3;
                hospital2 += 3;
            }
        }

        private Hashtable GetQueryCondition()
        {
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbQueryProductClass.SelectedItem.Value))
            {
                param.Add("CqId", this.cbQueryProductClass.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtQueryHospitalName.Text))
            {
                param.Add("HospitalName", this.txtQueryHospitalName.Text);
            }
            return param;
        }

        private void Excel(DataTable dt,string fileName) 
        {
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=" + fileName);
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }
        #endregion
    }
}
