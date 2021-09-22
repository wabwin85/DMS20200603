
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : PublicOffice
 * Created Time: 2013/11/12 17:41:43
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
    /// PublicOffice的Dao
    /// </summary>
    public class PublicOfficeDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public PublicOfficeDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public PublicOffice GetObject(Guid objKey)
        {
            PublicOffice obj = this.ExecuteQueryForObject<PublicOffice>("SelectPublicOffice", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<PublicOffice> GetAll()
        {
            IList<PublicOffice> list = this.ExecuteQueryForList<PublicOffice>("SelectPublicOffice", null);          
            return list;
        }


        /// <summary>
        /// 查询PublicOffice
        /// </summary>
        /// <returns>返回PublicOffice集合</returns>
		public IList<PublicOffice> SelectByFilter(PublicOffice obj)
		{ 
			IList<PublicOffice> list = this.ExecuteQueryForList<PublicOffice>("SelectByFilterPublicOffice", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(PublicOffice obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePublicOffice", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeletePublicOffice", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(PublicOffice obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeletePublicOffice", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(PublicOffice obj)
        {
            this.ExecuteInsert("InsertPublicOffice", obj);           
        }


        /// <summary>
        /// 查询PublicOffice
        /// </summary>
        /// <returns>返回PublicOffice集合</returns>
        public DataSet SelectPublicOfficeByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPublicOfficeByFilter", table);
            return ds;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdatePublicOfficeByFilter(PublicOffice obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePublicOfficeByFilter", obj);
            return cnt;
        }
    }
}