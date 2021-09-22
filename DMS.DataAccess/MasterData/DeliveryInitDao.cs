
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DeliveryInit
 * Created Time: 2010-6-10 10:37:20
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
    /// DeliveryInit的Dao
    /// </summary>
    public class DeliveryInitDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public DeliveryInitDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DeliveryInit GetObject(Guid objKey)
        {
            DeliveryInit obj = this.ExecuteQueryForObject<DeliveryInit>("SelectDeliveryInit", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DeliveryInit> GetAll()
        {
            IList<DeliveryInit> list = this.ExecuteQueryForList<DeliveryInit>("SelectDeliveryInit", null);
            return list;
        }


        /// <summary>
        /// 查询DeliveryInit
        /// </summary>
        /// <returns>返回DeliveryInit集合</returns>
		public IList<DeliveryInit> SelectByFilter(DeliveryInit obj)
        {
            IList<DeliveryInit> list = this.ExecuteQueryForList<DeliveryInit>("SelectByFilterDeliveryInit", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DeliveryInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDeliveryInit", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDeliveryInit", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DeliveryInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDeliveryInit", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DeliveryInit obj)
        {
            this.ExecuteInsert("InsertDeliveryInit", obj);
        }

        //added by bozhenfei on 20100610
        public int DeleteDeliveryInitByUser(Guid UserId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDeliveryInitByUser", UserId);
            return cnt;
        }

        public IList<DeliveryInit> QueryErrorDeliveryInit(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            IList<DeliveryInit> list = this.ExecuteQueryForList<DeliveryInit>("QueryErrorDeliveryInit", obj, start, limit, out totalRowCount);
            return list;
        }

        public string Generate(Guid UserId, string SubCompanyId, string BrandId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_ImportPOReceipt", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        //end
    }
}