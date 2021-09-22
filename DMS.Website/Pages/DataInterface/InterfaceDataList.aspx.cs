using System;
using System.Collections;
using System.Configuration;
using System.Data;
using DMS.Website.Common;
using DMS.Business.DataInterface;
using Microsoft.Practices.Unity;
using DMS.Model.Data;
using Coolite.Ext.Web;
using DMS.Model;
using Lafite.RoleModel.Security;
using System.IO;
using System.Collections.Generic;
using DMS.Common;
using DMS.Business.Cache;
using DMS.Business.MasterData;
using System.Linq;
using DMS.Business;

namespace DMS.Website.Pages.DataInterface
{
    public partial class InterfaceDataList : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_DealerListByLP(DealerStore, true);
                initSearchCondition();
                if (IsDealer)
                {

                    this.cbClient.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    this.cbClient.Disabled = true;
                }
            }

        }
        protected void Bind_InterfaceDataType(object sender, StoreRefreshDataEventArgs e)
        {
            InterfaceDataBLL business = new InterfaceDataBLL();
            DataSet ds = business.SelectInterfaceDataType(e.Parameters["Type"].ToString());
            InterfaceTypeStore.DataSource = ds;
            InterfaceTypeStore.DataBind();
        }
        protected void InterfaceStatusStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(e.Parameters["Type"].ToString());

            if (dicts != null && dicts.ContainsKey("Invalid"))
            {
                dicts.Remove("Invalid");
            }
            if (dicts != null && dicts.ContainsKey("Processing"))
            {
                dicts.Remove("Processing");
            }

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dicts;
                store1.DataBind();
            }
        }


        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (this.cbInterfaceType.SelectedItem != null && !string.IsNullOrEmpty(this.cbInterfaceType.SelectedItem.Value))
            {
                param.Add("DataType", this.cbInterfaceType.SelectedItem.Value);
            }
            if (this.cbInterfaceStatus.SelectedItem != null && !string.IsNullOrEmpty(this.cbInterfaceStatus.SelectedItem.Value))
            {
                param.Add("DataStatus", this.cbInterfaceStatus.SelectedItem.Value);
            }
            else {
                param.Add("DataStatus", "");
            }
            if (this.cbClient.SelectedItem != null && !string.IsNullOrEmpty(this.cbClient.SelectedItem.Value))
            {
                param.Add("DealerId", this.cbClient.SelectedItem.Value);
            }
            else {
                param.Add("DealerId", Guid.Empty);
            }

            if (!this.txtStartDate.IsNull)
            {
                param.Add("StareData", this.txtStartDate.SelectedDate.ToString("yyyyMMdd"));
            }
            else {
                param.Add("StareData", "");
            }
            if (!this.txtEndDate.IsNull)
            {
                param.Add("EndDate", this.txtEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            else
            {
                param.Add("EndDate", "");
            }
            if (!string.IsNullOrEmpty(this.txtBatchNbr.Text.Trim()))
            {
                param.Add("BatchNbr", this.txtBatchNbr.Text.Trim());
            }
            else {
                param.Add("BatchNbr", "");
            }
            if (!string.IsNullOrEmpty(this.txtHeaderNo.Text.Trim()))
            {
                param.Add("OrderNo", this.txtHeaderNo.Text.Trim());
            }
            else {
                param.Add("OrderNo", "");
            }
            param.Add("start", (e.Start == -1 ? 0 : e.Start));
            param.Add("limit", (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit));

            InterfaceDataBLL business = new InterfaceDataBLL();
            DataSet ds = business.QueryInterfaceData(param);
            e.TotalCount =Convert.ToInt32(ds.Tables[1].Rows[0]["TotalCount"].ToString());

            this.ResultStore.DataSource = ds.Tables[0];
            this.ResultStore.DataBind();
        }

        [AjaxMethod]
        public void SetRecordStatus(string ids, string status)
        {
            hiddenRtnVal.Clear();
            hiddenRtnMessing.Clear();

            string RtnVal=string.Empty;
            string RtnMsg=string.Empty;
             InterfaceDataBLL business = new InterfaceDataBLL();

             business.UpdateInterfaceData(ids,new Guid(_context.User.Id), status, cbInterfaceType.SelectedItem.Value, out RtnVal,out RtnMsg);
             hiddenRtnVal.Text = RtnVal;
             hiddenRtnMessing.Text = RtnMsg;

        }
        #region 自定义方法
        protected void initSearchCondition()
        {

            this.txtStartDate.Value = DateTime.Now.AddMonths(-1).AddDays(1);
        }
        public virtual void Bind_DealerListByLP(Store store, bool showParent)
        {
            IRoleModelContext context = RoleModelContext.Current;
            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();
            //如果是波科用户，则根据授权信息获得经销商列表
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                IList<OrganizationUnit> list = this.GetCurrentProductLines(context);
                Guid[] lines = (from p in list select new Guid(p.Id)).ToArray<Guid>();
                IDealerMasters dealerbiz = new DealerMasters();
                IList<Guid> dealers = dealerbiz.GetDealersBySales(context.User.Id, lines);
                var query = from p in dataSource
                            where dealers.Contains(p.Id.Value)
                            select p;
                dataSource = query.OrderBy(d => d.ChineseName).ToList<DealerMaster>();
                //dataSource = query.ToList<DealerMaster>();
            }
            else
            {
                //如果是经销商用户
                if (showParent)
                {
                    //显示自己及下级经销商
                    dataSource = (from t in dataSource where t.Id.Value == context.User.CorpId.Value || (t.ParentDmaId.HasValue && t.ParentDmaId.Value == context.User.CorpId.Value) select t).ToList<DealerMaster>();
                }
                else
                {
                    //显示下级经销商
                    dataSource = (from t in dataSource where (t.ParentDmaId.HasValue && t.ParentDmaId.Value == context.User.CorpId.Value) select t).ToList<DealerMaster>();
                }
            }
            //只显示平台
            dataSource = (from t in dataSource where (t.DealerType=="LP") select t).ToList<DealerMaster>();
            store.DataSource = dataSource;
            store.DataBind();
        }
        private IList<OrganizationUnit> GetCurrentProductLines(IRoleModelContext context, bool isFilterBySubCompanyAndBrand = true)
        {
            IList<OrganizationUnit> list = new List<OrganizationUnit>();

            IList<OrganizationUnit> units = context.User.OrganizationUnits;
            foreach (var unit in units)
            {

                if (unit.Level < DMS.Common.SR.Organization_ProductLine_Level)
                {
                    var us = OrganizationHelper.GetChildOrganizationUnit(SR.Organization_ProductLine, unit.Id);
                    list = list.Union<OrganizationUnit>(us).ToList<OrganizationUnit>(); ;

                }
                else if (unit.Level == SR.Organization_ProductLine_Level)
                {
                    OrganizationUnit u = unit;
                    if (!list.Contains(u))
                        list.Add(u);
                }
                else
                {
                    OrganizationUnit u = OrganizationHelper.GetParentOrganizationUnit(SR.Organization_ProductLine, unit.Id);
                    if (!list.Contains(u))
                        list.Add(u);
                }

            }
            return isFilterBySubCompanyAndBrand ? BaseService.FilterProductLine(list) : list;
        }
        #endregion
    }
}