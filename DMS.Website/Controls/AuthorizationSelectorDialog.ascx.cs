using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.ComponentModel;


namespace DMS.Website.Controls
{
    using Coolite.Ext.Web;
    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Common;
    using DMS.Model;
    using Lafite.RoleModel.Security;
    public partial class AuthorizationSelectorDialog : BaseUserControl
    {
        private IDealerContracts _dealerContractBiz = Global.ApplicationContainer.Resolve<IDealerContracts>();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #region Store 绑定事件
        protected void AuthorizationSelectorStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string contractId = this.hiddenContractId.Value.ToString().Trim();
            string authId = this.hiddenSelectedId.Value.ToString().Trim();
            if (!string.IsNullOrEmpty(contractId) && !string.IsNullOrEmpty(authId))
            {
                this.AuthorizationSelectorStore.DataSource = _dealerContractBiz.GetAuthorizationListForDataSetExclude(new Guid(contractId), new Guid(authId));
                this.AuthorizationSelectorStore.DataBind();
            }
        }
        #endregion


        /// Edited By Song Yuqi On 2016-05-31
        protected void SubmitSelection(object sender, AjaxEventArgs e)
        {
            string datId = this.hiddenSelectedId.Value.ToString();


            IList<DealerAuthorization> dealerAuth = _dealerContractBiz.GetAuthorizationList(new DealerAuthorization() { Id = new Guid(datId) });

            if (dealerAuth != null && dealerAuth.Count() > 0
                    && dealerAuth.First<DealerAuthorization>().StartDate.HasValue
                    && dealerAuth.First<DealerAuthorization>().EndDate.HasValue)
            {
                string fromData = e.ExtraParams["SelectValues"];
                SelectedEventArgs ee = new SelectedEventArgs(fromData);
                IList<DealerAuthorization> data = ee.ToList<DealerAuthorization>();
                if (data.Count <= 0) return;
                Guid fromDatId = data[0].Id.Value;
                _dealerContractBiz.CopyHospitalFromOtherAuth(new Guid(datId), fromDatId
                    , dealerAuth.First<DealerAuthorization>().StartDate.Value
                    , dealerAuth.First<DealerAuthorization>().EndDate.Value);

                if (AfterCopyOkHandler != null)
                {
                    AfterCopyOkHandler(sender, new EventArgs());
                }
            }
            else
            {
                Ext.Msg.Alert("Error", "请先维护授权的开始时间和截止时间").Show();
            }

            e.Success = true;
        }

        public EventHandler AfterCopyOkHandler;
    }
}