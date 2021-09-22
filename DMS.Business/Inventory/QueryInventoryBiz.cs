using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using Grapecity.DataAccess.Transaction;
    using Lafite.RoleModel.Security;
    using DMS.DataAccess;
    using DMS.Model;
    using DMS.Common;
    using System.Data;
    using Lafite.RoleModel.Security.Authorization;

    public class QueryInventoryBiz : IQueryInventoryBiz
    {
        #region Action Define
        public const string Action_DealerInventoryQuery = "DealerInventoryQuery";
        #endregion

        private IRoleModelContext _context = RoleModelContext.Current;

        public QueryInventoryBiz()
        {
        }

        public IList<QueryInventory> GetInventoryListForDealer(Guid DealerId)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectForDealer(DealerId,Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerInventoryQuery, Description = "库存查询", Permissoin = PermissionType.Read)]
        public IList<QueryInventory> GetInventoryList(Hashtable ht)
        {
            //获取当前登录身份类型以及所属组织

            ht.Add("OwnerIdentityType", this._context.User.IdentityType);
            ht.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            ht.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(ht);

            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectByFilter(ht);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerInventoryQuery, Description = "库存查询", Permissoin = PermissionType.Read)]
        public IList<QueryInventory> GetInventoryList(Hashtable ht, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            ht.Add("OwnerIdentityType", this._context.User.IdentityType);
            ht.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            ht.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(ht);

            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectByFilter(ht, start, limit, out totalRowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerInventoryQuery, Description = "库存查询", Permissoin = PermissionType.Read)]
        public DataSet GetInventoryListDataSet(Hashtable ht, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            ht.Add("OwnerIdentityType", this._context.User.IdentityType);
            ht.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            ht.Add("OwnerId", new Guid(this._context.User.Id));

            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectByFilterDataSet(ht, start, limit, out totalRowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerInventoryQuery, Description = "库存查询", Permissoin = PermissionType.Read)]
        public Decimal GetInventoryListSum(Hashtable ht)
        {
            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.GetInventoryListSum(ht);
            }
        }



        public DataSet SelectInventoryByDealerForExpired(Hashtable ht)
        {
            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectInventoryByDealerForExpired(ht);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerInventoryQuery, Description = "库存查询", Permissoin = PermissionType.Read)]
        public DataSet GetInventoryDataSet(Hashtable ht)
        {
            //获取当前登录身份类型以及所属组织

            ht.Add("OwnerIdentityType", this._context.User.IdentityType);
            ht.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            ht.Add("OwnerId", new Guid(this._context.User.Id));

            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectDataSetByFilter(ht);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerInventoryQuery, Description = "库存查询", Permissoin = PermissionType.Read)]
        public DataSet GetNPOIInventoryDataSet(Hashtable ht)
        {
            //获取当前登录身份类型以及所属组织

            ht.Add("OwnerIdentityType", this._context.User.IdentityType);
            ht.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            ht.Add("OwnerId", new Guid(this._context.User.Id));

            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectNPOIDataSetByFilter(ht);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerInventoryQuery, Description = "库存查询", Permissoin = PermissionType.Read)]
        public DataSet ExportLPInventoryABCDataSet(Hashtable ht)
        {
            //获取当前登录身份类型以及所属组织

            ht.Add("OwnerIdentityType", this._context.User.IdentityType);
            ht.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            ht.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(ht);
            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.ExportLPInventoryABCDataSetByFilter(ht);
            }
        }

        public DataSet SelectInventoryLotForQABSCComplainsDataSet(Hashtable ht)
        {
            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectInventoryLotForQABSCComplainsDataSet(ht);
            }
        }

        public DataSet SelectInventoryUPNForQABSCComplainsDataSet(Hashtable ht)
        {
            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectInventoryUPNForQABSCComplainsDataSet(ht);
            }
        }

        public DataSet SelectInventoryWHMForQABSCComplainsDataSet(Hashtable ht)
        {
            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectInventoryWHMForQABSCComplainsDataSet(ht);
            }
        }

        public DataSet SelectInventoryLotForQACRMComplainsDataSet(Hashtable ht)
        {
            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectInventoryLotForQACRMComplainsDataSet(ht);
            }
        }

        public DataSet SelectInventoryUPNForQACRMComplainsDataSet(Hashtable ht)
        {
            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectInventoryUPNForQACRMComplainsDataSet(ht);
            }
        }

        public DataSet SelectInventoryWHMForQACRMComplainsDataSet(Hashtable ht)
        {
            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectInventoryWHMForQACRMComplainsDataSet(ht);
            }
        }
        public DataSet ExportNPOIInventoryPrice(Hashtable ht)
        {
            //获取当前登录身份类型以及所属组织

            ht.Add("OwnerIdentityType", this._context.User.IdentityType);
            ht.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            ht.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(ht);
            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.ExportNPOIInventoryPrice(ht);
            }
        }
        public DataSet SelectInventoryPrice(Hashtable ht, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            ht.Add("OwnerIdentityType", this._context.User.IdentityType);
            ht.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            ht.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(ht);

            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectInventoryPrice(ht, start, limit, out totalRowCount);
            }
        }
        public DataSet SelectNearEffectInventoryDataSet(Hashtable ht)
        {
            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectNearEffectInventoryDataSet(ht);
            }
        }
    }

}
