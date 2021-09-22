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
    public partial class FormalDealerAOP : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IContractMasterBLL _contractMasterBLL = new ContractMasterBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (this.Request.QueryString["DivisionID"] != null && this.Request.QueryString["DealerID"] != null && this.Request.QueryString["PartsContractCode"] != null)
                {
                    this.hidDivisionID.Text = this.Request.QueryString["DivisionID"];
                    this.hidDealerID.Text = this.Request.QueryString["DealerID"];
                    this.hidPartsContractCode.Text = this.Request.QueryString["PartsContractCode"];
                    this.hidContractId.Text = this.Request.QueryString["InstanceID"];
                    this.hidBeginDate.Text = this.Request.QueryString["EffectiveDate"];
                    this.hidEndDate.Text = this.Request.QueryString["ExpirationDate"];
                    
                }
                Guid empty = Guid.Empty;

                if (this.hidDivisionID.Text.Equals(""))
                {
                    this.hidDivisionID.Text = "0";
                }
                if (this.hidDealerID.Text.Equals(""))
                {
                    this.hidDealerID.Text = empty.ToString();
                }
                if (this.Request.QueryString["IsEmerging"] != null)
                {
                    this.hidIsEmerging.Value = this.Request.QueryString["IsEmerging"].ToString();
                }
                if (this.hidContractId.Text.Equals(""))
                {
                    this.hidContractId.Text = empty.ToString();
                }
                if (this.hidBeginDate.Text.Equals(""))
                {
                    this.hidBeginDate.Text = "1910-01-01";
                }
                if (this.hidEndDate.Text.Equals(""))
                {
                    this.hidEndDate.Text = "2999-12-31";
                }
            }
        }

        public virtual void AOPStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Guid? dmaId = null;
            string year = null;
        
            dmaId = new Guid(this.hidDealerID.Text.ToString());
            

            int start = 0; int limit = this.PagingToolBar1.PageSize;
            if (e.Start > -1)
            {
                start = e.Start;
                limit = e.Limit;
            }
            Hashtable table = new Hashtable();
            table.Add("DivisionId", this.hidDivisionID.Text);
            table.Add("SubDepCode", this.hidPartsContractCode.Value.ToString());
            table.Add("DmaId", dmaId);
            table.Add("IsEmerging", this.hidIsEmerging.Value.ToString().Equals("") ? "0" : this.hidIsEmerging.Value.ToString());
            table.Add("ContractId", this.hidContractId.Value.ToString());
            table.Add("BeginYear", Convert.ToDateTime(this.hidBeginDate.Value.ToString()).Year.ToString());
            table.Add("EndYear", Convert.ToDateTime(this.hidEndDate.Value.ToString()).Year.ToString());

            DataSet dataSource = _contractMasterBLL.GetHistoryAopDealer(table, start, limit, out totalCount);

            if (sender is Store)
            {
                Store store1 = (sender as Store);
                (store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                store1.DataSource = dataSource;
                store1.DataBind();

            }

        }
    }
}
