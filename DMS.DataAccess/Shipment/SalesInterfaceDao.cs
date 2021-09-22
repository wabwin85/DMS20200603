
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : SalesInterface
 * Created Time: 2013/7/29 10:48:45
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
    /// SalesInterface的Dao
    /// </summary>
    public class SalesInterfaceDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public SalesInterfaceDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public SalesInterface GetObject(Guid objKey)
        {
            SalesInterface obj = this.ExecuteQueryForObject<SalesInterface>("SelectSalesInterface", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<SalesInterface> GetAll()
        {
            IList<SalesInterface> list = this.ExecuteQueryForList<SalesInterface>("SelectSalesInterface", null);          
            return list;
        }


        /// <summary>
        /// 查询SalesInterface
        /// </summary>
        /// <returns>返回SalesInterface集合</returns>
		public IList<SalesInterface> SelectByFilter(SalesInterface obj)
		{ 
			IList<SalesInterface> list = this.ExecuteQueryForList<SalesInterface>("SelectByFilterSalesInterface", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(SalesInterface obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateSalesInterface", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteSalesInterface", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(SalesInterface obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteSalesInterface", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(SalesInterface obj)
        {
            this.ExecuteInsert("InsertSalesInterface", obj);           
        }

        /// <summary>
        /// 根据客户端ID初始化LP自己的寄售单数据
        /// </summary>
        /// <param name="ht"></param>
        /// <returns></returns>
        public int InitByClientID(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateLpConsignmentInterfaceForInitByClientID", ht);
            return cnt;
        }

        public IList<LpConsignmentSalesData> QueryLPConsignmentSalesInfoByBatchNbr(string batchNbr,string SubCompanyId, string BrandId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("value", batchNbr);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            IList<LpConsignmentSalesData> list = this.ExecuteQueryForList<LpConsignmentSalesData>("QueryLPConsignmentSalesInfoByBatchNbr", ht);
            return list;
        }

        /// <summary>
        /// 客户端下载完寄售单后更新数据
        /// </summary>
        /// <param name="BatchNbr"></param>
        /// <param name="ClientID"></param>
        /// <param name="Success"></param>
        /// <param name="RtnVal"></param>
        public void AfterDownload(string BatchNbr, string ClientID, string Success, out string RtnVal)
        {
            RtnVal = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("Success", Success);
            ht.Add("RtnVal", RtnVal);

            this.ExecuteInsert("GC_LPConsignmentSalesData_AfterDownload", ht);

            RtnVal = ht["RtnVal"].ToString();
        }

    }
}