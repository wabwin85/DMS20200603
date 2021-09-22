
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ShortMessageProcess
 * Created Time: 2011-4-1 13:23:07
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
    /// ShortMessageProcess的Dao
    /// </summary>
    public class ShortMessageProcessDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ShortMessageProcessDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ShortMessageProcess GetObject(Guid objKey)
        {
            ShortMessageProcess obj = this.ExecuteQueryForObject<ShortMessageProcess>("SelectShortMessageProcess", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ShortMessageProcess> GetAll()
        {
            IList<ShortMessageProcess> list = this.ExecuteQueryForList<ShortMessageProcess>("SelectShortMessageProcess", null);          
            return list;
        }


        /// <summary>
        /// 查询ShortMessageProcess
        /// </summary>
        /// <returns>返回ShortMessageProcess集合</returns>
		public IList<ShortMessageProcess> SelectByFilter(ShortMessageProcess obj)
		{ 
			IList<ShortMessageProcess> list = this.ExecuteQueryForList<ShortMessageProcess>("SelectByFilterShortMessageProcess", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ShortMessageProcess obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateShortMessageProcess", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShortMessageProcess", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ShortMessageProcess obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteShortMessageProcess", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ShortMessageProcess obj)
        {
            this.ExecuteInsert("InsertShortMessageProcess", obj);
        }

        #region added by bozhenfei on 20110402
        /// <summary>
        /// 得到待处理短信列表
        /// </summary>
        /// <returns></returns>
        public IList<ShortMessageProcess> GetShortMessageProcess()
        {
            IList<ShortMessageProcess> list = this.ExecuteQueryForList<ShortMessageProcess>("GetShortMessageProcess", null);
            return list;
        }
        #endregion
    }
}