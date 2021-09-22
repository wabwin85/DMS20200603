using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using DMS.Model.ViewModel;
using DMS.ViewModel.Util;
using DMS.DataAccess;
using DMS.Common.Extention;
using Lafite.RoleModel.Security;
using DMS.Business;
using DMS.Common;
using DMS.Model;
using DMS.Business.Cache;
using System.Reflection;

namespace DMS.BusinessService.Util.DealerFilter.Impl
{
    public class AllDealerFilter : ADealerFilter
    {
        public override IList<Hashtable> GetDealerList(FilterVO model)
        {
            if (!model.QryString.IsNullOrEmpty())
            {
                DealerMasterDao dealerMasterDao = new DealerMasterDao();

                return dealerMasterDao.SelectFilterListAll(model.QryString);
            }
            else
            {
                return new List<Hashtable>();
            }
        }
        public override ArrayList GetDealerList(DealerScreenFilterVO model)
        {
            string selectType = string.Empty;
            if (!model.QryString.IsNullOrEmpty())
            {
                selectType = (string.IsNullOrEmpty(model.Parameters["IsAll"].ToString())) ? "1" : model.Parameters["IsAll"].ToString();
                List<DealerMaster> result = new List<DealerMaster>();
                if (selectType == "0")//所有经销商 不过滤授权
                    result = AllDealerList().Where(s => s.ChineseShortName != null && s.ChineseShortName.Contains(model.QryString)).Skip(0).Take(10).ToList();
                else if (selectType == "1")//所有经销商
                    result = DealerList().Where(s => s.ChineseShortName != null && s.ChineseShortName.Contains(model.QryString)).Skip(0).Take(10).ToList();
                else if (selectType == "2")//平台下级经销商
                    result = DealerListByFilter(false).Where(s => s.ChineseShortName != null && s.ChineseShortName.Contains(model.QryString)).Skip(0).Take(10).ToList();
                else if (selectType == "3")//平台经销商及下级经销商
                    result = DealerListByFilter(true).Where(s => s.ChineseShortName != null && s.ChineseShortName.Contains(model.QryString)).Skip(0).Take(10).ToList();
                //合同模块，ChineseShortName为空，应使用ChineseName
                else if (selectType == "4")//所有经销商
                    result = DealerList().Where(s => s.ChineseName != null && s.ChineseName.Contains(model.QryString)).Skip(0).Take(10).ToList();
                else if (selectType == "5")//平台下级经销商
                    result = DealerListByFilter(false).Where(s => s.ChineseName != null && s.ChineseName.Contains(model.QryString)).Skip(0).Take(10).ToList();
                else if (selectType == "6")//平台经销商及下级经销商
                    result = DealerListByFilter(true).Where(s => s.ChineseName != null && s.ChineseName.Contains(model.QryString)).Skip(0).Take(10).ToList();
                return GetHashTable(result);
            }
            else
            {
                return new ArrayList();
            }
        }
        public static ArrayList GetHashTable(List<DealerMaster> t)
        {
            try
            {
                List<HasTableKeyValue> result = new List<HasTableKeyValue>();
                if (t.Count > 0)
                {

                    for (int i = 0; i < t.Count; i++)
                    {
                        result.Add(new HasTableKeyValue { DealerId = t[i].Id.ToString(), DealerName = t[i].ChineseShortName });
                    }
                    return new ArrayList(result);
                }
                else
                {
                    return null;
                }
            }
            catch
            {
                return null;
            }
        }
        public static DataTable ToDataTable<T>(List<T> list)
        {
            DataTable dt = new DataTable();
            Type type = typeof(T);
            List<PropertyInfo> properties = new List<PropertyInfo>();
            Array.ForEach<PropertyInfo>(type.GetProperties(), p =>
            {
                properties.Add(p);
                dt.Columns.Add(p.Name, p.PropertyType);
            });
            foreach (var item in list)
            {
                DataRow row = dt.NewRow();
                properties.ForEach(p =>
                {
                    row[p.Name] = p.GetValue(item, null);
                });
                dt.Rows.Add(row);
            }
            return dt;
        }
        public virtual IList<DealerMaster> AllDealerList()
        {
            IRoleModelContext context = RoleModelContext.Current;
            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();

            return dataSource;
        }
        public virtual IList<DealerMaster> DealerList()
        {
            IRoleModelContext context = RoleModelContext.Current;
            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();
            //如果是普通用户则检查过滤该用户是否能够看到该Dealer
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                IList<OrganizationUnit> list = this.GetCurrentProductLines();
                Guid[] lines = (from p in list select new Guid(p.Id)).ToArray<Guid>();
                IDealerMasters dealerbiz = new DealerMasters();
                IList<Guid> dealers = dealerbiz.GetDealersBySales(context.User.Id, lines);
                var query = from p in dataSource
                            where dealers.Contains(p.Id.Value)
                            select p;
                dataSource = query.OrderBy(d => d.ChineseName).ToList<DealerMaster>();
                //dataSource = query.ToList<DealerMaster>();
            }

            return dataSource;
        }
        public virtual IList<DealerMaster> DealerListByFilter(bool showParent)
        {
            IRoleModelContext context = RoleModelContext.Current;
            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();
            //如果是波科用户，则根据授权信息获得经销商列表
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                IList<OrganizationUnit> list = this.GetCurrentProductLines();
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

            return dataSource;
        }
    }
    public class HasTableKeyValue
    {
        public string DealerId { set; get; }
        public string DealerName { set; get; }
    }
}
