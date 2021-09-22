using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.Website.Common;
using Coolite.Ext.Web;
using Lafite.RoleModel.Security;
using DMS.Model.Data;
using DMS.Common;
using System.Collections;
using DMS.Business;
using System.Data;

namespace DMS.Website.Pages.Contract
{
    public partial class ContractMaster : BasePage
    {
        private IContractMaster _contract = new DMS.Business.ContractMaster();
        private IContractMasterBLL _contractMasterBLL = new ContractMasterBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                //this.Bind_ProductLine(this.ProductLineStore);
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()))
                    {
                        this.Bind_DealerList(this.DealerStore);
                        this.cbDealer.Disabled = true;
                        this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                    else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        this.Bind_DealerListByFilter(this.DealerStore, true);
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString())) 
                        {
                            this.cbDealer.Disabled = true;
                        }
                    }
                    else
                    {
                        this.Bind_DealerList(this.DealerStore);
                    }

                }
                else
                {
                    this.Bind_DealerList(this.DealerStore);

                }
            }
        }

        protected void StatusStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> contractStatus = DictionaryHelper.GetDictionary(SR.CONST_Contract_Status);
            StatusStore.DataSource = contractStatus;
            StatusStore.DataBind();
        }

        protected void ContractTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> contractType = DictionaryHelper.GetDictionary(SR.CONST_Contract_Type);
            ContractTypeStore.DataSource = contractType;
            ContractTypeStore.DataBind();
        }

        protected void TakeEffectStateStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataSet ds = _contractMasterBLL.GetTakeEffectStateByContractID(new Guid(this.hidInstanceId.Text));

            TakeEffectStateStore.DataSource = ds;
            TakeEffectStateStore.DataBind();
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //Suppliers 
            RefreshData(e.Start, e.Limit);
        }
        protected void DivisionStore_RefershData(object sender, StoreRefreshDataEventArgs e) 
        {
            this.DivisionStore.DataSource = _contractMasterBLL.GetDivision("");
            this.DivisionStore.DataBind();
        }

        private void RefreshData(int start, int limit)
        {


            int totalCount = 0;

            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerID", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtDealerNameFuzzyCN.Text))
            {
                param.Add("DealerName", this.txtDealerNameFuzzyCN.Text);
            }
            if (!string.IsNullOrEmpty(this.cbStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbStatus.SelectedItem.Value);
            }
            if (!this.dfStartBeginDate.IsNull)
            {
                param.Add("StartBeginDate", this.dfStartBeginDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.dfStartEndDate.IsNull)
            {
                param.Add("StartEndDate", this.dfStartEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.dfStopBeginDate.IsNull)
            {
                param.Add("StopBeginDate", this.dfStopBeginDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.dfStopEndDate.IsNull)
            {
                param.Add("StopEndDate", this.dfStopEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.cbContractType.SelectedItem.Value))
            {
                param.Add("ContractType", this.cbContractType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDivision.SelectedItem.Value))
            {
                param.Add("Division", this.cbDivision.SelectedItem.Value);
            }
            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation.ToString()))
            {
                param.Add("UserType", "CO");
            }
            else 
            {
                param.Add("UserType", "SA");
            }
            BaseService.AddCommonFilterCondition(param);
            DataTable query = _contract.QueryForContractMaster(param, (start == -1 ? 0 : start), (limit == -1 ? this.PagingToolBar1.PageSize : limit), out totalCount).Tables[0];

            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.ResultStore.DataSource = query;
            this.ResultStore.DataBind();

        }

        #region ajax
        [AjaxMethod]
        public void Show(string id)
        {
            this.hidInstanceId.Text = id;
            this.GridPanel2.Reload();
            TakeEffectStateWindow.Show();

        }
        #endregion
    }
}
