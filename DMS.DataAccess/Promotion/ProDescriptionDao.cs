
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ProPolicy
 * Created Time: 2015/11/10 16:59:13
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
    /// ProDescription的Dao
    /// </summary>
    public class ProDescriptionDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public ProDescriptionDao()
            : base()
        {
        }

        /// <summary>
        /// 根据说明类型查询说明列表
        /// </summary>
        /// <param name="descType"></param>
        /// <returns></returns>
        public IList<Hashtable> SelectProDescriptioinList(String descType)
        {
            IList<Hashtable> list = this.ExecuteQueryForList<Hashtable>("ProDescription.SelectProDescriptioinList", descType);
            return list;
        }
    }
}