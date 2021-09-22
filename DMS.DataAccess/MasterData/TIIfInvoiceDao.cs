
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : BPM.DataAccess 
 * ClassName   : TIIfInvoice
 * Created Time: 2013/8/14 17:02:40
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
    /// TIIfInvoice的Dao
    /// </summary>
    public class TIIfInvoiceDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public TIIfInvoiceDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public TIIfInvoice GetObject(string objKey)
        {
            TIIfInvoice obj = this.ExecuteQueryForObject<TIIfInvoice>("SelectTIIfInvoice", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<TIIfInvoice> GetAll()
        {
            IList<TIIfInvoice> list = this.ExecuteQueryForList<TIIfInvoice>("SelectTIIfInvoice", null);          
            return list;
        }


        /// <summary>
        /// 查询TIIfInvoice
        /// </summary>
        /// <returns>返回TIIfInvoice集合</returns>
		public IList<TIIfInvoice> SelectByFilter(TIIfInvoice obj)
		{ 
			IList<TIIfInvoice> list = this.ExecuteQueryForList<TIIfInvoice>("SelectByFilterTIIfInvoice", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(TIIfInvoice obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTIIfInvoice", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(string objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTIIfInvoice", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(TIIfInvoice obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteTIIfInvoice", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(TIIfInvoice obj)
        {
            this.ExecuteInsert("InsertTIIfInvoice", obj);           
        }


        /// <summary>
        /// 根据订单号查询发票信息
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryInvoiceByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("QueryInvoiceByFilter", table, start, limit, out totalRowCount);
        }


        ///<summary>
        ///波科发票信息接口
        ///</summary>
        public IList<BSCInvoiceData> QueryBSCInvoiceInfo(string obj)
        {
            IList<BSCInvoiceData> list = this.ExecuteQueryForList<BSCInvoiceData>("QueryBSCInvoiceInfo", obj);
            return list;
        }

    }
}