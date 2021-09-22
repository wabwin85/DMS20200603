
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InventoryAdjustConsignment
 * Created Time: 2014/3/19 17:35:43
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
    /// InventoryAdjustConsignment的Dao
    /// </summary>
    public class InventoryAdjustConsignmentDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public InventoryAdjustConsignmentDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InventoryAdjustConsignment GetObject(Guid objKey)
        {
            InventoryAdjustConsignment obj = this.ExecuteQueryForObject<InventoryAdjustConsignment>("SelectInventoryAdjustConsignment", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InventoryAdjustConsignment> GetAll()
        {
            IList<InventoryAdjustConsignment> list = this.ExecuteQueryForList<InventoryAdjustConsignment>("SelectInventoryAdjustConsignment", null);
            return list;
        }


        /// <summary>
        /// 查询InventoryAdjustConsignment
        /// </summary>
        /// <returns>返回InventoryAdjustConsignment集合</returns>
		public IList<InventoryAdjustConsignment> SelectByFilter(InventoryAdjustConsignment obj)
        {
            IList<InventoryAdjustConsignment> list = this.ExecuteQueryForList<InventoryAdjustConsignment>("SelectByFilterInventoryAdjustConsignment", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InventoryAdjustConsignment obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryAdjustConsignment", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryAdjustConsignment", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InventoryAdjustConsignment obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInventoryAdjustConsignment", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InventoryAdjustConsignment obj)
        {
            this.ExecuteInsert("InsertInventoryAdjustConsignment", obj);
        }

        public DataSet SelectByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustConsignmentByHeadId", table, start, limit, out totalRowCount);
            return ds;
        }

        public int DeleteByHeaderId(Guid headId)
        {
            int cnt = (int)this.ExecuteUpdate("DeleteInventoryAdjustConsignmentByHeaderId", headId);
            return cnt;
        }

        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InventoryAdjustConsignment> GetInventoryAdjustConsignmentByFilter(Hashtable table)
        {
            IList<InventoryAdjustConsignment> list = this.ExecuteQueryForList<InventoryAdjustConsignment>("QueryInventoryAdjustConsignmentByFilter", table);
            return list;
        }

        public void SumbitConsignment(Guid AdjustHeadId, out string RtnVal, out string RtnMsg)
        {
            RtnMsg = string.Empty;
            RtnVal = string.Empty;
            Hashtable table = new Hashtable();
            table.Add("AdjustHeadId", AdjustHeadId);
            table.Add("RtnVal", RtnVal);
            table.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_AdjustSubmit_Before", table);

            RtnMsg = table["RtnMsg"].ToString();
            RtnVal = table["RtnVal"].ToString();
        }

        public DataSet GetInventoryAdjustBorrowByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet list = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustBorrowByHeadId", table, start, limit, out totalRowCount);
            return list;
        }

        public void SumbitBorrow(Guid AdjustHeadId, out string RtnVal, out string RtnMsg)
        {
            RtnMsg = string.Empty;
            RtnVal = string.Empty;
            Hashtable table = new Hashtable();
            table.Add("AdjustHeadId", AdjustHeadId);
            table.Add("RtnVal", RtnVal);
            table.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_AdjustConsignmentSubmit_Before", table);

            RtnMsg = table["RtnMsg"].ToString();
            RtnVal = table["RtnVal"].ToString();
        }

        public DataTable QueryDealer(Hashtable obj)
        {
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ContractHeader.SelectDealer", obj).Tables[0];
            return ds;
        }
        public DataSet QueryInventoryAdjustHeaderConsignment(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectByFilterConsignment(table, start, limit, out totalRowCount);
            }
        }

    }
}