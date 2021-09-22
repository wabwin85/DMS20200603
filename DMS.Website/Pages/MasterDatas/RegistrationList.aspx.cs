using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Collections;

namespace DMS.Website.Pages.MasterDatas
{
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using Microsoft.Practices.Unity;
    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;
    public partial class RegistrationList : BasePage
    {
        #region 公共
        IRoleModelContext _context = RoleModelContext.Current;
        private IRegistrationBll _reg = null;
        [Dependency]
        public IRegistrationBll reg
        {
            get { return _reg; }
            set { _reg = value; }
        }

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.RegistrationBll.Action_Registration, PermissionType.Read);
                this.btnImport.Visible = pers.IsPermissible(Business.RegistrationInitBLL.Action_RegistrationInit, PermissionType.Write);
            }
        }

        #region Store
        protected void RegistrationMainStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            //RegistrationMain param = new RegistrationMain();

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.txtArticleNumber.Text.Trim()))
            {
                param.Add("ArticleNumber", this.txtArticleNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.txtRegistrationNbr.Text.Trim()))
            {
                param.Add("RegistrationNbrcn", this.txtRegistrationNbr.Text.Trim());
            }
            if (!this.txtOpeningDateStart.IsNull)
            {
                param.Add("OpeningDateStart", this.txtOpeningDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtOpeningDateEnd.IsNull)
            {
                param.Add("OpeningDateEnd", this.txtOpeningDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtExpirationDateStart.IsNull)
            {
                param.Add("ExpirationDateStart", this.txtExpirationDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtExpirationDateEnd.IsNull)
            {
                param.Add("ExpirationDateEnd", this.txtExpirationDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (IsDealer)
            {
                param.Add("DmaId", _context.User.CorpId.Value.ToString());
            }
            if (!string.IsNullOrEmpty(this.txtRegistrationProductName.Text.Trim()))
            {
                param.Add("RegistrationProductName", this.txtRegistrationProductName.Text.Trim());
            }

            DataSet ds = _reg.SelectMainByFilter(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.RegistrationMainStore.DataSource = ds;
            this.RegistrationMainStore.DataBind();
        }

        protected void RegistrationDetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            string rmid = null;

            if (!string.IsNullOrEmpty(this.hidRMID.Text.Trim()))
            {
                rmid = this.hidRMID.Text;

                DataSet ds = _reg.SelectDetailByFilter(new Guid(rmid), (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
                e.TotalCount = totalCount;

                this.RegistrationDetailStore.DataSource = ds;
                this.RegistrationDetailStore.DataBind();
            }
        }
        #endregion

        #region 页面私有方法

        private void ClearWindowValue()
        {
            this.RegistrationNbrcn.Text = string.Empty;
            this.RegistrationNbren.Text = string.Empty;
            this.OpeningDate.Value = string.Empty;
            this.ExpirationDate.Value = string.Empty;

            this.hidRMID.Text = string.Empty;

        }

        private void SetWindowValue(RegistrationMain main)
        {
            this.RegistrationNbrcn.Text = main.RegistrationNbrcn;
            this.RegistrationNbren.Text = main.RegistrationNbren;
            this.RegistrationProductName.Text = main.RegistrationProductName;
            if (!string.IsNullOrEmpty(main.OpeningDate.ToString()))
                this.OpeningDate.SelectedDate = main.OpeningDate.Value;
            if (!string.IsNullOrEmpty(main.ExpirationDate.ToString()))
                this.ExpirationDate.SelectedDate = main.ExpirationDate.Value;

        }

        #endregion

        #region AjaxMethod
        [AjaxMethod]
        public void Show(string rmid)
        {
            RegistrationMain main = _reg.SelectMainByFilter(new Guid(rmid));
            this.ClearWindowValue();
            this.SetWindowValue(main);

            this.hidRMID.Text = rmid;

        }

        #endregion

    }
}
