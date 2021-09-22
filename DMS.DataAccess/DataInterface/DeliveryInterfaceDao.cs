
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DeliveryInterface
 * Created Time: 2013/7/18 12:02:03
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using DMS.Model.DataInterface;

namespace DMS.DataAccess
{
    /// <summary>
    /// DeliveryInterface的Dao
    /// </summary>
    public class DeliveryInterfaceDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DeliveryInterfaceDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DeliveryInterface GetObject(Guid objKey)
        {
            DeliveryInterface obj = this.ExecuteQueryForObject<DeliveryInterface>("SelectDeliveryInterface", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DeliveryInterface> GetAll()
        {
            IList<DeliveryInterface> list = this.ExecuteQueryForList<DeliveryInterface>("SelectDeliveryInterface", null);          
            return list;
        }


        /// <summary>
        /// 查询DeliveryInterface
        /// </summary>
        /// <returns>返回DeliveryInterface集合</returns>
		public IList<DeliveryInterface> SelectByFilter(DeliveryInterface obj)
		{ 
			IList<DeliveryInterface> list = this.ExecuteQueryForList<DeliveryInterface>("SelectByFilterDeliveryInterface", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DeliveryInterface obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDeliveryInterface", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDeliveryInterface", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DeliveryInterface obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDeliveryInterface", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DeliveryInterface obj)
        {
            this.ExecuteInsert("InsertDeliveryInterface", obj);
        }

        #region added by bozhenfei on 20130718

        /// <summary>
        /// 根据客户端ID初始化接口表
        /// </summary>
        /// <param name="ht"></param>
        /// <returns></returns>
        public int InitByClientID(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDeliveryInterfaceForInitByClientID", ht);
            return cnt;
        }

        /// <summary>
        /// 根据批处理号得到发货单明细数据
        /// </summary>
        /// <param name="batchNbr"></param>
        /// <returns></returns>
        public IList<SapDeliveryData> QuerySapDeliveryDataByBatchNbr(string batchNbr)
        {
            IList<SapDeliveryData> list = this.ExecuteQueryForList<SapDeliveryData>("QuerySapDeliveryDataByBatchNbr", batchNbr);
            return list;
        }

        /// <summary>
        /// 客户端下载完后更新数据
        /// </summary>
        /// <param name="ht"></param>
        /// <returns></returns>
        public int UpdateDeliveryInterfaceForDownloadedByBatchNbr(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDeliveryInterfaceForDownloadedByBatchNbr", ht);
            return cnt;
        }

        public int InitT2ByClientID(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateT2eliveryInterfaceForInitByClientID", ht);
            return cnt;
        }
        public IList<LPDeliveryForT2Data> QueryT2DeliveryDataByBatchNbr(string batchNbr)
        {
            IList<LPDeliveryForT2Data> list = this.ExecuteQueryForList<LPDeliveryForT2Data>("QueryT2DeliveryDataByBatchNbr", batchNbr);
            return list;
        }
        #endregion
    }
}