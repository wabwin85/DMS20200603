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
    public partial class ContractDealerAOPQuery : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IContractMasterBLL _contractMasterBLL = new ContractMasterBLL();
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
                   // this.Request.QueryString["PartsContractCode"] != null &&
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
                }
                SetInitialValue();
            }
        }

        public virtual void Store_RefreshFYCO(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable dtYear = new DataTable();
            dtYear.Columns.Add("COP_Period");
            //所有财年
            COPs b = new COPs();
            DataTable dt = b.SelectCOP_FY().Tables[0];

            int Effective = Convert.ToInt32(this.HidEffectiveDate.Text.Substring(0, 4));
            int Expiration = Convert.ToInt32(this.HidExpirationDate.Text.Substring(0, 4));
            for (int getYear = Effective; getYear <= Expiration; getYear++)
            {
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    if (dt.Rows[j]["COP_Period"].ToString().Equals(getYear.ToString()))
                    {
                        dtYear.Rows.Add(getYear.ToString());
                    }
                }
            }

            YearStore.DataSource = dtYear;
            YearStore.DataBind();
        }
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
        }
        protected void ExportExcel(object sender, EventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.hidContractID.Text);
            obj.Add("DealerDmaId", this.hidDealerID.Text.ToString());
            if (!string.IsNullOrEmpty(this.hidProductLineId.Text))
            {
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);
            }
            if (!string.IsNullOrEmpty(this.cbYear.SelectedItem.Value)) 
            {
                obj.Add("Year", this.cbYear.SelectedItem.Value);
            }
            DataTable dt = _contractMasterBLL.ExportAopDealersByQuery(obj).Tables[0];
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=DealerAOP.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }


        #region Store
        public void AOPStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Guid? dmaId = null;
            Guid? prodLineId = null;
            string year = null;
            dmaId = new Guid(this.hidDealerID.Text.ToString());
            prodLineId = new Guid(this.hidProductLineId.Text.ToString());

            if (!string.IsNullOrEmpty(this.cbYear.SelectedItem.Value)) year = this.cbYear.SelectedItem.Value;
            int start = 0; int limit = this.PagingToolBar1.PageSize;
            if (e.Start > -1)
            {
                start = e.Start;
                limit = e.Limit;
            }
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.hidContractID.Text.ToString());
            obj.Add("DealerDmaId", dmaId.Value);
            obj.Add("ProductLineBumId", prodLineId.Value);
            if (!this.hidPartsContractId.Text.ToString().Equals("") && !this.hidPartsContractId.Text.ToString().Equals("00000000-0000-0000-0000-000000000000"))
            {
                obj.Add("SubBuId", this.hidPartsContractId.Text.ToString());
            }
            obj.Add("MarkType", this.hidIsEmerging.Text.ToString());
            obj.Add("Year", year);

            System.Data.DataSet dataSource = _contractMasterBLL.GetAopDealersByQuery(obj, start, limit, out totalCount);
            if (sender is Store)
            {
                Store store1 = (sender as Store);
                (store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                store1.DataSource = dataSource;
                store1.DataBind();
            }
        }
        #endregion

        private string ProductLineId(string divisionID)
        {
            string productLineId = "00000000-0000-0000-0000-000000000000";
            Hashtable obj = new Hashtable();
            obj.Add("DivisionID", divisionID);
            obj.Add("IsEmerging", "0");
            DataTable dtProductLine = _contractMasterBLL.GetProductLineByDivisionID(obj).Tables[0];
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
            IList<ClassificationContract> listPcc = _contractCommon.GetPartContractIdByCCCode(obj);

           if (listPcc.Count >0)
            {
                partsContractId = listPcc[0].Id.ToString();
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

            // 5.获取指标能够维护开始月份
            if (this.hidContractType.Text.Equals("Appointment"))
            {
                this.hidBeginYearMinMonth.Text = Convert.ToDateTime(this.HidEffectiveDate.Text).Month.ToString();
            }
            if (this.hidContractType.Text.Equals("Amendment"))
            {
                this.hidBeginYearMinMonth.Text = (Convert.ToDateTime(this.HidEffectiveDate.Text).Month+1).ToString();
            }
            if (this.hidContractType.Text.Equals("Renewal"))
            {
                this.hidBeginYearMinMonth.Text = Convert.ToDateTime(this.HidEffectiveDate.Text).Month.ToString();
            }

        }
      
    }
}
