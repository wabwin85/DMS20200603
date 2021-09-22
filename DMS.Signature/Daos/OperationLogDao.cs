
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : OperationLog
 * Created Time: 2017/12/19 16:04:15
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Signature.Model;

namespace DMS.Signature.Daos
{
    /// <summary>
    /// OperationLog的Dao
    /// </summary>
    public class OperationLogDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public OperationLogDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public OperationLog GetObject(Guid objKey)
        {
            OperationLog obj = this.ExecuteQueryForObject<OperationLog>("SelectOperationLog", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<OperationLog> GetAll()
        {
            IList<OperationLog> list = this.ExecuteQueryForList<OperationLog>("SelectOperationLog", null);          
            return list;
        }


        /// <summary>
        /// 查询OperationLog
        /// </summary>
        /// <returns>返回OperationLog集合</returns>
		public IList<OperationLog> SelectByFilter(OperationLog obj)
		{ 
			IList<OperationLog> list = this.ExecuteQueryForList<OperationLog>("SelectByFilterOperationLog", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(OperationLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateOperationLog", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteOperationLog", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(OperationLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteOperationLog", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(OperationLog obj)
        {
            this.ExecuteInsert("InsertOperationLog", obj);           
        }


    }
}