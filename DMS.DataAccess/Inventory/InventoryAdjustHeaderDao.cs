
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : InventoryAdjustHeader
 * Created Time: 2009-8-5 16:27:34
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// InventoryAdjustHeader的Dao
    /// </summary>
    public class InventoryAdjustHeaderDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public InventoryAdjustHeaderDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InventoryAdjustHeader GetObject(Guid objKey)
        {
            InventoryAdjustHeader obj = this.ExecuteQueryForObject<InventoryAdjustHeader>("SelectInventoryAdjustHeader", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InventoryAdjustHeader> GetAll()
        {
            IList<InventoryAdjustHeader> list = this.ExecuteQueryForList<InventoryAdjustHeader>("SelectInventoryAdjustHeader", null);
            return list;
        }


        /// <summary>
        /// 查询InventoryAdjustHeader
        /// </summary>
        /// <returns>返回InventoryAdjustHeader集合</returns>
		public IList<InventoryAdjustHeader> SelectByFilter(InventoryAdjustHeader obj)
        {
            IList<InventoryAdjustHeader> list = this.ExecuteQueryForList<InventoryAdjustHeader>("SelectByFilterInventoryAdjustHeader", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InventoryAdjustHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryAdjustHeader", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryAdjustHeader", id);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InventoryAdjustHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInventoryAdjustHeader", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InventoryAdjustHeader obj)
        {
            this.ExecuteInsert("InsertInventoryAdjustHeader", obj);
        }
        public void ConsignInsert(InventoryAdjustHeader obj)
        {
            this.ExecuteInsert("ConsignInsertInventoryAdjustHeader", obj);
        }
        public DataSet SelectByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustHeaderAll", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectByFilterAudit(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustHeaderAudit", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectByFilterAudit(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustHeaderAudit", table);
            return ds;
        }

        public DataSet SelectByFilterConsignment(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustHeaderForLPHQ", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectByFilterReturn(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustHeaderReturn", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectByFilterReturnAudit(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustHeaderReturnAudit", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectByFilterForExport(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterForExport", table);
            return ds;
        }
        public DataSet SelectAdjustByFilterForExport(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("InventoryAdjustListForExport", table);
            return ds;
        }

        public DataSet SelectByFilterForAdjustAuditExport(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterForAdjustAuditExport", table);
            return ds;
        }

        public DataSet SelectIsOtherStockInAvailable(Guid UserId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectIsOtherStockInAvailable", UserId);
            return ds;
        }

        public DataSet SelectByFilterCTOS(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustHeaderCTOS", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectByFilterForConsignmentOrder(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetConsignmentOrderByFilter", obj);
            return ds;
        }
        public DataSet SelectT_I_QV_SalesRepDealerByProductLine(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectT_I_QV_SalesRepDealerByProductLine", ht);
            return ds;
        }
        public DataSet SelectT_I_QV_SalesRepByProductLine(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectT_I_QV_SalesRepByProductLine", ht);
            return ds;
        }
        public InventoryAdjustHeader GetInventoryAdjustByIdPrint(Guid Id)
        {
            InventoryAdjustHeader obj = this.ExecuteQueryForObject<InventoryAdjustHeader>("GetInventoryAdjustByIdPrint", Id);
            return obj;
        }

        //Edited By Song Yuqi On 2017-04-12 For 退货额度池控制 Begin
        public void ReturnAjustBeforeSubmit(Guid AdjustId, string AdjustNo, string AdjustDesc, Guid DealerId, Guid ProductLineId,
             string AdjustType, string ApplyType, Guid UserId, string UserName, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("AdjustId", AdjustId);
            ht.Add("AdjustNo", AdjustNo);
            ht.Add("AdjustDesc", AdjustDesc);
            ht.Add("DealerId", DealerId);
            ht.Add("ProductLineId", ProductLineId);
            ht.Add("AdjustType", AdjustType);
            ht.Add("ApplyType", ApplyType);
            ht.Add("UserId", UserId);
            ht.Add("UserName", UserName);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_ReturnAdjustSubmit_Before", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }

        public void UpdateAdjustCfnPrice(Guid AdjustId, Guid DealerId, Guid ProductLineId, string AdjustType, string ApplyType,
             Guid UserId, string SubCompanyId, string BrandId, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("AdjustId", AdjustId);
            ht.Add("DealerId", DealerId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("ProductLineId", ProductLineId);
            ht.Add("AdjustType", AdjustType);
            ht.Add("ApplyType", ApplyType);
            ht.Add("UserId", UserId);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_UpdateAdjustCfnPrice", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }
        //Edited By Song Yuqi On 2017-04-12 For 退货额度池控制 End


        #region
        public DataTable GetInventoryReturnForEkpFormDataById(Guid Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetInventoryReturnForEkpFormDataById", Id);
            return ds.Tables[0];
        }

        #endregion

        public DataTable QueryDealer(Hashtable obj)
        {
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ContractHeader.SelectDealer", obj).Tables[0];
            return ds;
        }
        public DataSet QueryInventoryAdjustHeader(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            //table.Add("OwnerIdentityType", this._context.User.IdentityType);
            //table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            //table.Add("OwnerId", new Guid(this._context.User.Id));
            //string[] roles = this._context.User.Roles;
            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectByFilter(table, start, limit, out totalRowCount);
            }
        }
        public DataSet QueryInventoryAdjustExport(Hashtable table)
        {
            //获取当前登录身份类型以及所属组织
            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectAdjustByFilterForExport(table);
            }
        }

    }
}