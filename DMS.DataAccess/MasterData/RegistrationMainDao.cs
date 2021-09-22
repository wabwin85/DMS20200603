
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : RegistrationMain
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
    /// RegistrationMain的Dao
    /// </summary>
    public class RegistrationMainDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public RegistrationMainDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public RegistrationMain GetObject(Guid objKey)
        {
            RegistrationMain obj = this.ExecuteQueryForObject<RegistrationMain>("SelectRegistrationMain", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<RegistrationMain> GetAll()
        {
            IList<RegistrationMain> list = this.ExecuteQueryForList<RegistrationMain>("SelectRegistrationMain", null);          
            return list;
        }


        /// <summary>
        /// 查询RegistrationMain
        /// </summary>
        /// <returns>返回RegistrationMain集合</returns>
		public IList<RegistrationMain> SelectByFilter(RegistrationMain obj)
		{ 
			IList<RegistrationMain> list = this.ExecuteQueryForList<RegistrationMain>("SelectByFilterRegistrationMain", obj);          
            return list;
		}

        /// <summary>
        /// 查询RegistrationMain,带分页
        /// </summary>
        /// <returns>返回RegistrationMain集合</returns>
        public DataSet SelectByFilter(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("SelectByFilterRegistrationMain", obj, start, limit, out totalRowCount);
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(RegistrationMain obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateRegistrationMain", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteRegistrationMain", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(RegistrationMain obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteRegistrationMain", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(RegistrationMain obj)
        {
            this.ExecuteInsert("InsertRegistrationMain", obj);           
        }


    }
}