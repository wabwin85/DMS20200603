
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : PoReceiptLot
 * Created Time: 2009-7-22 10:57:41
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
    /// PoReceiptLot的Dao
    /// </summary>
    public class PoReceiptLotDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public PoReceiptLotDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public PoReceiptLot GetObject(Guid objKey)
        {
            PoReceiptLot obj = this.ExecuteQueryForObject<PoReceiptLot>("SelectPoReceiptLot", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<PoReceiptLot> GetAll()
        {
            IList<PoReceiptLot> list = this.ExecuteQueryForList<PoReceiptLot>("SelectPoReceiptLot", null);          
            return list;
        }

        public IList<PoReceiptLot> SelectByPorId(Guid PorId)
        {
            IList<PoReceiptLot> list = this.ExecuteQueryForList<PoReceiptLot>("SelectByFilterPorId", PorId);
            return list;
        }

        /// <summary>
        /// 查询PoReceiptLot
        /// </summary>
        /// <returns>返回PoReceiptLot集合</returns>
		public IList<PoReceiptLot> SelectByFilter(PoReceiptLot obj)
		{ 
			IList<PoReceiptLot> list = this.ExecuteQueryForList<PoReceiptLot>("SelectByFilterPoReceiptLot", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(PoReceiptLot obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePoReceiptLot", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(PoReceiptLot obj)
        {
            int cnt = (int)this.ExecuteDelete("DeletePoReceiptLot", obj);            
            return cnt;
        }


		
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(PoReceiptLot obj)
        {
            this.ExecuteInsert("InsertPoReceiptLot", obj);           
        }

        /// <summary>
        /// 查询PoReceiptHeader
        /// </summary>
        /// <returns>返回PoReceiptHeader集合</returns>
        public DataSet SelectByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterPoReceiptLotAll", table, start, limit, out totalRowCount);
            return ds;
        }

        /// <summary>
        /// 查询PoReceiptHeader,打印使用
        /// </summary>
        /// <returns>返回PoReceiptHeader集合</returns>
        public DataSet SelectByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterPoReceiptLotAllPrint", table);
            return ds;
        }

        public double GetReceiptTotalAmountByHeaderId(Guid headerId, string SubCompanyId, string BrandId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("value", headerId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            DataSet ds = this.ExecuteQueryForDataSet("GetReceiptTotalAmountByHeaderId", ht);
            return Convert.ToDouble(ds.Tables[0].Rows[0]["TotalAmount"].ToString()); ;
        }

        public double GetReceiptTotalQtyByHeaderId(Guid headerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetReceiptTotalQtyByHeaderId", headerId);
            return Convert.ToDouble(ds.Tables[0].Rows[0]["TotalQty"].ToString()); ;
        }

    }
}