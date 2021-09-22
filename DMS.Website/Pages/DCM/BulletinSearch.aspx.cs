using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Collections;

namespace DMS.Website.Pages.DCM
{
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using Microsoft.Practices.Unity;
    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;
    using DMS.Model.Data;
    public partial class BulletinSearch : BasePage
    {
        #region 公共

        IRoleModelContext _context = RoleModelContext.Current;

        private IBulletinSearchBLL _bll = null;
        private IAttachmentBLL _attachBll = null;

        [Dependency]
        public IBulletinSearchBLL bll
        {
            get { return _bll; }
            set { _bll = value; }
        }
        [Dependency]
        public IAttachmentBLL attachBll
        {
            get { return _attachBll; }
            set { _attachBll = value; }
        }

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_Dictionary(BulletinStatusStore, SR.Consts_Bulletin_Status);
                this.Bind_Dictionary(BulletinImportantStore, SR.Consts_Bulletin_Important);

                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.BulletinSearchBLL.Action_BulletinSearch, PermissionType.Read);
                this.btnConfirm.Visible = pers.IsPermissible(Business.BulletinSearchBLL.Action_BulletinSearch, PermissionType.Write);
            }
        }

        #region Store
        public void ResultStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable table = new Hashtable();

            if (!string.IsNullOrEmpty(this.txtTitle.Text.Trim()))
                table.Add("Title", this.txtTitle.Text.Trim());

            if (this.cbUrgentDegree.SelectedItem.Value != "")
                table.Add("UrgentDegree", this.cbUrgentDegree.SelectedItem.Value);

            if (!string.IsNullOrEmpty(this.txtPublishedUser.Text.Trim()))
                table.Add("PublishedUser", this.txtPublishedUser.Text.Trim());

            if (!this.dfPublishedBeginDate.IsNull)
                table.Add("PublishedBeginDate", this.dfPublishedBeginDate.SelectedDate.ToString("yyyyMMdd"));

            if (!this.dfPublishedEndDate.IsNull)
                table.Add("PublishedEndDate", this.dfPublishedEndDate.SelectedDate.ToString("yyyyMMdd"));

            if (this.cbReadFlag.SelectedItem.Value != "")
                table.Add("ReadFlag", this.cbReadFlag.SelectedItem.Value);

            if (this.cbIsRead.SelectedItem.Value != "")
                table.Add("IsRead", this.cbIsRead.SelectedItem.Value);

            if (this.cbIsConfirm.SelectedItem.Value != "")
                table.Add("IsConfirm", this.cbIsConfirm.SelectedItem.Value);

            table.Add("Status", BulletinStatus.Published.ToString());
            table.Add("ExpirationDate", DateTime.Now.ToString("yyyyMMdd"));
            table.Add("DealerId", _context.User.CorpId.Value);

            DataSet data = bll.QuerySelectMainByFilter(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            ResultStore.DataSource = data;
            ResultStore.DataBind();
        }

        protected void AttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DataSet ds = attachBll.GetAttachmentByMainId(new Guid(this.hfMainId.Text), AttachmentType.Bulletin, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            AttachmentStore.DataSource = ds;
            AttachmentStore.DataBind();
        }
        #endregion

        #region AjaxMethod
        [AjaxMethod]
        public void Show(string id)
        {
            ClearValue();
            SetValue(id);
            //阅读更新,只记录第一次阅读的状态
            if (!this.IsRead.Checked)
            {
                try
                {
                    UpdateRead(id);
                    GridPanel1.Reload();
                }
                catch (Exception e)
                {
                    Ext.Msg.Alert(GetLocalResourceObject("Show.Alert.Title").ToString(), e.ToString()).Show();
                }
            }

        }

        [AjaxMethod]
        public void UpdateConfirm(string id)
        {   
            //确认更新
            Hashtable table = new Hashtable();
            table.Add("BumId", id);
            table.Add("DealerDmaId", _context.User.CorpId.Value);
            table.Add("IsConfirm", "true");
            table.Add("ConfirmUser", _context.User.Id);
            table.Add("ConfirmDate", DateTime.Now.ToString());

            bll.UpdateConfirm(table);
        }
        #endregion

        #region 页面私有方法
        private void ClearValue()
        {
            this.UrgentDegree.SelectedItem.Value = "";
            this.PublishedUser.Clear();
            this.PublishedDate.Clear();
            this.Title.Clear();
            this.Body.Clear();

            this.IsRead.Checked = false;
            this.IsConfirm.Checked = false;
            this.ReadFlag.Checked = false;

            this.hfMainId.Clear();

            this.btnConfirm.Hide();

            this.TabPanel1.ActiveTabIndex = 0;
        }

        private void SetValue(string MainId)
        {
            this.hfMainId.Text = MainId;

            Hashtable table = new Hashtable();
            table.Add("BumId", MainId);
            table.Add("DealerDmaId", _context.User.CorpId.Value.ToString());

            DataSet ds = bll.GetBulletinMainById(table);

            this.UrgentDegree.SelectedItem.Value = ds.Tables[0].Rows[0][3].ToString();
            this.ReadFlag.Checked = Convert.ToBoolean(ds.Tables[0].Rows[0][4].ToString());
            this.PublishedUser.Text = ds.Tables[0].Rows[0][8].ToString();
            this.PublishedDate.SelectedDate = Convert.ToDateTime(ds.Tables[0].Rows[0][9].ToString());
            this.Title.Text = ds.Tables[0].Rows[0][1].ToString();
            this.Body.Text = ds.Tables[0].Rows[0][2].ToString();

            this.IsRead.Checked = Convert.ToBoolean(ds.Tables[0].Rows[0][10].ToString());
            this.IsConfirm.Checked = Convert.ToBoolean(ds.Tables[0].Rows[0][11].ToString());


            //如果是必须确认的，显示按钮
            if (this.ReadFlag.Checked)
            {
                //如果还没有确认的才显示按钮
                if (!this.IsConfirm.Checked)
                {
                    this.btnConfirm.Show();
                }
            }
        }

        private void UpdateRead(string MainId)
        {
            Hashtable table = new Hashtable();
            table.Add("BumId", MainId);
            table.Add("DealerDmaId", _context.User.CorpId.Value);
            table.Add("IsRead", "true");
            table.Add("ReadUser", _context.User.Id);
            table.Add("ReadDate", DateTime.Now.ToString());

            bll.UpdateRead(table);
        }

        #endregion
    }
}
