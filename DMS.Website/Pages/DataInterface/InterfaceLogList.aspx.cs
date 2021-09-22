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
    public partial class InterfaceLogList : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                initSearchCondition();
                this.Bind_DealerListByLP(DealerStore, true);
                if (IsDealer)
                {
 
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    this.cbDealer.Disabled = true;
                }
            }
        }
       

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            InterfaceLogBLL business = new InterfaceLogBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbIlName.SelectedItem.Value))
            {
                param.Add("IlName", this.cbIlName.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbIlStatus.SelectedItem.Value))
            {
                param.Add("IlStatus", this.cbIlStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("IlCorpId", this.cbDealer.SelectedItem.Value);
            }
            if (!this.txtStartDate.IsNull)
            {
                param.Add("StartDate", this.txtStartDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtEndDate.IsNull)
            {
                param.Add("EndDate", this.txtEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtIlBatchNbr.Text))
            {
                param.Add("IlBatchNbr", this.txtIlBatchNbr.Text);
            }

            DataSet ds = business.QueryInterfaceLog(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        protected void ShowDetails(object sender, AjaxEventArgs e)
        {
            Guid id = new Guid(e.ExtraParams["IL_ID"].ToString());
            BindHeader(id);
            this.DetailWindow.Show();
        }

        private void BindHeader(Guid id)
        {
            InterfaceLogBLL business = new InterfaceLogBLL();
            Hashtable header = business.GetInterfaceLogById(id);

            this.infoIlName.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_DataInterfaceType, header["IL_Name"].ToString());
            this.infoIlStartTime.Text = header["IL_StartTime"].ToString();
            this.infoIlEndTime.Text = header["IL_EndTime"].ToString();
            this.infoIlStatus.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_MakeOrder_Status, header["IL_Status"].ToString());
            this.infoIlDealerName.Text = header["DMA_ChineseName"].ToString();
            this.infoIlBatchNbr.Text = header["IL_BatchNbr"].ToString();
            this.infoIlMessage.Text = header["Il_Message"].ToString();
        }

        protected void Store_RefreshDataInterfaceType(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(e.Parameters["Type"].ToString());
            IDictionary<string, string> result = null;
            result = dicts;
            #region
            //if (IsDealer)
            //{
                //如果是使用接口的平台，
                //ClientBLL bll = new ClientBLL();
                //Client client = bll.GetClientByCorpId(_context.User.CorpId.Value);
               
                //if (client != null)
                //{
                //    result = dicts;
                //    ////如果平台上传手术报台信息，例如国科恒泰
                //    //if (client.Property3 == "UploadSurgery")
                //    //{
                      
                //    //}
                //    //else
                //    //{
                //    //    result = (from d in dicts where (new string[] { "PDOrderDownloader", "PDReceiptDownloader", "PDReturnDownloader", "SDOrderUploader", "PDShipmentUploader", "SDReturnDownloader", "SDReturnConfirmUploader" }).Contains(d.Key) select d).ToDictionary(x => x.Key, x => x.Value);
            //    //    //}
            //    //}
            //}
            //else
            //{
            //    result = dicts;
            //}
            #endregion
            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = result;
                store1.DataBind();
            }
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
            dataSource = (from t in dataSource where (t.DealerType == "LP") select t).ToList<DealerMaster>();
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
            return isFilterBySubCompanyAndBrand? BaseService.FilterProductLine(list) : list;
        }
        #endregion
    }
}