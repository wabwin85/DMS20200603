
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : BusinessLicense
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
    /// BusinessLicense的Dao
    /// </summary>
    public class BusinessLicenseDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public BusinessLicenseDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public BusinessLicense GetObject(Guid objKey)
        {
            BusinessLicense obj = this.ExecuteQueryForObject<BusinessLicense>("SelectBusinessLicense", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<BusinessLicense> GetAll()
        {
            IList<BusinessLicense> list = this.ExecuteQueryForList<BusinessLicense>("SelectBusinessLicense", null);          
            return list;
        }


        /// <summary>
        /// 查询BusinessLicense
        /// </summary>
        /// <returns>返回BusinessLicense集合</returns>
		public IList<BusinessLicense> SelectByFilter(BusinessLicense obj)
		{ 
			IList<BusinessLicense> list = this.ExecuteQueryForList<BusinessLicense>("SelectByFilterBusinessLicense", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(BusinessLicense obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateBusinessLicense", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteBusinessLicense", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(BusinessLicense obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteBusinessLicense", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(BusinessLicense obj)
        {
            this.ExecuteInsert("InsertBusinessLicense", obj);           
        }

        /// <summary>
        /// 查询BusinessLicense
        /// </summary>
        /// <returns>返回BusinessLicense集合</returns>
        public DataSet SelectBusinessLicenseByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectBusinessLicenseByFilter", table);
            return ds;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdateBusinessLicenseByFilter(BusinessLicense obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateBusinessLicenseByFilter", obj);
            return cnt;
        }

    }
}