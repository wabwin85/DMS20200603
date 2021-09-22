
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : RegistrationInit
 * Created Time: 2010-5-21 13:11:52
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
    /// RegistrationInit的Dao
    /// </summary>
    public class RegistrationInitDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public RegistrationInitDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public RegistrationInit GetObject(Guid objKey)
        {
            RegistrationInit obj = this.ExecuteQueryForObject<RegistrationInit>("SelectRegistrationInit", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<RegistrationInit> GetAll()
        {
            IList<RegistrationInit> list = this.ExecuteQueryForList<RegistrationInit>("SelectRegistrationInit", null);          
            return list;
        }


        /// <summary>
        /// 查询RegistrationInit
        /// </summary>
        /// <returns>返回RegistrationInit集合</returns>
		public IList<RegistrationInit> SelectByFilter(RegistrationInit obj)
		{ 
			IList<RegistrationInit> list = this.ExecuteQueryForList<RegistrationInit>("SelectByFilterRegistrationInit", obj);          
            return list;
		}

        /// <summary>
        /// 查询RegistrationInit
        /// </summary>
        /// <returns>返回RegistrationInit集合</returns>
        public DataSet SelectByFilter(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterRegistrationInit", obj);
            return ds;
        }

        /// <summary>
        /// 查询RegistrationInit带分页
        /// </summary>
        /// <returns>返回RegistrationInit集合</returns>
        public DataSet SelectByFilter(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterRegistrationInit", obj, start, limit, out totalRowCount);
            return ds;
        }


        /// <summary>
        /// 调用存储过程初始化库存

        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize(Guid UserId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_RegistrationInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(RegistrationInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateRegistrationInit", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteRegistrationInit", objKey);            
            return cnt;
        }

        /// <summary>
        /// 通过UserId删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int DeleteByUser(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteRegistrationInitByUser", objKey);
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(RegistrationInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteRegistrationInit", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(RegistrationInit obj)
        {
            this.ExecuteInsert("InsertRegistrationInit", obj);           
        }


    }
}