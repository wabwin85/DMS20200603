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
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "ConsignmentDealerDailog")]
    public partial class ConsignmentDealerDailog : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

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
            int totalCount=0;

            IConsignmentMasterBLL Bll = new ConsignmentMasterBLL();
            Hashtable ht = new Hashtable();
            ht.Add("Division", hidProductDivsion.Text);
            if (!string.IsNullOrEmpty(txtFilterDealer.Text))
            {
                ht.Add("ChineseName", txtFilterDealer.Text);
            
            }



            if (!string.IsNullOrEmpty(cboFilterDealterType.SelectedItem.Value))
            {
                ht.Add("DealerType", cboFilterDealterType.SelectedItem.Value);
            }
            if(!string.IsNullOrEmpty(txtFilterSAPCode.Text))
            {
                ht.Add("SapCode", txtFilterSAPCode.Text);
            }
          
            DataSet ds = Bll.QeryConsignmentMasterDealerSearch(ht,(e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;
            this.Store1.DataSource = ds;
            this.Store1.DataBind();
        }

        #endregion

        #region AjaxMethod
        [AjaxMethod]
        public void Show(string ProductLineId,string Cmid)
        {
            hidProductDivsion.Clear();
            hidtrtnVal.Clear();
            hidCmId.Clear();
            TextProductLine.Clear();
            IConsignmentApplyHeaderBLL bll = new ConsignmentApplyHeaderBLL();
            DataSet ds = bll.GetProductLineVsDivisionCode(ProductLineId);
            if (ds.Tables[0].Rows.Count > 0)
            {
                TextProductLine.Text = ds.Tables[0].Rows[0]["ProductLineName"].ToString(); 
                hidProductDivsion.Text = ds.Tables[0].Rows[0]["DivisionCode"].ToString();


            }
            hidCmId.Text = Cmid;
            this.DealerSearchDlg.Show();
        }

        [AjaxMethod]
        public void DoAddItems(string param)
        {


            IConsignmentDealerBLL Bll = new ConsignmentDealerBLL();
            param = param.Substring(0, param.Length - 1);
            bool result = Bll.InsertDealer(param.Split(',').ToArray(), hidCmId.Text);
            if (result)
            {
                hidtrtnVal.Text = "True";
            }
            //bool result = (new PurchaseOrderBLL()).AddItemsCfn(new Guid(this.hidHeaderId.Text), new Guid(this.hidDealerId.Text), param.Substring(0, param.Length - 1).Split(','));
        }
        #endregion

    }
}