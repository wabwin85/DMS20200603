
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : SpecialPriceMaster
 * Created Time: 2013/7/24 11:21:17
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
    /// SpecialPriceMaster的Dao
    /// </summary>
    public class SpecialPriceMasterDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public SpecialPriceMasterDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public SpecialPriceMaster GetObject(Guid objKey)
        {
            SpecialPriceMaster obj = this.ExecuteQueryForObject<SpecialPriceMaster>("SelectSpecialPriceMaster", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<SpecialPriceMaster> GetAll()
        {
            IList<SpecialPriceMaster> list = this.ExecuteQueryForList<SpecialPriceMaster>("SelectSpecialPriceMaster", null);
            return list;
        }


        /// <summary>
        /// 查询SpecialPriceMaster
        /// </summary>
        /// <returns>返回SpecialPriceMaster集合</returns>
        public IList<SpecialPriceMaster> SelectByFilter(SpecialPriceMaster obj)
        {
            IList<SpecialPriceMaster> list = this.ExecuteQueryForList<SpecialPriceMaster>("SelectByFilterSpecialPriceMaster", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(SpecialPriceMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateSpecialPriceMaster", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteSpecialPriceMaster", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(SpecialPriceMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteSpecialPriceMaster", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(SpecialPriceMaster obj)
        {
            this.ExecuteInsert("InsertSpecialPriceMaster", obj);
        }


        public IList<SpecialPriceMaster> GetSpecialPriceMasterByDealer(Hashtable obj)
        {
            IList<SpecialPriceMaster> list = this.ExecuteQueryForList<SpecialPriceMaster>("GetSpecialPriceMasterByDealer", obj);
            return list;
        }

        public String GetBOMOrderManHeaderDisc(String PohId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetBOMOrderManHeaderDisc", PohId);
            return ds.Tables[0].Rows[0]["Rate"].ToString();
        }

        public DataSet GetPromotionPolicyByCondition(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetPromotionPolicyByCondition", table);
            return ds;
        }

        public DataSet GetPromotionPolicyById(Guid Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetPromotionPolicyById", Id);
            return ds;
        }

        public DataSet GetPromotionPolicyNameById(Guid Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetPromotionPolicyNameById", Id);
            return ds;
        }
    }
}