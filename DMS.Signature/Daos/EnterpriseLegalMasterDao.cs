
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : EnterpriseLegalMaster
 * Created Time: 2018/10/23 18:00:57
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
    /// EnterpriseLegalMaster的Dao
    /// </summary>
    public class EnterpriseLegalMasterDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public EnterpriseLegalMasterDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public EnterpriseLegalMaster GetObject(Guid objKey)
        {
            EnterpriseLegalMaster obj = this.ExecuteQueryForObject<EnterpriseLegalMaster>("SelectEnterpriseLegalMaster", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<EnterpriseLegalMaster> GetAll()
        {
            IList<EnterpriseLegalMaster> list = this.ExecuteQueryForList<EnterpriseLegalMaster>("SelectEnterpriseLegalMaster", null);          
            return list;
        }


        /// <summary>
        /// 查询EnterpriseLegalMaster
        /// </summary>
        /// <returns>返回EnterpriseLegalMaster集合</returns>
		public IList<EnterpriseLegalMaster> SelectByFilter(EnterpriseLegalMaster obj)
		{ 
			IList<EnterpriseLegalMaster> list = this.ExecuteQueryForList<EnterpriseLegalMaster>("SelectByFilterEnterpriseLegalMaster", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(EnterpriseLegalMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateEnterpriseLegalMaster", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteEnterpriseLegalMaster", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(EnterpriseLegalMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteEnterpriseLegalMaster", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(EnterpriseLegalMaster obj)
        {
            this.ExecuteInsert("InsertEnterpriseLegalMaster", obj);           
        }


    }
}