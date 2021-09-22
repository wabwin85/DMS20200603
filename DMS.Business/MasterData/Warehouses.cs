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
    using Lafite.RoleModel.Security.Authorization;
    using System.Data;

    public class Warehouses : IWarehouses
    {
        #region Action Define
        public const string Action_DealerWarehouseMaint = "DealerWarehouseMaint";
        #endregion

        private IRoleModelContext _context = RoleModelContext.Current;

        public Warehouses()
        {

        }

        /// <summary>
        /// Get warehouse list by user id
        /// </summary>
        /// <param name="hospital"></param>
        /// <returns>Warehouse list</returns>
        public IList<Warehouse> GetWarehouseByUser(Guid UserId)
        {
            using (WarehouseDao dao = new WarehouseDao())
            {
                return dao.GetWarehouseByUserID(UserId);
            }

        }

        public IList<Warehouse> GetWarehouseByDealer(Guid DealerId)
        {
            using (WarehouseDao dao = new WarehouseDao())
            {
                return dao.GetObjectByDealer(DealerId);
            }

        }

        public IList<Warehouse> GetAllWarehouseByDealer(Guid DealerId)
        {
            using (WarehouseDao dao = new WarehouseDao())
            {
                return dao.GetAllByDealer(DealerId);
            }

        }
        /// <summary>
        /// Get warehouse list by a hashtable
        /// </summary>
        /// <param name="hospital"></param>
        /// <returns>Warehouse list</returns>
        public IList<Warehouse> SelectByHashtableForCreateSystemHoldWH(Hashtable hashtable)
        {
            using (WarehouseDao dao = new WarehouseDao())
            {
                return dao.SelectByHashtableForCreateSystemHoldWH(hashtable);
            }

        }

        /// <summary>
        /// Get warehouse list by a hashtable
        /// </summary>
        /// <param name="hospital"></param>
        /// <returns>Warehouse list</returns>
        public IList<Warehouse> GetWarehousesByHashtable(Hashtable hashtable)
        {
            //获取当前登录身份类型以及所属组织

            hashtable.Add("OwnerIdentityType", this._context.User.IdentityType);
            hashtable.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            hashtable.Add("OwnerId", new Guid(this._context.User.Id));

            using (WarehouseDao dao = new WarehouseDao())
            {
                return dao.GetWarehouseByHashtable(hashtable);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerWarehouseMaint, Description = "仓库查询", Permissoin = PermissionType.Read)]
        public IList<Warehouse> GetWarehousesByHashtable(Hashtable hashtable, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            hashtable.Add("OwnerIdentityType", this._context.User.IdentityType);
            hashtable.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            hashtable.Add("OwnerId", new Guid(this._context.User.Id));

            using (WarehouseDao dao = new WarehouseDao())
            {
                return dao.GetWarehouseByHashtable(hashtable, start, limit, out totalRowCount);
            }

        }

        /// <summary>
        /// 检查是否有同名的仓库

        /// </summary>
        /// <param name="warehouseName"></param>
        /// <returns></returns>
        public bool duplicateWarehouseName(Hashtable table)
        {
            using (WarehouseDao dao = new WarehouseDao())
            {
                return (dao.recordsOfSameWarehouseName(table) >= 1);
            }
        }

        public bool DuplicateWarehouseCode(string code)
        {
            using (WarehouseDao dao = new WarehouseDao())
            {
                return (dao.recordsOfSameWarehouseCode(code) >= 1);
            }
        }

        /// <summary>
        /// 检查仓库是否为空

        /// </summary>
        /// <param name="warehouseId"></param>
        /// <returns></returns>
        public bool emptyWarehouse(Guid warehouseId)
        {
            using (WarehouseDao dao = new WarehouseDao())
            {
                return (dao.recordsOfHaveQtyInWarehouse(warehouseId) == 0);
            }
        }

        public Warehouse GetWarehouse(Guid Id)
        {
            using (WarehouseDao dao = new WarehouseDao())
            {
                return dao.GetObject(Id);
            }
        }

        public IList<Warehouse> QueryForWarehouse(Warehouse warehouse, int start, int limit, out int totalRowCount)
        {
            using (WarehouseDao dao = new WarehouseDao())
            {
                return dao.SelectByFilter(warehouse, start, limit, out totalRowCount);
            }
        }


        public IList<Warehouse> QueryForWarehouse(Warehouse warehouse)
        {
            using (WarehouseDao dao = new WarehouseDao())
            {
                return dao.SelectByFilter(warehouse);
            }
        }

        public IList<SapWarehouseAddress> QueryForWarehouse(Guid dmaID)
        {
            using (SapWarehouseAddressDao dao = new SapWarehouseAddressDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("DmaId", dmaID);
                return dao.QuerySapWarehouseAddressByDmaID(ht);
            }
        }

        /// <summary>
        /// 查询导出
        /// </summary>
        /// <param name="hashtable"></param>
        /// <returns></returns>
        public DataSet GetWarehousesForExport(Hashtable hashtable)
        {
            //获取当前登录身份类型以及所属组织

            hashtable.Add("OwnerIdentityType", this._context.User.IdentityType);
            hashtable.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            hashtable.Add("OwnerId", new Guid(this._context.User.Id));

            using (WarehouseDao dao = new WarehouseDao())
            {
                return dao.GetWarehouseForExport(hashtable);
            }
        }

        #region CUID functions
        /// <summary>
        /// 新增
        /// </summary>
        /// <param name="hospital"></param>
        /// <returns></returns>
        /// 
        [AuthenticateHandler(ActionName = Action_DealerWarehouseMaint, Description = "新建仓库", Permissoin = PermissionType.Write)]
        public bool Insert(Warehouse warehouse)
        {
            bool result = false;
            AutoNumberBLL autoNumberBll = new AutoNumberBLL();
            string code = autoNumberBll.GetNextAutoNumberForCode(CodeAutoNumberSetting.Next_WarehouseNbr);
            using (WarehouseDao dao = new WarehouseDao())
            {
                warehouse.Code = String.IsNullOrEmpty(warehouse.Code) ? code : warehouse.Code;
                warehouse.LastUpdateDate = DateTime.Now;
                warehouse.LastUpdateUser = new Guid(_context.User.Id);

                warehouse.CreateDate = warehouse.LastUpdateDate;
                warehouse.CreateUser = warehouse.LastUpdateUser;

                //dao.InsertWhm(warehouse);
                dao.Insert(warehouse);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 修改
        /// </summary>
        /// <param name="hospital"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerWarehouseMaint, Description = "更新仓库信息", Permissoin = PermissionType.Write)]
        public bool Update(Warehouse warehouse)
        {
            bool result = false;
            using (WarehouseDao dao = new WarehouseDao())
            {
                warehouse.LastUpdateDate = DateTime.Now;
                warehouse.LastUpdateUser = new Guid(_context.User.Id);

                int afterRow = dao.Update(warehouse);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 逻辑删除
        /// </summary>
        /// <param name="hospitalId"></param>
        /// <returns></returns>
        public bool FakeDelete(Warehouse warehouse)
        {
            bool result = false;
            using (WarehouseDao dao = new WarehouseDao())
            {
                //Warehouse warehouse = new Warehouse();
                //warehouse.Id = warehouseId;
                warehouse.DeletedFlag = true;

                warehouse.LastUpdateDate = DateTime.Now;
                warehouse.LastUpdateUser = new Guid(_context.User.Id);


                int afterRow = dao.FakeDelete(warehouse);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="hospitalId"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerWarehouseMaint, Description = "删除仓库信息", Permissoin = PermissionType.Write)]
        public bool Delete(Warehouse warehouse)
        {
            bool result = false;

            using (WarehouseDao dao = new WarehouseDao())
            {
                int afterRow = dao.Delete(warehouse);
            }
            return result;
        }
        /// <summary>
        /// SaveChanges, 把所有改变保存到数据库中 
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerWarehouseMaint, Description = "修改仓库信息", Permissoin = PermissionType.Write)]
        public bool SaveChanges(ChangeRecords<Warehouse> data)
        {
            bool result = false;


            using (TransactionScope trans = new TransactionScope())
            {
                foreach (Warehouse warehouse in data.Deleted)
                {
                    this.FakeDelete(warehouse);
                }

                foreach (Warehouse warehouse in data.Updated)
                {
                    this.Update(warehouse);
                }

                foreach (Warehouse warehouse in data.Created)
                {
                    this.Insert(warehouse);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }
        #endregion

        #region UploadInterface
        public void ImportInterfaceWarehouse(IList<InterfaceWarehouse> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceWarehouseDao dao = new InterfaceWarehouseDao())
                {
                    foreach (InterfaceWarehouse item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public bool AfterInterfaceConsignmentWarehouseUpload(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            bool result = false;

            using (InterfaceWarehouseDao dao = new InterfaceWarehouseDao())
            {
                dao.AfterUpload(BatchNbr, ClientID, out IsValid, out RtnMsg);
                result = true;
            }
            return result;

        }

        public IList<InterfaceWarehouse> SelectWarehouseByBatchNbrErrorOnly(string BatchNbr)
        {
            using (InterfaceWarehouseDao dao = new InterfaceWarehouseDao())
            {
                return dao.SelectWarehouseByBatchNbrErrorOnly(BatchNbr);

            }
        }

        public bool DuplicateWarehouseNameUpdate(Hashtable table)
        {
            using (WarehouseDao dao = new WarehouseDao())
            {
                return (dao.recordsOfSameWarehouseName(table) > 1);
            }
        }

        public bool DuplicateWarehouseCodeUpdate(string p)
        {
            using (WarehouseDao dao = new WarehouseDao())
            {
                return (dao.recordsOfSameWarehouseCode(p) > 1);
            }
        }
        #endregion

        #region Warehouse Limit
        public DataSet GetNoLimitWarehouse(Hashtable obj)
        {
            using (WarehouseDao dao = new WarehouseDao())
            {
                return dao.GetNoLimitWarehouse(obj);
            }
        }
        #endregion
    }


}
