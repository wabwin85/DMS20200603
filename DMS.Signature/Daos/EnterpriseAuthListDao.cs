
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : EnterpriseAuthList
 * Created Time: 2018/1/15 14:16:59
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Signature.Model;
using System.Data;

namespace DMS.Signature.Daos
{
    /// <summary>
    /// EnterpriseAuthList的Dao
    /// </summary>
    public class EnterpriseAuthListDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public EnterpriseAuthListDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public EnterpriseAuthList GetObject(Guid objKey)
        {
            EnterpriseAuthList obj = this.ExecuteQueryForObject<EnterpriseAuthList>("SelectEnterpriseAuthList", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<EnterpriseAuthList> GetAll()
        {
            IList<EnterpriseAuthList> list = this.ExecuteQueryForList<EnterpriseAuthList>("SelectEnterpriseAuthList", null);          
            return list;
        }


        /// <summary>
        /// 查询EnterpriseAuthList
        /// </summary>
        /// <returns>返回EnterpriseAuthList集合</returns>
		public IList<EnterpriseAuthList> SelectByFilter(EnterpriseAuthList obj)
		{ 
			IList<EnterpriseAuthList> list = this.ExecuteQueryForList<EnterpriseAuthList>("SelectByFilterEnterpriseAuthList", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(EnterpriseAuthList obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateEnterpriseAuthList", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteEnterpriseAuthList", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(EnterpriseAuthList obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteEnterpriseAuthList", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(EnterpriseAuthList obj)
        {
            this.ExecuteInsert("InsertEnterpriseAuthList", obj);           
        }
    }
}