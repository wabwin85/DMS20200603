using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;

namespace DMS.Website.Controls
{
    using DMS.Common;
    using DMS.Website.Common;
    using DMS.Model;
    using DMS.Business;
    using Coolite.Ext.Web;
    using System.Data;

    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "DealerSearchDialog")]

    public partial class DealerSearchDialog : BaseUserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public string bumid
        {
            get
            {
                return this.hidbumid.Text;
            }
            set
            {
                this.hidbumid.Text = value;
            }
        }
        #region Store
        protected void DealerList_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            //Clears the dealer's cache
            DMS.Business.Cache.DealerCacheHelper.FlushCache();

            //Gets all dealers
            IList<DealerMaster> dataSource = DMS.Business.Cache.DealerCacheHelper.GetDealers();
            var query = from p in dataSource
                        where p.HostCompanyFlag != true
                        select p;

            //dataSource = query.ToList<DealerMaster>();
            dataSource = query.OrderBy(d => d.ChineseName).ToList<DealerMaster>();

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dataSource;
                store1.DataBind();
            }
        }

        protected void DealerTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type);
            if (sender is Store)
            {
                Store DealerTypeStore = (sender as Store);

                DealerTypeStore.DataSource = dictsCompanyType;
                DealerTypeStore.DataBind();
            }

        }

        protected void Store1_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DealerMasters dealer = new DealerMasters();



            Hashtable b = new Hashtable();
            if (!string.IsNullOrEmpty(this.txtFilterDealer.Text.Trim()))
            {
                b.Add("ChineseName", this.txtFilterDealer.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.txtFilterSAPCode.Text.Trim()))
            {
                b.Add("SapCode", this.txtFilterSAPCode.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.cboFilterDealterType.SelectedItem.Value))
            {
                b.Add("DealerType", this.cboFilterDealterType.SelectedItem.Value);
            }

            b.Add("ActiveFlag", true);
            b.Add("HostCompanyFlag", false);
            b.Add("bumid", bumid);
            //param.ChineseName = this.txtFilterDealer.Text.Trim();
            //param.SapCode = this.txtFilterSAPCode.Text.Trim() == string.Empty ? null : this.txtFilterSAPCode.Text.Trim();
            //param.DealerType = this.cboFilterDealterType.SelectedItem.Value == string.Empty ? null : this.cboFilterDealterType.SelectedItem.Value;
            ////param.Address = this.txtFilterAddress.Text.Trim() == string.Empty ? null : this.txtFilterAddress.Text.Trim();
            //param.ActiveFlag = true;
            //param.HostCompanyFlag = false;


            DataSet dt = dealer.GetDealerMaster(b, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.Store1.DataSource = dt;
            this.Store1.DataBind();
        }

        #endregion

        #region AjaxMethod
        [AjaxMethod]
        public void Show(string bumid)
        {
            this.hidbumid.Text = bumid;

            this.DealerSearchDlg.Show();
        }

        [AjaxMethod]
        public void DoAddItems(string param)
        {



            Ext.Msg.Alert(GetLocalResourceObject("DoAddItems.Alert").ToString(), (param.Substring(0, param.Length - 1).Split(','))[0] + "==" + param.Substring(0, param.Length - 1).Split(',').Length).Show();

            //bool result = (new PurchaseOrderBLL()).AddItemsCfn(new Guid(this.hidHeaderId.Text), new Guid(this.hidDealerId.Text), param.Substring(0, param.Length - 1).Split(','));
        }
        #endregion

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