
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : WaybillInit
 * Created Time: 2011-2-10 14:16:02
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
    /// WaybillInit的Dao
    /// </summary>
    public class WaybillInitDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public WaybillInitDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public WaybillInit GetObject(Guid objKey)
        {
            WaybillInit obj = this.ExecuteQueryForObject<WaybillInit>("SelectWaybillInit", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<WaybillInit> GetAll()
        {
            IList<WaybillInit> list = this.ExecuteQueryForList<WaybillInit>("SelectWaybillInit", null);          
            return list;
        }


        /// <summary>
        /// 查询WaybillInit
        /// </summary>
        /// <returns>返回WaybillInit集合</returns>
		public IList<WaybillInit> SelectByFilter(WaybillInit obj)
		{ 
			IList<WaybillInit> list = this.ExecuteQueryForList<WaybillInit>("SelectByFilterWaybillInit", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(WaybillInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateWaybillInit", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteWaybillInit", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(WaybillInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteWaybillInit", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(WaybillInit obj)
        {
            this.ExecuteInsert("InsertWaybillInit", obj);           
        }

        /// <summary>
        /// 调用存储过程
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize(Guid UserId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_UploadWaybill", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        public DataSet GetErrorList(Guid UserId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectErrorWaybillInit", UserId);
            return ds;
        }

        /// <summary>
        /// 根据USERID删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int DeleteByUserID(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteByUserIdWaybillInit", objKey);
            return cnt;
        }
    }
}