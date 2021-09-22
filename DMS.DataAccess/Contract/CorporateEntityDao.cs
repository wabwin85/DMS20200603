
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : CorporateEntity
 * Created Time: 2013/11/12 17:41:42
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
    /// CorporateEntity的Dao
    /// </summary>
    public class CorporateEntityDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public CorporateEntityDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public CorporateEntity GetObject(Guid objKey)
        {
            CorporateEntity obj = this.ExecuteQueryForObject<CorporateEntity>("SelectCorporateEntity", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<CorporateEntity> GetAll()
        {
            IList<CorporateEntity> list = this.ExecuteQueryForList<CorporateEntity>("SelectCorporateEntity", null);          
            return list;
        }


        /// <summary>
        /// 查询CorporateEntity
        /// </summary>
        /// <returns>返回CorporateEntity集合</returns>
		public IList<CorporateEntity> SelectByFilter(CorporateEntity obj)
		{ 
			IList<CorporateEntity> list = this.ExecuteQueryForList<CorporateEntity>("SelectByFilterCorporateEntity", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(CorporateEntity obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateCorporateEntity", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteCorporateEntity", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(CorporateEntity obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteCorporateEntity", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(CorporateEntity obj)
        {
            this.ExecuteInsert("InsertCorporateEntity", obj);           
        }

        /// <summary>
        /// 查询CorporateEntity
        /// </summary>
        /// <returns>返回CorporateEntity集合</returns>
        public DataSet SelectCorporateEntityByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectCorporateEntityByFilter", table);
            return ds;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdateCorporateEntityByFilter(CorporateEntity obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateCorporateEntityByFilter", obj);
            return cnt;
        }
    }
}