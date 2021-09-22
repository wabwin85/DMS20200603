using Coolite.Ext.Web;
using DMS.Business;
using DMS.Model;
using DMS.Website.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Lafite.RoleModel.Security;
using System.Data;
using DMS.Common;



namespace DMS.Website.Controls
{
    using Coolite.Ext.Web;
    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Common;
    using DMS.Model;
    using Lafite.RoleModel.Security;
    using System.Collections;

    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "OrderHospital")]
    public partial class OrderHospital : BaseUserControl
    {
        public AfterSelectedRow AfterSelectedHandler;
        private IRoleModelContext _context = RoleModelContext.Current;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public string SelectedProductLine
        {
            get
            {
                return this.hiddenSelectedProductLine.Text;
            }
            set
            {
                this.hiddenSelectedProductLine.Text = value;
            }
        }

        protected void SubmitSelection(object sender, AjaxEventArgs e)
        {
            string json = e.ExtraParams["Values"];
            string disSelectJson = "[]";

            if (string.IsNullOrEmpty(json))
            {
                return;
            }
            ParameterCollection paramCollection = new ParameterCollection();
            paramCollection.AddRange(e.ExtraParams);
            paramCollection["SelectType"] = SelectTerritoryType.Default.ToString();


            if (AfterSelectedHandler != null)
            {

                AfterSelectedHandler(new SelectedEventArgs(json, disSelectJson, paramCollection));
            }

            e.Success = true;



        }
        protected void RefreshProvinces(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_RefreshProvinces(this.ProvincesStore, e);
        }
        protected void HospitalStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {

            IHospitals bll = new Hospitals();
            int totalCount = 0, start = 0, limit = 0;
            limit = this.PagingToolBar1.PageSize;
            if (e.Start > 0)
            {
                start = e.Start;
                limit = e.Limit;
            }
            Guid lineId = new Guid(this.SelectedProductLine);
            Hashtable tb = new Hashtable();

            tb.Add("DealerID", _context.User.CorpId.Value);
            tb.Add("lineId", lineId);
            tb.Add("HosHospitalName", this.txtSearchHospitalName.Text);
            tb.Add("HosProvince", this.cmbProvince.SelectedItem.Text);
            tb.Add("HosCity", this.cmbCity.SelectedItem.Text);
            tb.Add("HosDistrict", this.cmbDistrict.SelectedItem.Text);
            if (_context.User.CorpType == "T1")
            {
                DataSet DB = bll.GetAuthorizationHospitalListT1(tb, start, limit, out totalCount);
                (this.HospitalSearchDlgStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                this.HospitalSearchDlgStore.DataSource = DB;
                this.HospitalSearchDlgStore.DataBind();
            }
            if (_context.User.CorpType == "LP")
            {
                DataSet DB = bll.GetAuthorizationHospitalList(tb, start, limit, out totalCount);
                (this.HospitalSearchDlgStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                this.HospitalSearchDlgStore.DataSource = DB;
                this.HospitalSearchDlgStore.DataBind();
            }




        }

        protected void Store_RefreshCities(object sender, StoreRefreshDataEventArgs e)
        {
            e.Parameters["parentId"] = this.cmbProvince.SelectedItem.Value;

            base.Store_RefreshTerritorys(sender, e);
        }

        protected void Store_RefreshDistricts(object sender, StoreRefreshDataEventArgs e)
        {
            e.Parameters["parentId"] = this.cmbCity.SelectedItem.Value;

            base.Store_RefreshTerritorys(sender, e);
        }

    }
}