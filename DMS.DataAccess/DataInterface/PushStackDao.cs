
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : SalesNote
 * Created Time: 2013/9/2 16:51:42
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
    /// SalesNote的Dao
    /// </summary>
    public class PushStackDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public PushStackDao(): base()
        {
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(Hashtable obj)
        {
            this.ExecuteInsert("PushStackMap.Insert", obj);           
        }

    }
}