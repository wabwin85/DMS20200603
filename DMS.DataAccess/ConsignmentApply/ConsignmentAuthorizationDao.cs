
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ConsignmentAuthorization
 * Created Time: 2015/11/13 16:24:25
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
    /// ConsignmentAuthorization的Dao
    /// </summary>
    public class ConsignmentAuthorizationDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ConsignmentAuthorizationDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ConsignmentAuthorization GetObject(Guid objKey)
        {
            ConsignmentAuthorization obj = this.ExecuteQueryForObject<ConsignmentAuthorization>("SelectConsignmentAuthorization", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ConsignmentAuthorization> GetAll()
        {
            IList<ConsignmentAuthorization> list = this.ExecuteQueryForList<ConsignmentAuthorization>("SelectConsignmentAuthorization", null);          
            return list;
        }


        /// <summary>
        /// 查询ConsignmentAuthorization
        /// </summary>
        /// <returns>返回ConsignmentAuthorization集合</returns>
		public IList<ConsignmentAuthorization> SelectByFilter(ConsignmentAuthorization obj)
		{ 
			IList<ConsignmentAuthorization> list = this.ExecuteQueryForList<ConsignmentAuthorization>("SelectByFilterConsignmentAuthorization", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ConsignmentAuthorization obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateConsignmentAuthorization", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteConsignmentAuthorization", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ConsignmentAuthorization obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteConsignmentAuthorization", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ConsignmentAuthorization obj)
        {
            this.ExecuteInsert("InsertConsignmentAuthorization", obj);           
        }
      
    }
}