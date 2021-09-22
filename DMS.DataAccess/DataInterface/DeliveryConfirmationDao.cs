
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DeliveryConfirmation
 * Created Time: 2013/9/2 16:19:18
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
    /// DeliveryConfirmation的Dao
    /// </summary>
    public class DeliveryConfirmationDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DeliveryConfirmationDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DeliveryConfirmation GetObject(Guid objKey)
        {
            DeliveryConfirmation obj = this.ExecuteQueryForObject<DeliveryConfirmation>("SelectDeliveryConfirmation", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DeliveryConfirmation> GetAll()
        {
            IList<DeliveryConfirmation> list = this.ExecuteQueryForList<DeliveryConfirmation>("SelectDeliveryConfirmation", null);          
            return list;
        }


        /// <summary>
        /// 查询DeliveryConfirmation
        /// </summary>
        /// <returns>返回DeliveryConfirmation集合</returns>
		public IList<DeliveryConfirmation> SelectByFilter(DeliveryConfirmation obj)
		{ 
			IList<DeliveryConfirmation> list = this.ExecuteQueryForList<DeliveryConfirmation>("SelectByFilterDeliveryConfirmation", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DeliveryConfirmation obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDeliveryConfirmation", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDeliveryConfirmation", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DeliveryConfirmation obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDeliveryConfirmation", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DeliveryConfirmation obj)
        {
            this.ExecuteInsert("InsertDeliveryConfirmation", obj);           
        }

        public IList<DeliveryConfirmation> SelectDeliveryConfirmationByBatchNbrErrorOnly(string batchNbr)
        {
            IList<DeliveryConfirmation> list = this.ExecuteQueryForList<DeliveryConfirmation>("SelectDeliveryConfirmationByBatchNbrErrorOnly", batchNbr);
            return list;
        }

    }
}