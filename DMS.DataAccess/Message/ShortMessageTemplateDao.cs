
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ShortMessageTemplate
 * Created Time: 2011-3-24 11:56:29
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
    /// ShortMessageTemplate的Dao
    /// </summary>
    public class ShortMessageTemplateDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ShortMessageTemplateDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ShortMessageTemplate GetObject(Guid objKey)
        {
            ShortMessageTemplate obj = this.ExecuteQueryForObject<ShortMessageTemplate>("SelectShortMessageTemplate", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ShortMessageTemplate> GetAll()
        {
            IList<ShortMessageTemplate> list = this.ExecuteQueryForList<ShortMessageTemplate>("SelectShortMessageTemplate", null);          
            return list;
        }


        /// <summary>
        /// 查询ShortMessageTemplate
        /// </summary>
        /// <returns>返回ShortMessageTemplate集合</returns>
		public IList<ShortMessageTemplate> SelectByFilter(ShortMessageTemplate obj)
		{ 
			IList<ShortMessageTemplate> list = this.ExecuteQueryForList<ShortMessageTemplate>("SelectByFilterShortMessageTemplate", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ShortMessageTemplate obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateShortMessageTemplate", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShortMessageTemplate", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ShortMessageTemplate obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteShortMessageTemplate", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ShortMessageTemplate obj)
        {
            this.ExecuteInsert("InsertShortMessageTemplate", obj);
        }

        #region added by bozhenfei on 20110329
        public ShortMessageTemplate GetObjectByCode(string code)
        {
            ShortMessageTemplate obj = this.ExecuteQueryForObject<ShortMessageTemplate>("SelectShortMessageTemplateByCode", code);
            return obj;
        }
        #endregion 
    }
}