
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealerOperationLog
 * Created Time: 2010-4-9 14:43:34
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
    /// DealerOperationLog的Dao
    /// </summary>
    public class DealerOperationLogDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DealerOperationLogDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerOperationLog GetObject(Guid objKey)
        {
            DealerOperationLog obj = this.ExecuteQueryForObject<DealerOperationLog>("SelectDealerOperationLog", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DealerOperationLog> GetAll()
        {
            IList<DealerOperationLog> list = this.ExecuteQueryForList<DealerOperationLog>("SelectDealerOperationLog", null);          
            return list;
        }


        /// <summary>
        /// 查询DealerOperationLog
        /// </summary>
        /// <returns>返回DealerOperationLog集合</returns>
		public IList<DealerOperationLog> SelectByFilter(DealerOperationLog obj)
		{ 
			IList<DealerOperationLog> list = this.ExecuteQueryForList<DealerOperationLog>("SelectByFilterDealerOperationLog", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerOperationLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerOperationLog", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerOperationLog", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DealerOperationLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDealerOperationLog", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerOperationLog obj)
        {
            this.ExecuteInsert("InsertDealerOperationLog", obj);           
        }


    }
}