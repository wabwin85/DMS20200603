using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.MasterDatas
{
    using DMS.Model;
    using DMS.Business;
    using DMS.Business.Cache;
    using DMS.Common;
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;

    using Microsoft.Practices.Unity;
   
    public partial class DealerContractList : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;

        private IDealerContracts _dealerContractBiz = Global.ApplicationContainer.Resolve<IDealerContracts>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.dealerData.Value = DealerCacheHelper.GetJsonArray();
            }
        }
            
        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DealerContract param = new DealerContract();
            param.ContractNumber = this.txtSearchContractNumber.Text.Trim();
            if(!string.IsNullOrEmpty(cbDealer.SelectedItem.Value ))
                param.DmaId = new Guid(cbDealer.SelectedItem.Value);
            
            string s =  this.txtSearchContractYears.Text.Trim();

            if (s != string.Empty)
            {
                int years = 0;
                if(int.TryParse(s, out years))
                    param.ContractYears = years;
            }

            int start = 0; int limit = this.PagingToolBar1.PageSize;
            if (e.Start > -1 )
            {
                start = e.Start;
                limit = e.Limit;
            }

            IList<DealerContract> query = _dealerContractBiz.SelectByFilter(param, start, limit, out totalCount);
            (this.Store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            //string jsonData = JsonHelper.Serialize(query);
            //this.Store1.DataBind(jsonData);

            this.Store1.DataSource = query;
            this.Store1.DataBind();

        }


        protected void SetContractId_Click(object sender, AjaxEventArgs e)
        {
            try
            {
                this.txtContractId.Text = NewGuid();
                e.Success = true;
            }
            catch
            {
                e.Success = false;
                throw;
            }
        }
        protected void SaveContracts_Click(object sender, AjaxEventArgs e)
        {
            //_dealerContractBiz
            string id = this.txtContractId.Text.Trim();

            try
            {
                if (!VerifyDealerIsUniqueness())
                {
                    e.Success = false;
                    e.ErrorMessage = "已有关联该经销商的合同";
                }
                else
                {
                    DealerContract contract = new DealerContract();

                    contract.Id = new Guid(id);

                    if (this.txtDealer.SelectedItem.Value != string.Empty)
                        contract.DmaId = new Guid(this.txtDealer.SelectedItem.Value);
                    contract.ContractNumber = this.txtContractNumber.Text.Trim();
                    if (this.txtContractYears.Text.Trim() != string.Empty)
                    {
                        int year = 0;
                        if (int.TryParse(this.txtContractYears.Text.Trim(), out year))
                            contract.ContractYears = year;
                    }
                    if (this.dtStartDate.SelectedDate.Year > 1)
                        contract.StartDate = this.dtStartDate.SelectedDate;

                    if (this.dtStopDate.SelectedDate.Year > 1)
                        contract.StopDate = this.dtStopDate.SelectedDate;

                    bool result = _dealerContractBiz.SaveContract(contract);
                    if (result)
                        e.Success = true;
                    else
                        e.Success = false;
                }
            }
            catch
            {
                e.Success = false; 
                
                //throw ex;
                
            }
         
        }

        protected void DeleteContracts_Click(object sender, AjaxEventArgs e)
        {
            RowSelectionModel sm = this.GridPanel1.SelectionModel.Primary as RowSelectionModel;
            string id = sm.SelectedRow.RecordID;
            if (!string.IsNullOrEmpty(id))
            {
                bool isdeleted = _dealerContractBiz.DeleteContract(new Guid(id));
                e.Success = isdeleted;
            }
        }

        /// <summary>
        /// Called when [authenticate].
        /// </summary>
        protected override void OnAuthenticate()
        {
            Permissions pers = this._context.User.GetPermissions();

            //正式使用权限时请使用Visible = false, 更安全;

            this.btnDelete.Visible = pers.IsPermissible(Business.DealerContracts.Action_DealerContracts, PermissionType.Delete);
            this.btnInsert.Visible = pers.IsPermissible(Business.DealerContracts.Action_DealerContracts, PermissionType.Write);
            this.btnSearch.Visible = pers.IsPermissible(Business.DealerContracts.Action_DealerContracts, PermissionType.Read);
        }


        public override void Store_DealerList(object sender, StoreRefreshDataEventArgs e)
        {
            IRoleModelContext context = RoleModelContext.Current;


            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();


            //如果是普通用户则检查过滤该用户是否能够看到该Dealer
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
               
                var query = from p in dataSource
                            where p.ActiveFlag == true
                            select p;

                dataSource = query.ToList<DealerMaster>();

            }

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dataSource;
                store1.DataBind();
            }
        }

        //判断经销商合同中经销商是否唯一
        private bool VerifyDealerIsUniqueness()
        {
            if (this.hidIsNew.Text == "1")
            {
                return _dealerContractBiz.VerifyDealerIsUniqueness(new Guid(this.txtDealer.SelectedItem.Value)); 
            }
            return true;         
        }

    }
}
