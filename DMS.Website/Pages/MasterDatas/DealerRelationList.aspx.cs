using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using System.Data;

namespace DMS.Website.Pages.MasterDatas
{
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;

    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;

    public partial class DealerRelationList : BasePage
    {
        #region 公共
        IRoleModelContext _context = RoleModelContext.Current;
        private IDealerRelationBLL _bll = Global.ApplicationContainer.Resolve<IDealerRelationBLL>();
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.DealerRelationBLL.Action_DealerRelation, PermissionType.Read);
                this.btnInsert.Visible = pers.IsPermissible(Business.DealerRelationBLL.Action_DealerRelation, PermissionType.Write);
                this.btnDelete.Visible = pers.IsPermissible(Business.DealerRelationBLL.Action_DealerRelation, PermissionType.Delete);
            }
        }

        #region Store
        public override void Store_DealerList(object sender, StoreRefreshDataEventArgs e)
        {
            //Clears the dealer's cache
            DMS.Business.Cache.DealerCacheHelper.FlushCache();

            //Gets all dealers
            IList<DealerMaster> dataSource = DMS.Business.Cache.DealerCacheHelper.GetDealers();
            var query = from p in dataSource
                        where p.HostCompanyFlag != true
                        select p;

            dataSource = query.ToList<DealerMaster>();
            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dataSource;
                store1.DataBind();
            }
        }

        public void Store_DealerRelationList(object sender, StoreRefreshDataEventArgs e)
        {
            //Clears the dealer's cache
            DMS.Business.Cache.DealerCacheHelper.FlushCache();


            //Gets all dealers

            IList<DealerMaster> dataSource = new DealerMasters().GetAll();

            var query = from p in dataSource
                        where p.HostCompanyFlag != true
                        select p;

            //DealerMaster dm = new 
            dataSource = query.ToList<DealerMaster>();

            DealerMaster dm = new DealerMaster();

            if (!string.IsNullOrEmpty(this.DealerName.SelectedItem.Value))
            {
                dm.Id = new Guid(this.DealerName.SelectedItem.Value);
                IList<DealerMaster> list = new DealerMasters().SelectByFilter(dm);
                bool flag = dataSource.Remove(list.First<DealerMaster>());
            }

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dataSource;
                store1.DataBind();
            }
        }


        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //Suppliers 
            RefreshData(e.Start, e.Limit);
        }

        private void RefreshData(int start, int limit)
        {

            int totalCount = 0;

            DealerRelation param = new DealerRelation();


            //Hospital param = new Hospital();
            //原来使用的文本框作模糊查询

            //param.ChineseName = (this.txtFilterChineseName.Text.Trim() == string.Empty) ? null : this.txtFilterChineseName.Text.Trim();
            //现在使用可以编辑和检索的下拉列表框

            if (!string.IsNullOrEmpty(this.cbDealerName.SelectedItem.Value) && !string.IsNullOrEmpty(this.cbDealerName.SelectedItem.Text.Trim()))
            {
                param.DmaId = new Guid(cbDealerName.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtDealerRelation.Text.Trim()))
            {
                param.DmaRelationName = this.txtDealerRelation.Text.Trim();
            }

            //IList<DealerMaster> query = bll.QueryForHospital(param, start, limit, out totalCount);
            IList<DealerRelation> query = _bll.SelectByFilter(param, (start == -1 ? 0 : start), (limit == -1 ? this.PagingToolBar1.PageSize : limit), out totalCount);

            (this.Store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.Store1.DataSource = query;
            this.Store1.DataBind();

        }

        #endregion

        #region AjaxMethod
        [AjaxMethod]
        public void HiddenRelation()
        {
            if (IsDmsDealer.Checked)
            {
                cbRelationName.Disabled = false;
                txtRelationName.Disabled = true;

                txtRelationName.Clear();
            }
            else 
            {
                cbRelationName.Disabled = true;
                txtRelationName.Disabled = false;

                cbRelationName.SelectedItem.Value = "";
            }

        }

        [AjaxMethod]
        public void Show(string id)
        {
            if (string.IsNullOrEmpty(id))
                ClearWindow();
            else
                SetWindow(id);
        }

        [AjaxMethod]
        public void DeleteItem(string id)
        {
            bool result = _bll.Delete(new Guid(id));
        }

        [AjaxMethod]
        public void SaveItem()
        {
            DealerRelation dr = new DealerRelation();

            if (!string.IsNullOrEmpty(this.txtId.Text))
                dr = _bll.GetObject(new Guid(this.txtId.Text));
            else
                dr.Id = Guid.Empty;

            dr.DmaId = new Guid(this.DealerName.SelectedItem.Value);
            if (IsDmsDealer.Checked)
            {
                dr.DmaRelationid = new Guid(this.cbRelationName.SelectedItem.Value);
                dr.DmaRelationName = null;
            }
            else
            {
                dr.DmaRelationName = this.txtRelationName.Text;
                dr.DmaRelationid = null;
            }
            dr.Remark = this.trRemark.Text;


            if (VerifyForm(dr))
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), string.Format(GetLocalResourceObject("SaveItem.Alert.Body").ToString(), this.DealerName.SelectedItem.Text)).Show();
            }
            else
            {
                bool result = _bll.Save(dr);
                Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title1").ToString(), GetLocalResourceObject("SaveItem.Alert.Body1").ToString()).Show();
            }
        }
        #endregion

        #region 页面私有方法

        private void ClearWindow()
        {
            hidDealerId.Clear();
            hidRelationId.Clear();
            hidRelationName.Clear();

            DealerName.SelectedItem.Value = "";
            IsDmsDealer.Checked = false;
            trRemark.Clear();

            cbRelationName.Disabled = true;
            txtRelationName.Disabled = false;

            txtId.Clear();
            cbRelationName.SelectedItem.Value = "";
            txtRelationName.Clear();

        }

        private void SetWindow(string id)
        {
            DealerRelation dr = _bll.GetObject(new Guid(id));

            DealerName.SelectedItem.Value = dr.DmaId.Value.ToString();
            hidDealerId.Text = dr.DmaId.Value.ToString();

            if (!string.IsNullOrEmpty(dr.DmaRelationName))
            {
                txtRelationName.Text = dr.DmaRelationName;
                hidRelationName.Text = dr.DmaRelationName;
                cbRelationName.Disabled = true;
                IsDmsDealer.Checked = false;
            }
            else
            {
                cbRelationName.SelectedItem.Value = dr.DmaRelationid.ToString();
                hidRelationId.Text = dr.DmaRelationid.ToString();
                txtRelationName.Disabled = true;
                IsDmsDealer.Checked = true;
            }

            txtId.Text = dr.Id.ToString();
            trRemark.Text = dr.Remark;

        }

        private bool VerifyForm(DealerRelation dr)
        {
            if (!string.IsNullOrEmpty(this.hidRelationId.Text))
                if (this.hidDealerId.Text == this.DealerName.SelectedItem.Value
                    && this.hidRelationId.Text == this.cbRelationName.SelectedItem.Value)
                    return false;

            if (!string.IsNullOrEmpty(this.hidRelationName.Text))
                if (this.hidDealerId.Text == this.DealerName.SelectedItem.Value
                    && this.hidRelationName.Text == this.txtRelationName.Text)
                    return false;

            return _bll.Verify(dr);
        }
        #endregion
    }
}
