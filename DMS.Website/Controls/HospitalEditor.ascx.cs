using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Controls
{
    using Coolite.Ext.Web;
    using DMS.Model;
    using DMS.Website.Common;

    public partial class HospitalEditor : BaseUserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void CreateHospital()
        {
            this.HosId1.Text = this.NewGuid();
        }

        protected void Store_RefreshCities(object sender, StoreRefreshDataEventArgs e)
        { 
            e.Parameters["parentId"] = this.cmbProvince.SelectedItem.Value;

            base.Store_RefreshTerritorys(sender,e);
        }

        protected void Store_RefreshDistricts(object sender, StoreRefreshDataEventArgs e)
        {
            e.Parameters["parentId"] = this.cmbCity.SelectedItem.Value;

            base.Store_RefreshTerritorys(sender, e);
        }
    }
}