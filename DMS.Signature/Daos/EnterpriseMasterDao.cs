
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : EnterpriseMaster
 * Created Time: 2017/12/19 16:04:14
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
    /// EnterpriseMaster的Dao
    /// </summary>
    public class EnterpriseMasterDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public EnterpriseMasterDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public EnterpriseMaster GetObject(Guid objKey)
        {
            EnterpriseMaster obj = this.ExecuteQueryForObject<EnterpriseMaster>("SelectEnterpriseMaster", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<EnterpriseMaster> GetAll()
        {
            IList<EnterpriseMaster> list = this.ExecuteQueryForList<EnterpriseMaster>("SelectEnterpriseMaster", null);          
            return list;
        }


        /// <summary>
        /// 查询EnterpriseMaster
        /// </summary>
        /// <returns>返回EnterpriseMaster集合</returns>
		public IList<EnterpriseMaster> SelectByFilter(EnterpriseMaster obj)
		{ 
			IList<EnterpriseMaster> list = this.ExecuteQueryForList<EnterpriseMaster>("SelectByFilterEnterpriseMaster", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(EnterpriseMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateEnterpriseMaster", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteEnterpriseMaster", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(EnterpriseMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteEnterpriseMaster", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(EnterpriseMaster obj)
        {
            this.ExecuteInsert("InsertEnterpriseMaster", obj);           
        }

        
        public DataTable QueryEnterpriseMasterByDealerId(Hashtable table)
        {
            return this.ExecuteQueryForDataSet("QueryEnterpriseMasterByDealerId", table).Tables[0];
        }

        public DataTable QueryEnterpriseMasterByAccountUid(Hashtable table)
        {
            return this.ExecuteQueryForDataSet("QueryEnterpriseMasterByAccountUid", table).Tables[0];
        }
        
    }
}