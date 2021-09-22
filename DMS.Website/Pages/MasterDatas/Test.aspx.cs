using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.MasterDatas
{
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using DMS.Business;
    using DMS.Model;
    using Lafite.RoleModel.Security;

    public partial class Test : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //Suppliers 
            RefreshData(e.Start, e.Limit);
        }

        private void RefreshData(int start, int limit)
        {

            IDealerMasters bll = new DealerMasters();

            int totalCount = 0;

            DealerMaster param = new DealerMaster();
            
            //Hospital param = new Hospital();

            //param.DmaChineseName = this.txtSearchDMAName.Text.Trim();
            //param.DmaChineseName = "";

            //IList<DealerMaster> query = bll.SelectByFilter(param, start, limit, out totalCount);
            IList<DealerMaster> query = bll.QueryForDealerMaster(param, start, limit, out totalCount);

            (this.Store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            


            this.Store1.DataSource = query;
            this.Store1.DataBind();

        }




    }
}
