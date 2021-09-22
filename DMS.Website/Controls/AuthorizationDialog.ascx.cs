using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Controls
{
    using Coolite.Ext.Web;
    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Common;
    using DMS.Model;
    using Lafite.RoleModel.Security;
    using System.Collections;
    using System.Data;
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "AuthorizationDialog")]
    public partial class AuthorizationDialog : BaseUserControl
    {
        private IShipmentBLL business = new ShipmentBLL();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #region 参数
        public string DealerId
        {
            get
            {
                return this.hiddenDealerId.Text;
            }
            set
            {
                this.hiddenDealerId.Text = value;
            }
        }
        public string Upn
        {
            get
            {
                return this.hiddenUpn.Text;
            }
            set
            {
                this.hiddenUpn.Text = value;
            }
        }
        #endregion
        [AjaxMethod]
        public void AuthorizationShow(string upn, string dmaId)
        {
            this.DealerId = dmaId;
            this.Upn = upn;
            this.txtAtuUPN.Text = upn;
            this.txtAutHospital.Text = "";
            this.dfAutDate.Clear();
            this.AuthorizationWindow.Show();
        }
        #region Store 绑定事件
        protected void AuthorStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.DealerId))
            {
                param.Add("DmaId", this.DealerId);
            }
            if (!string.IsNullOrEmpty(this.Upn))
            {
                param.Add("AutUpn", this.Upn);
            }
            if (!string.IsNullOrEmpty(this.txtAutHospital.Text))
            {
                param.Add("AutHospital", this.txtAutHospital.Text);
            }
            if (!this.dfAutDate.IsNull)
            {
                param.Add("AutDate", this.dfAutDate.SelectedDate);
            }
            DataSet ds = business.QueryDealerAuthorizationList(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;
            this.AuthorStore.DataSource = ds;
            this.AuthorStore.DataBind();
        }
        #endregion
    }
}