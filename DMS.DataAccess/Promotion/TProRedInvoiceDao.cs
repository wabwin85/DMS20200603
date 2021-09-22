
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : TProRedInvoice
 * Created Time: 2016/7/25 18:08:19
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;

namespace DMS.DataAccess
{
    /// <summary>
    /// TProRedInvoice的Dao
    /// </summary>
    public class TProRedInvoiceDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public TProRedInvoiceDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public TProRedInvoice GetObject(int objKey)
        {
            TProRedInvoice obj = this.ExecuteQueryForObject<TProRedInvoice>("SelectTProRedInvoice", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<TProRedInvoice> GetAll()
        {
            IList<TProRedInvoice> list = this.ExecuteQueryForList<TProRedInvoice>("SelectTProRedInvoice", null);          
            return list;
        }


        /// <summary>
        /// 查询TProRedInvoice
        /// </summary>
        /// <returns>返回TProRedInvoice集合</returns>
		public IList<TProRedInvoice> SelectByFilter(TProRedInvoice obj)
		{ 
			IList<TProRedInvoice> list = this.ExecuteQueryForList<TProRedInvoice>("SelectByFilterTProRedInvoice", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(TProRedInvoice obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTProRedInvoice", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(int objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTProRedInvoice", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(TProRedInvoice obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteTProRedInvoice", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(TProRedInvoice obj)
        {
            this.ExecuteInsert("InsertTProRedInvoice", obj);           
        }
       /// <summary>
        ///  经销商红票额度信息上传接口校验
       /// </summary>
       /// <param name="BatchNbr"></param>
       /// <param name="ClientID"></param>
       /// <param name="RtnVal"></param>
       /// <param name="RtnMsg"></param>
        public void HandleInterfaceTPRORedInvoiceDate(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);
            this.ExecuteInsert("GC_Interface_T_PRO_RedInvoice", ht);
            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
        public IList<TProRedInvoice> SelectInterfaceTProRedInvoiceByBatchNbrErrorOnly(string BatchNbr)
        {
            IList<TProRedInvoice> list = this.ExecuteQueryForList<TProRedInvoice>("SelectInterfaceTProRedInvoiceByBatchNbrErrorOnly", BatchNbr);
            return list;
        }

    }
}