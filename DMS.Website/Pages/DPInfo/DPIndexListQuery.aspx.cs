using System;
using System.Collections.Generic;
using System.Linq;
using System.Collections;
using System.Data;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business;
using DMS.Business.Cache;
using DMS.Model;
using DMS.Model.Data;
using Lafite.RoleModel.Security;
using DMS.Common;

namespace DMS.Website.Pages.DPInfo
{
    public partial class DPIndexListQuery : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IDealerMasters _dealers = Global.ApplicationContainer.Resolve<IDealerMasters>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsDealer)
            {
                this.hidCorpType.Text = RoleModelContext.Current.User.CorpType;
            }

            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        this.cboFilterDealterType.SelectedItem.Value = RoleModelContext.Current.User.CorpType;
                        this.cboFilterDealterType.Disabled = true;
                    }
                    else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                    {
                        this.cboFilterDealterType.Disabled = false;
                    }
                    else
                    {
                        this.cboFilterDealterType.Disabled = false;
                    }
                }
                else
                {
                    this.cboFilterDealterType.Disabled = false;
                }
            }
        }

        protected void DealerTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type);
            IDictionary<string, string> dictsCompanyType2 = new Dictionary<string, string>();

            foreach (KeyValuePair<string, string> item in dictsCompanyType)
            {
                dictsCompanyType2.Add(item.Key, item.Value);
            }
            dictsCompanyType2.Remove("HQ");
            if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString())|| RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString())))
            {
                dictsCompanyType2.Remove("T1");
            }
            if (sender is Store)
            {
                Store DealerTypeStore = (sender as Store);

                DealerTypeStore.DataSource = dictsCompanyType2;
                DealerTypeStore.DataBind();
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

            //DealerMaster param = new DealerMaster();
            Hashtable param = new Hashtable();


            //Hospital param = new Hospital();
            //原来使用的文本框作模糊查询

            //param.ChineseName = (this.txtFilterChineseName.Text.Trim() == string.Empty) ? null : this.txtFilterChineseName.Text.Trim();
            //现在使用可以编辑和检索的下拉列表框


            //param.SapCode = this.txtFilterSAPCode.Text.Trim() == string.Empty ? null : this.txtFilterSAPCode.Text.Trim();
            //param.DealerType = this.cboFilterDealterType.SelectedItem.Value == string.Empty ? null : this.cboFilterDealterType.SelectedItem.Value;
            //param.Address = this.txtFilterAddress.Text.Trim() == string.Empty ? null : this.txtFilterAddress.Text.Trim();

            param.Add("DealerName", this.txtFilterDealerName.Text.Trim() == string.Empty ? null : this.txtFilterDealerName.Text.Trim());
            param.Add("SapCode", this.txtFilterSAPCode.Text.Trim() == string.Empty ? null : this.txtFilterSAPCode.Text.Trim());
            param.Add("DealerType", this.cboFilterDealterType.SelectedItem.Value == string.Empty ? null : this.cboFilterDealterType.SelectedItem.Value);

            //BSC用户可以看所有发货单，T1、T2经销商用户只能看自己的发货单,LP可以看自己的以及下属经销商的发货单
            if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString())|| RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString())))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }

            //IList<DealerMaster> query = bll.QueryForHospital(param, start, limit, out totalCount);
            DataTable ds = _dealers.QueryForDealerProfileMaster(param, (start == -1 ? 0 : start), (limit == -1 ? this.PagingToolBar1.PageSize : limit), out totalCount);

            (this.Store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.Store1.DataSource = ds;
            this.Store1.DataBind();

        }

        protected void Store1_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events

            string json = e.DataHandler.JsonData;
            StoreDataHandler dataHandler = new StoreDataHandler(json);


            ChangeRecords<DealerMaster> data = dataHandler.CustomObjectData<DealerMaster>();

            DealerMasters bll = new DealerMasters();
            bll.SaveChanges(data);

            //Clears the dealer's cache
            DMS.Business.Cache.DealerCacheHelper.FlushCache();

            e.Cancel = true;
        }

        [AjaxMethod]
        public void SearchData()
        {
            this.PagingToolBar1.PageIndex = 1;
            RefreshData(0, PagingToolBar1.PageSize);
        }

        [AjaxMethod]
        public void RefreshDealerCache()
        {
            string rtnVal = string.Empty;
            DealerCacheHelper.ReloadDealers();
            this.hidRtnVal.Text = "Success";
        }
    }
}
