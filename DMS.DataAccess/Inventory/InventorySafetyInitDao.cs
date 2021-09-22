
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InventorySafetyInit
 * Created Time: 2013/7/25 17:33:44
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;

namespace DMS.DataAccess
{
    /// <summary>
    /// InventorySafetyInit的Dao
    /// </summary>
    public class InventorySafetyInitDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InventorySafetyInitDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InventorySafetyInit GetObject(Guid objKey)
        {
            InventorySafetyInit obj = this.ExecuteQueryForObject<InventorySafetyInit>("SelectInventorySafetyInit", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InventorySafetyInit> GetAll()
        {
            IList<InventorySafetyInit> list = this.ExecuteQueryForList<InventorySafetyInit>("SelectInventorySafetyInit", null);          
            return list;
        }


        /// <summary>
        /// 查询InventorySafetyInit
        /// </summary>
        /// <returns>返回InventorySafetyInit集合</returns>
		public IList<InventorySafetyInit> SelectByFilter(InventorySafetyInit obj)
		{ 
			IList<InventorySafetyInit> list = this.ExecuteQueryForList<InventorySafetyInit>("SelectByFilterInventorySafetyInit", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InventorySafetyInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventorySafetyInit", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventorySafetyInit", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InventorySafetyInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInventorySafetyInit", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InventorySafetyInit obj)
        {
            this.ExecuteInsert("InsertInventorySafetyInit", obj);           
        }

        /// <summary>
        /// 根据用户删除数据
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public int DeleteByUser(Guid UserId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventorySafetyInitByUser", UserId);
            return cnt;
        }

        /// <summary>
        /// 调用存储过程
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize(Guid UserId,Guid DealerId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("DealerId", DealerId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_InventorySafetyInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        /// 根据条件查询
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public IList<InventorySafetyInit> SelectByHashtable(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            IList<InventorySafetyInit> list = this.ExecuteQueryForList<InventorySafetyInit>("SelectInventorySafetyInitByHashtable", obj, start, limit, out totalRowCount);
            return list;
        }
    }
}