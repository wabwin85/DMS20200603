
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
    /// BscUser的Dao
    /// </summary>
    public class BscUserDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public BscUserDao()
            : base()
        {
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(BscUser obj)
        {
            this.ExecuteInsert("InsertBscUser", obj);
        }

        public void Update(BscUser obj)
        {
            this.ExecuteUpdate("UpdateBscUser", obj);
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteBscUser", objKey);
            return cnt;
        }

        public DataSet SelectBscUserList(Hashtable condition, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectBscUserList", condition, start, limit, out totalCount);
            return ds;
        }

        public DataSet SelectBscUserAllList(Hashtable condition)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectBscUserList", condition);
            return ds;
        }

        public Hashtable SelectBscUserInfo(String bscUserId)
        {
            Hashtable ds = this.ExecuteQueryForObject<Hashtable>("SelectBscUserInfo", bscUserId);
            return ds;
        }
    }
}