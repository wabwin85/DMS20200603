
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : EnterpriseLegalSeal
 * Created Time: 2018/10/23 18:00:58
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
    /// EnterpriseLegalSeal的Dao
    /// </summary>
    public class EnterpriseLegalSealDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public EnterpriseLegalSealDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public EnterpriseLegalSeal GetObject(string objKey)
        {
            EnterpriseLegalSeal obj = this.ExecuteQueryForObject<EnterpriseLegalSeal>("SelectEnterpriseLegalSeal", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<EnterpriseLegalSeal> GetAll()
        {
            IList<EnterpriseLegalSeal> list = this.ExecuteQueryForList<EnterpriseLegalSeal>("SelectEnterpriseLegalSeal", null);          
            return list;
        }


        /// <summary>
        /// 查询EnterpriseLegalSeal
        /// </summary>
        /// <returns>返回EnterpriseLegalSeal集合</returns>
		public IList<EnterpriseLegalSeal> SelectByFilter(EnterpriseLegalSeal obj)
		{ 
			IList<EnterpriseLegalSeal> list = this.ExecuteQueryForList<EnterpriseLegalSeal>("SelectByFilterEnterpriseLegalSeal", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(EnterpriseLegalSeal obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateEnterpriseLegalSeal", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(string objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteEnterpriseLegalSeal", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(EnterpriseLegalSeal obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteEnterpriseLegalSeal", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(EnterpriseLegalSeal obj)
        {
            this.ExecuteInsert("InsertEnterpriseLegalSeal", obj);           
        }


    }
}