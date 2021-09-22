
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : EnterpriseAuthentication
 * Created Time: 2018/1/5 16:52:08
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Signature;
using DMS.Signature.Model;
using System.Data;

namespace DMS.Signature.Daos
{
    /// <summary>
    /// EnterpriseAuthentication的Dao
    /// </summary>
    public class EnterpriseAuthenticationDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public EnterpriseAuthenticationDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public EnterpriseAuthentication GetObject(Guid objKey)
        {
            EnterpriseAuthentication obj = this.ExecuteQueryForObject<EnterpriseAuthentication>("SelectEnterpriseAuthentication", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<EnterpriseAuthentication> GetAll()
        {
            IList<EnterpriseAuthentication> list = this.ExecuteQueryForList<EnterpriseAuthentication>("SelectEnterpriseAuthentication", null);
            return list;
        }


        /// <summary>
        /// 查询EnterpriseAuthentication
        /// </summary>
        /// <returns>返回EnterpriseAuthentication集合</returns>
		public IList<EnterpriseAuthentication> SelectByFilter(EnterpriseAuthentication obj)
        {
            IList<EnterpriseAuthentication> list = this.ExecuteQueryForList<EnterpriseAuthentication>("SelectByFilterEnterpriseAuthentication", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(EnterpriseAuthentication obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateEnterpriseAuthentication", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteEnterpriseAuthentication", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(EnterpriseAuthentication obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteEnterpriseAuthentication", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(EnterpriseAuthentication obj)
        {
            this.ExecuteInsert("InsertEnterpriseAuthentication", obj);
        }


        public DataTable QueryEnterpriseAuthenticationByFilter(Hashtable table)
        {
            return base.ExecuteQueryForDataSet("QueryEnterpriseAuthenticationByFilter", table).Tables[0];
        }

        public EnterpriseAuthentication QueryEnterpriseAuthenticationByDealerId(Hashtable table)
        {
            EnterpriseAuthentication obj = this.ExecuteQueryForObject<EnterpriseAuthentication>("QueryEnterpriseAuthenticationByDealerId", table);
            return obj;
        }

        public DataTable QueryEnterpriseRegisterByFilter(Hashtable table)
        {
            return base.ExecuteQueryForDataSet("QueryEnterpriseRegisterByFilter", table).Tables[0];
        }

        public DataTable QuerySubBranchByKeyWord(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return this.ExecuteQueryForDataSet("QuerySubBranchByKeyWord", table, start, limit, out totalRowCount).Tables[0];
        }
    }
}