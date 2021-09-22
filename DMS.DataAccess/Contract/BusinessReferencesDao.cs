
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : BusinessReferences
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
    /// BusinessReferences的Dao
    /// </summary>
    public class BusinessReferencesDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public BusinessReferencesDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public BusinessReferences GetObject(Guid objKey)
        {
            BusinessReferences obj = this.ExecuteQueryForObject<BusinessReferences>("SelectBusinessReferences", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<BusinessReferences> GetAll()
        {
            IList<BusinessReferences> list = this.ExecuteQueryForList<BusinessReferences>("SelectBusinessReferences", null);          
            return list;
        }


        /// <summary>
        /// 查询BusinessReferences
        /// </summary>
        /// <returns>返回BusinessReferences集合</returns>
		public IList<BusinessReferences> SelectByFilter(BusinessReferences obj)
		{ 
			IList<BusinessReferences> list = this.ExecuteQueryForList<BusinessReferences>("SelectByFilterBusinessReferences", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(BusinessReferences obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateBusinessReferences", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteBusinessReferences", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(BusinessReferences obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteBusinessReferences", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(BusinessReferences obj)
        {
            this.ExecuteInsert("InsertBusinessReferences", obj);           
        }

        /// <summary>
        /// 查询BusinessReferences
        /// </summary>
        /// <returns>返回BusinessReferences集合</returns>
        public DataSet SelectBusinessReferencesByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectBusinessReferencesByFilter", table);
            return ds;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdateBusinessReferencesByFilter(BusinessReferences obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateBusinessReferencesByFilter", obj);
            return cnt;
        }
    }
}