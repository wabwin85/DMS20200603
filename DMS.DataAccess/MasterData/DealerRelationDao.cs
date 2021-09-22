
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealerRelation
 * Created Time: 2010-5-18 10:00:27
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
    /// DealerRelation的Dao
    /// </summary>
    public class DealerRelationDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DealerRelationDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerRelation GetObject(Guid objKey)
        {
            DealerRelation obj = this.ExecuteQueryForObject<DealerRelation>("SelectDealerRelation", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DealerRelation> GetAll()
        {
            IList<DealerRelation> list = this.ExecuteQueryForList<DealerRelation>("SelectDealerRelation", null);          
            return list;
        }


        /// <summary>
        /// 查询DealerRelation
        /// </summary>
        /// <returns>返回DealerRelation集合</returns>
		public IList<DealerRelation> SelectByFilter(DealerRelation obj)
		{ 
			IList<DealerRelation> list = this.ExecuteQueryForList<DealerRelation>("SelectByFilterDealerRelation", obj);          
            return list;
		}

        /// <summary>
        /// 查询DealerRelation分页
        /// </summary>
        /// <returns>返回DealerRelation集合</returns>
        public IList<DealerRelation> SelectByFilter(DealerRelation obj, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForList<DealerRelation>("SelectByFilterDealerRelation", obj, start, limit, out totalRowCount);
        }
        

        /// <summary>
        /// 验证DealerRelation
        /// </summary>
        /// <returns>返回DealerRelation集合</returns>
        public IList<DealerRelation> SelectByFilterVerify(DealerRelation obj)
        {
            return base.ExecuteQueryForList<DealerRelation>("SelectByFilterDealerRelationVerify", obj);
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerRelation obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerRelation", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerRelation", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DealerRelation obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDealerRelation", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerRelation obj)
        {
            this.ExecuteInsert("InsertDealerRelation", obj);           
        }


    }
}