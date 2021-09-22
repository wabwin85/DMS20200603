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
    using System.Data;
    using System.Collections;
    public partial class FormalTerritory : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IContractMasterBLL _contractMasterBLL = new ContractMasterBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
             if ((!IsPostBack) && (!Ext.IsAjaxRequest))
            {
                if (this.Request.QueryString["DivisionID"] != null && this.Request.QueryString["DealerID"] != null && this.Request.QueryString["PartsContractCode"] != null)
                {
                  
                    this.hidDivisionID.Text = this.Request.QueryString["DivisionID"];
                    this.hiddenDealer.Text = this.Request.QueryString["DealerID"];
                    this.hidPartsContractCode.Text = this.Request.QueryString["PartsContractCode"];
                    if (this.Request.QueryString["IsEmerging"] != null) 
                    {
                        this.hidIsEmerging.Value = this.Request.QueryString["IsEmerging"].ToString();
                    }
                    this.hidContractId.Text = this.Request.QueryString["InstanceID"];
                }
                if (this.hidContractId.Text.Equals(""))
                {
                    this.hidContractId.Text = Guid.Empty.ToString();
                }
            }
        }

        protected void StoreHospital_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Guid? dmaId = null;
            dmaId = new Guid(this.hiddenDealer.Text.ToString());
            
            int start = 0; int limit = this.PagingToolBar1.PageSize;
            if (e.Start > -1)
            {
                start = e.Start;
                limit = e.Limit;
            }

            Hashtable table = new Hashtable();
            table.Add("DivisionId", this.hidDivisionID.Value.ToString());
            table.Add("SubDepCode", this.hidPartsContractCode.Value.ToString());
            table.Add("DmaId", dmaId);
            if (!this.hidIsEmerging.Value.ToString().Equals("2"))
            {
                table.Add("IsEmerging", this.hidIsEmerging.Value.ToString().Equals("") ? "0" : this.hidIsEmerging.Value.ToString());
            }
            table.Add("ContractId", this.hidContractId.Value.ToString());


            DataSet dataSource = _contractMasterBLL.GetContrateTerritory(table, start, limit, out totalCount);
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
