
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DeliveryNotebscslc
 * Created Time: 2015/12/14 20:35:55
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
    /// DeliveryNotebscslc的Dao
    /// </summary>
    public class DeliveryNotebscslcDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public DeliveryNotebscslcDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DeliveryNotebscslc GetObject(Guid objKey)
        {
            DeliveryNotebscslc obj = this.ExecuteQueryForObject<DeliveryNotebscslc>("SelectDeliveryNotebscslc", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DeliveryNotebscslc> GetAll()
        {
            IList<DeliveryNotebscslc> list = this.ExecuteQueryForList<DeliveryNotebscslc>("SelectDeliveryNotebscslc", null);
            return list;
        }


        /// <summary>
        /// 查询DeliveryNotebscslc
        /// </summary>
        /// <returns>返回DeliveryNotebscslc集合</returns>
        public IList<DeliveryNotebscslc> SelectByFilter(DeliveryNotebscslc obj)
        {
            IList<DeliveryNotebscslc> list = this.ExecuteQueryForList<DeliveryNotebscslc>("SelectByFilterDeliveryNotebscslc", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DeliveryNotebscslc obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDeliveryNotebscslc", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDeliveryNotebscslc", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DeliveryNotebscslc obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDeliveryNotebscslc", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DeliveryNotebscslc obj)
        {
            this.ExecuteInsert("InsertDeliveryNotebscslc", obj);
        }


        public IList<DeliveryNotebscslc> SelectDeliveryNoteBSCSLCByBatchNbrErrorOnly(string batchNbr)
        {
            IList<DeliveryNotebscslc> list = this.ExecuteQueryForList<DeliveryNotebscslc>("SelectDeliveryNoteBSCSLCByBatchNbrErrorOnly", batchNbr);
            return list;
        }


    }
}