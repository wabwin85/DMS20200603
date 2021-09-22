
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : PurchaseOrderLog
 * Created Time: 2011-2-10 13:25:36
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
    /// PurchaseOrderLog的Dao
    /// </summary>
    public class PurchaseOrderLogDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public PurchaseOrderLogDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public PurchaseOrderLog GetObject(Guid objKey)
        {
            PurchaseOrderLog obj = this.ExecuteQueryForObject<PurchaseOrderLog>("SelectPurchaseOrderLog", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<PurchaseOrderLog> GetAll()
        {
            IList<PurchaseOrderLog> list = this.ExecuteQueryForList<PurchaseOrderLog>("SelectPurchaseOrderLog", null);          
            return list;
        }


        /// <summary>
        /// 查询PurchaseOrderLog
        /// </summary>
        /// <returns>返回PurchaseOrderLog集合</returns>
		public IList<PurchaseOrderLog> SelectByFilter(PurchaseOrderLog obj)
		{ 
			IList<PurchaseOrderLog> list = this.ExecuteQueryForList<PurchaseOrderLog>("SelectByFilterPurchaseOrderLog", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(PurchaseOrderLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePurchaseOrderLog", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeletePurchaseOrderLog", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(PurchaseOrderLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeletePurchaseOrderLog", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(PurchaseOrderLog obj)
        {
            this.ExecuteInsert("InsertPurchaseOrderLog", obj);
        }

        #region added by bozhenfei on 20110214
        /// <summary>
        /// 查询订单操作日志
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPurchaseOrderLogByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("QueryPurchaseOrderLogByFilter", table, start, limit, out totalRowCount);
        }

        /// <summary>
        /// 根据订单主键删除日志
        /// </summary>
        /// <param name="headerId"></param>
        /// <returns></returns>
        public int DeletePurchaseOrderLogByHeaderId(Guid headerId)
        {
            int cnt = (int)this.ExecuteDelete("DeletePurchaseOrderLogByHeaderId", headerId);
            return cnt;
        }


        /// <summary>
        /// LP及一级经销商退货确认信息（根据e-workflow的确认信息进行判断）
        /// </summary>
        /// <param name="table"></param>       
        /// <returns></returns>
        public DataSet QueryLPGoodsReturnApprove(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryLPGoodsReturnApprove", table);
            return ds;
        }
        #endregion
    }
}