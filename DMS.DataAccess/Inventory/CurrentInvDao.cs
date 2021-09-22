
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : CurrentInv
 * Created Time: 2009-7-20 4:49:12 PM
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
using Lafite.RoleModel.Service;

namespace DMS.DataAccess
{
    /// <summary>
    /// CurrentInv的Dao
    /// </summary>
    public class CurrentInvDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数

        /// </summary>
        public CurrentInvDao()
            : base()
        {
        }

        public DataSet SelectByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterAll", table);
            return ds;
        }

        public DataSet SelectByFilterShipmentOrder(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterShipmentOrder", table);
            return ds;
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public CurrentInv GetObject(Guid objKey)
        {
            CurrentInv obj = this.ExecuteQueryForObject<CurrentInv>("SelectCurrentInv", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<CurrentInv> GetAll()
        {
            IList<CurrentInv> list = this.ExecuteQueryForList<CurrentInv>("SelectCurrentInv", null);
            return list;
        }


        /// <summary>
        /// 查询CurrentInv
        /// </summary>
        /// <returns>返回CurrentInv集合</returns>
        public IList<CurrentInv> SelectByFilter(CurrentInv obj)
        {
            //Hashtable ht = new Hashtable();
            //BaseService.AddCommonFilterCondition(ht);
            //obj.SubCompanyId = new Guid(ht["SubCompanyId"].ToString());
            //obj.BrandId = new Guid(Convert.ToString(ht["BrandId"]).ToString());
            IList<CurrentInv> list = this.ExecuteQueryForList<CurrentInv>("SelectByFilterCurrentInv", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(CurrentInv obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateCurrentInv", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(CurrentInv obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteCurrentInv", obj);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(CurrentInv obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteCurrentInv", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(CurrentInv obj)
        {
            this.ExecuteInsert("InsertCurrentInv", obj);
        }

        public DataSet SelectTransferLineByLotIDs(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTransferLineByLotIDs", table);
            return ds;
        }

        public DataSet SelectTransferLotByLotIDs(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTransferLotByLotIDs", table);
            return ds;
        }

        public DataSet SelectCurrentCfnByDealer(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectCurrentCfnByDealer", table);
            return ds;
        }

        public DataSet SelectCurrentCfnByDealer(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectCurrentCfnByDealer", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectCurrentSharedCfnByDealer(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectCurrentSharedCfnByDealer", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectInventoryAdjustLotByLotIDs(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInventoryAdjustLotByLotIDs", table);
            return ds;
        }

        public DataSet SelectInventoryAdjustDetailByLotIDs(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInventoryAdjustDetailByLotIDs", table);
            return ds;
        }

        public DataSet SelectCurrentInvByLotNumber(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectCurrentInvByLotNumber", table);
            return ds;
        }

        public DataSet SelectCurrentCfnProduct(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectCurrentCfnProduct", table, start, limit, out totalRowCount);
            return ds;
        }


        public DataSet SelectByFilterShipmentOrderNoAuth(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterShipmentOrderNoAuth", table);
            return ds;
        }


        #region Added By Song Yuqi On 20140319 
        public DataSet SelectByFilterShipmentOrderByT2Consignment(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterShipmentOrderByT2Consignment", table);
            return ds;
        }

        public DataSet SelectByFilterReturnByT2Consignment(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterReturnByT2Consignment", table);
            return ds;
        }

        public DataSet SelectByFilterShipmentOrderAdjust(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterShipmentOrderAdjust", table);
            return ds;
        }

        public DataSet SelectCTOSByFilterAll(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectCTOSByFilterAll", table);
            return ds;
        }
        #endregion
    }
}