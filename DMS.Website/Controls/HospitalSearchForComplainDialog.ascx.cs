using Coolite.Ext.Web;
using DMS.Business;
using DMS.Common;
using DMS.Model;
using DMS.Website.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Controls
{
    public partial class HospitalSearchForComplainDialog : BaseUserControl
    {
        private Hospitals _hospital = new Hospitals();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void HospitalStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable table = new Hashtable();
            table.Add("DealerId", this.hiddenDealerId.Text);
            table.Add("HospitalName", this.txtHospital.Text);

            DataSet ds = _hospital.SelectHospitalByAuthorization(table, e.Start, e.Limit, out totalCount);

            (this.Store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.Store1.DataSource = ds;
            this.Store1.DataBind();
        }

        protected void SubmitSelection(object sender, AjaxEventArgs e)
        {
            string json = e.ExtraParams["Values"];

            if (string.IsNullOrEmpty(json))
            {
                return;
            }

            if (AfterSelectedHandler != null)
            {
                AfterSelectedHandler(new SelectedEventArgs(json));
            }

            e.Success = true;

        }

        public AfterSelectedRow AfterSelectedHandler;
    }
}