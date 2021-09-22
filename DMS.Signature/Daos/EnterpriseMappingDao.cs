
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : EnterpriseMapping
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

namespace DMS.Signature.Daos
{
    /// <summary>
    /// EnterpriseMapping的Dao
    /// </summary>
    public class EnterpriseMappingDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public EnterpriseMappingDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public EnterpriseMapping GetObject(Guid objKey)
        {
            EnterpriseMapping obj = this.ExecuteQueryForObject<EnterpriseMapping>("SelectEnterpriseMapping", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<EnterpriseMapping> GetAll()
        {
            IList<EnterpriseMapping> list = this.ExecuteQueryForList<EnterpriseMapping>("SelectEnterpriseMapping", null);          
            return list;
        }


        /// <summary>
        /// 查询EnterpriseMapping
        /// </summary>
        /// <returns>返回EnterpriseMapping集合</returns>
		public IList<EnterpriseMapping> SelectByFilter(EnterpriseMapping obj)
		{ 
			IList<EnterpriseMapping> list = this.ExecuteQueryForList<EnterpriseMapping>("SelectByFilterEnterpriseMapping", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(EnterpriseMapping obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateEnterpriseMapping", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteEnterpriseMapping", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(EnterpriseMapping obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteEnterpriseMapping", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(EnterpriseMapping obj)
        {
            this.ExecuteInsert("InsertEnterpriseMapping", obj);           
        }

        public EnterpriseMapping QueryEnterpriseMappingByFilter(Hashtable table)
        {
            EnterpriseMapping obj = this.ExecuteQueryForObject<EnterpriseMapping>("QueryEnterpriseMappingByFilter", table);
            return obj;
        }
    }
}