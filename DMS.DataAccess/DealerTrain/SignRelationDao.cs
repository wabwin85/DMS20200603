
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : SignRelation
 * Created Time: 2015/7/31 10:50:03
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
    /// SignRelation的Dao
    /// </summary>
    public class SignRelationDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public SignRelationDao()
            : base()
        {
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteSignRelation", objKey);
            return cnt;
        }





        public DataSet SelectSignRelationListBySignId(String signId, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSignRelationListBySignId", signId, start, limit, out totalCount);
            return ds;
        }


        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(SignRelation obj)
        {
            this.ExecuteInsert("InsertSignRelation", obj);
        }

        public int DeleteSignRelationBySignId(String signId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteSignRelationBySignId", signId);
            return cnt;
        }

        public int SelectDelaerSalesRecordCount(String signRelationId)
        {
            int cnt = this.ExecuteQueryForObject<int>("SelectDelaerSalesRecordCount", signRelationId);
            return cnt;
        }
    }
}