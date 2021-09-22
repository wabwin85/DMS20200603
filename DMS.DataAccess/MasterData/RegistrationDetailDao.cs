
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : RegistrationDetail
 * Created Time: 2010-4-29 9:59:06
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
    /// RegistrationDetail的Dao
    /// </summary>
    public class RegistrationDetailDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public RegistrationDetailDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public RegistrationDetail GetObject(Guid objKey)
        {
            RegistrationDetail obj = this.ExecuteQueryForObject<RegistrationDetail>("SelectRegistrationDetail", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<RegistrationDetail> GetAll()
        {
            IList<RegistrationDetail> list = this.ExecuteQueryForList<RegistrationDetail>("SelectRegistrationDetail", null);          
            return list;
        }


        /// <summary>
        /// 查询RegistrationDetail
        /// </summary>
        /// <returns>返回RegistrationDetail集合</returns>
		public IList<RegistrationDetail> SelectByFilter(RegistrationDetail obj)
		{ 
			IList<RegistrationDetail> list = this.ExecuteQueryForList<RegistrationDetail>("SelectByFilterRegistrationDetail", obj);          
            return list;
		}

        /// <summary>
        /// 查询RegistrationDetail
        /// </summary>
        /// <returns>返回RegistrationDetail集合</returns>
        public DataSet SelectByFilter(Guid obj, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("SelectRegistrationDetail", obj, start, limit, out totalRowCount);
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(RegistrationDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateRegistrationDetail", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteRegistrationDetail", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(RegistrationDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteRegistrationDetail", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(RegistrationDetail obj)
        {
            this.ExecuteInsert("InsertRegistrationDetail", obj);           
        }


    }
}