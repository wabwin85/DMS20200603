
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : EnterpriseSeal
 * Created Time: 2017/12/19 16:04:15
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
    /// EnterpriseSeal的Dao
    /// </summary>
    public class EnterpriseSealDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public EnterpriseSealDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public EnterpriseSeal GetObject(Guid objKey)
        {
            EnterpriseSeal obj = this.ExecuteQueryForObject<EnterpriseSeal>("SelectEnterpriseSeal", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<EnterpriseSeal> GetAll()
        {
            IList<EnterpriseSeal> list = this.ExecuteQueryForList<EnterpriseSeal>("SelectEnterpriseSeal", null);          
            return list;
        }


        /// <summary>
        /// 查询EnterpriseSeal
        /// </summary>
        /// <returns>返回EnterpriseSeal集合</returns>
		public IList<EnterpriseSeal> SelectByFilter(EnterpriseSeal obj)
		{ 
			IList<EnterpriseSeal> list = this.ExecuteQueryForList<EnterpriseSeal>("SelectByFilterEnterpriseSeal", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(EnterpriseSeal obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateEnterpriseSeal", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteEnterpriseSeal", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(EnterpriseSeal obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteEnterpriseSeal", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(EnterpriseSeal obj)
        {
            this.ExecuteInsert("InsertEnterpriseSeal", obj);           
        }


        public DataSet QueryEnterpriseSealByDealerId(Hashtable table)
        {
            return this.ExecuteQueryForDataSet("QueryEnterpriseSealByDealerId", table);
        }

        public IList<EnterpriseSeal> QueryEnterpriseSealByAccountUid(Hashtable table)
        {
            return this.ExecuteQueryForList<EnterpriseSeal>("QueryEnterpriseSealByAccountUid", table);
        }
    }
}