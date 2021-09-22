
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ArrivalDateInit
 * Created Time: 2011-2-10 11:59:48
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
    /// ArrivalDateInit的Dao
    /// </summary>
    public class ArrivalDateInitDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ArrivalDateInitDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ArrivalDateInit GetObject(Guid objKey)
        {
            ArrivalDateInit obj = this.ExecuteQueryForObject<ArrivalDateInit>("SelectArrivalDateInit", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ArrivalDateInit> GetAll()
        {
            IList<ArrivalDateInit> list = this.ExecuteQueryForList<ArrivalDateInit>("SelectArrivalDateInit", null);          
            return list;
        }


        /// <summary>
        /// 查询ArrivalDateInit
        /// </summary>
        /// <returns>返回ArrivalDateInit集合</returns>
		public IList<ArrivalDateInit> SelectByFilter(ArrivalDateInit obj)
		{ 
			IList<ArrivalDateInit> list = this.ExecuteQueryForList<ArrivalDateInit>("SelectByFilterArrivalDateInit", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ArrivalDateInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateArrivalDateInit", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteArrivalDateInit", objKey);            
            return cnt;
        }

        /// <summary>
        /// 根据USERID删除上传记录
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public int DeleteByUserId(Guid UserId)
        {
            int cnt = (int)this.ExecuteUpdate("DeleteArrivalDateInitByUserId", UserId);
            return cnt;
        }

		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ArrivalDateInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteArrivalDateInit", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ArrivalDateInit obj)
        {
            this.ExecuteInsert("InsertArrivalDateInit", obj);           
        }

        /// <summary>
        /// 调用存储过程
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize(Guid UserId,string FileName)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("FileName", FileName);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_UploadArrivalDate", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        /// 获取错误信息
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public DataSet GetErrorList(Guid UserId,string FileName)
        {
            ArrivalDateInit obj = new ArrivalDateInit();
            obj.User = UserId;
            obj.FileName = FileName;
            DataSet ds = this.ExecuteQueryForDataSet("SelectErrorArrivalDateInit", obj);
            return ds;
        }
    }
}