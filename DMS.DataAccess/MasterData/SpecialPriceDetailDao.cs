
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : SpecialPriceDetail
 * Created Time: 2013/7/24 11:21:16
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
    /// SpecialPriceDetail的Dao
    /// </summary>
    public class SpecialPriceDetailDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public SpecialPriceDetailDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public SpecialPriceDetail GetObject(Guid objKey)
        {
            SpecialPriceDetail obj = this.ExecuteQueryForObject<SpecialPriceDetail>("SelectSpecialPriceDetail", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<SpecialPriceDetail> GetAll()
        {
            IList<SpecialPriceDetail> list = this.ExecuteQueryForList<SpecialPriceDetail>("SelectSpecialPriceDetail", null);
            return list;
        }


        /// <summary>
        /// 查询SpecialPriceDetail
        /// </summary>
        /// <returns>返回SpecialPriceDetail集合</returns>
        public IList<SpecialPriceDetail> SelectByFilter(SpecialPriceDetail obj)
        {
            IList<SpecialPriceDetail> list = this.ExecuteQueryForList<SpecialPriceDetail>("SelectByFilterSpecialPriceDetail", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(SpecialPriceDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateSpecialPriceDetail", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteSpecialPriceDetail", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(SpecialPriceDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteSpecialPriceDetail", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(SpecialPriceDetail obj)
        {
            this.ExecuteInsert("InsertSpecialPriceDetail", obj);
        }

        /// <summary>
        /// 更新特殊价格产品的数量
        /// </summary>
        /// <param name="pohId">订单主键</param>
        /// <param name="specialPriceId">特殊价格规则主键</param>
        /// <returns>void</returns>
        public void UpdateAvailableQtyByOrderId(Guid pohId,Guid specialPriceId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("SpecialPriceId", specialPriceId);
            ht.Add("PohId", pohId);   
            this.ExecuteUpdate("UpdateAvailableQtyByOrderId", ht);
        }

        /// <summary>
        /// 因单据修改而增加相关的特殊价格产品数量
        /// </summary>
        /// <param name="pohId">订单主键</param>
        /// <param name="specialPriceId">特殊价格规则主键</param>
        /// <returns>void</returns>
        public void AddAvailableQtyByOrderIdForTemporaryOrder(Guid pohId, Guid specialPriceId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("SpecialPriceId", specialPriceId);
            ht.Add("PohId", pohId);
            this.ExecuteUpdate("AddAvailableQtyByOrderIdForTemporaryOrder", ht);
        }


        /// <summary>
        /// 因单据撤销而增加相关的特殊价格产品数量
        /// </summary>
        /// <param name="pohId">订单主键</param>
        /// <param name="specialPriceId">特殊价格规则主键</param>
        /// <returns>void</returns>
        public void AddAvailableQtyByOrderId(Guid pohId, Guid specialPriceId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("SpecialPriceId", specialPriceId);
            ht.Add("PohId", pohId);
            this.ExecuteUpdate("AddAvailableQtyByOrderId", ht);
        }

    }
}