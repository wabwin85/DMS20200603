using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.DCM
{
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;

    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;
    using Microsoft.Practices.Unity;

    public partial class DealerHospitalSearch : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;

        private IHospitals _hospitaBiz = null;//Global.SessionContainer.Resolve<IHospitals>();

        [Dependency]
        public IHospitals HospitalBiz
        {
            get { return _hospitaBiz; }
            set { _hospitaBiz = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {

            int start = 0, limit = 0;

            limit = this.PagingToolBar1.PageSize;

            if (e.Start > 0)
            {
                start = e.Start;
                limit = e.Limit;
            }


            RefreshData(start, limit);
        }


        private void RefreshData(int start, int limit)
        {
            int totalCount = 0;

            Hospital param = new Hospital();

            param.HosHospitalName = this.txtSearchHospitalName.Text.Trim();
            param.HosGrade = this.cmbGrade.SelectedItem.Value;
            param.HosDirector = this.txtSearchDirector.Text.Trim();

            param.HosProvince = this.cmbProvince.SelectedItem.Text.Trim();
            param.HosCity = this.cmbCity.SelectedItem.Text.Trim();
            param.HosDistrict = this.cmbDistrict.SelectedItem.Text.Trim();

            param.HosDirector = this.txtSearchDirector.Text.Trim();

            IList<Hospital> query = HospitalBiz.SelectHospitalListOfDealerAuthorized(param, RoleModelContext.Current.User.CorpId.Value, start, limit, out totalCount);

            (this.Store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.Store1.DataBind(JsonHelper.Serialize(query));

        }

        //public void GetHospitalID(object sender, AjaxEventArgs e) //object sender, AjaxEventArgs e
        //{
        //    try
        //    {
        //        this.HospitalEditor1.CreateHospital();
        //        e.Success = true;
        //    }
        //    catch
        //    {
        //        e.Success = false;
        //    }
        //}

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

        /// <summary>
        /// Called when [authenticate].
        /// </summary>
        //protected override void OnAuthenticate()
        //{
        //    Permissions pers = this._context.User.GetPermissions();

        //    //正式使用权限时请使用Visible = false, 更安全;

        //    this.btnDelete.Visible = pers.IsPermissible(Business.Hospitals.Action_Hospitals, PermissionType.Write);
        //    this.btnInsert.Visible = pers.IsPermissible(Business.Hospitals.Action_Hospitals, PermissionType.Write);
        //    this.btnSave.Visible = pers.IsPermissible(Business.Hospitals.Action_Hospitals, PermissionType.Write);
        //    this.btnSearch.Visible = pers.IsPermissible(Business.Hospitals.Action_Hospitals, PermissionType.Read);
        //}
    }
}
