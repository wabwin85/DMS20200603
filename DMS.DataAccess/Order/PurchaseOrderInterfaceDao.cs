
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : PurchaseOrderInterface
 * Created Time: 2011-2-24 13:22:01
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
    /// PurchaseOrderInterface的Dao
    /// </summary>
    public class PurchaseOrderInterfaceDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public PurchaseOrderInterfaceDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public PurchaseOrderInterface GetObject(Guid objKey)
        {
            PurchaseOrderInterface obj = this.ExecuteQueryForObject<PurchaseOrderInterface>("SelectPurchaseOrderInterface", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<PurchaseOrderInterface> GetAll()
        {
            IList<PurchaseOrderInterface> list = this.ExecuteQueryForList<PurchaseOrderInterface>("SelectPurchaseOrderInterface", null);          
            return list;
        }


        /// <summary>
        /// 查询PurchaseOrderInterface
        /// </summary>
        /// <returns>返回PurchaseOrderInterface集合</returns>
		public IList<PurchaseOrderInterface> SelectByFilter(PurchaseOrderInterface obj)
		{ 
			IList<PurchaseOrderInterface> list = this.ExecuteQueryForList<PurchaseOrderInterface>("SelectByFilterPurchaseOrderInterface", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(PurchaseOrderInterface obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePurchaseOrderInterface", obj);            
            return cnt;
        }

        /// <summary>
        /// 更新接口记录状态为“Cancelled”
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdatePurchaseOrderInterfaceStatusCancelled(string pohId)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePurchaseOrderInterfaceStatusCancelled", pohId);
            return cnt;
        }


        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeletePurchaseOrderInterface", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(PurchaseOrderInterface obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeletePurchaseOrderInterface", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(PurchaseOrderInterface obj)
        {
            this.ExecuteInsert("InsertPurchaseOrderInterface", obj);
        }

        #region added by bozhenfei on 20110224
        public IList<PurchaseOrderInterface> SelectByBatchNbr(string batchNbr)
        {
            IList<PurchaseOrderInterface> list = this.ExecuteQueryForList<PurchaseOrderInterface>("SelectPurchaseOrderInterfaceByBatchNbr", batchNbr);
            return list;
        }

        /// <summary>
        /// 根据客户端ID初始化接口表
        /// </summary>
        /// <param name="ht"></param>
        /// <returns></returns>
        public int InitByClientID(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePurchaseOrderInterfaceForInitByClientID", ht);
            return cnt;
        }

        /// <summary>
        /// 根据客户端ID初始化LP自己的订单数据
        /// </summary>
        /// <param name="ht"></param>
        /// <returns></returns>
        public int InitLpByClientID(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePurchaseOrderInterfaceForLpInitByClientID", ht);
            return cnt;
        }

        /// <summary>
        /// 根据客户端ID初始化LP下二级经销商的订单数据
        /// </summary>
        /// <param name="ht"></param>
        /// <returns></returns>
        public int InitT2ByClientID(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePurchaseOrderInterfaceForT2InitByClientID", ht);
            return cnt;
        }

        /// <summary>
        /// 根据批处理号得到订单明细数据
        /// </summary>
        /// <param name="batchNbr"></param>
        /// <returns></returns>
        public IList<SapOrderData> QueryPurchaseOrderDetailInfoByBatchNbr(string batchNbr)
        {
            IList<SapOrderData> list = this.ExecuteQueryForList<SapOrderData>("QueryPurchaseOrderDetailInfoByBatchNbr", batchNbr);
            return list;
        }

        /// <summary>
        /// 根据批处理号得到LP订单明细数据
        /// </summary>
        /// <param name="batchNbr"></param>
        /// <returns></returns>
        public IList<LpOrderData> QueryPurchaseOrderDetailInfoByBatchNbrForLp(string batchNbr)
        {
            IList<LpOrderData> list = this.ExecuteQueryForList<LpOrderData>("QueryPurchaseOrderDetailInfoByBatchNbrForLp", batchNbr);
            return list;
        }

        /// <summary>
        /// 根据批处理号得到二级经销商订单明细数据
        /// </summary>
        /// <param name="batchNbr"></param>
        /// <returns></returns>
        public IList<T2OrderData> QueryPurchaseOrderDetailInfoByBatchNbrForT2(string batchNbr)
        {
            IList<T2OrderData> list = this.ExecuteQueryForList<T2OrderData>("QueryPurchaseOrderDetailInfoByBatchNbrForT2", batchNbr);
            return list;
        }

        /// <summary>
        /// 客户端下载完订单后更新数据
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

            this.ExecuteInsert("GC_PurchaseOrder_AfterDownload", ht);

            RtnVal = ht["RtnVal"].ToString();
        }
        #endregion

        public void InsertProcessRunnerInterface(Guid headerId, string SubCompanyId, string BrandId, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("HeaderID", headerId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_ProcessRunner_PurchaseOrder", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
    }
}