
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : EnterprisePayAuth
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

namespace DMS.Signature.Daos
{
    /// <summary>
    /// EnterprisePayAuth的Dao
    /// </summary>
    public class EnterprisePayAuthDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public EnterprisePayAuthDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public EnterprisePayAuth GetObject(Guid objKey)
        {
            EnterprisePayAuth obj = this.ExecuteQueryForObject<EnterprisePayAuth>("SelectEnterprisePayAuth", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<EnterprisePayAuth> GetAll()
        {
            IList<EnterprisePayAuth> list = this.ExecuteQueryForList<EnterprisePayAuth>("SelectEnterprisePayAuth", null);
            return list;
        }


        /// <summary>
        /// 查询EnterprisePayAuth
        /// </summary>
        /// <returns>返回EnterprisePayAuth集合</returns>
		public IList<EnterprisePayAuth> SelectByFilter(EnterprisePayAuth obj)
        {
            IList<EnterprisePayAuth> list = this.ExecuteQueryForList<EnterprisePayAuth>("SelectByFilterEnterprisePayAuth", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(EnterprisePayAuth obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateEnterprisePayAuth", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteEnterprisePayAuth", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(EnterprisePayAuth obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteEnterprisePayAuth", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(EnterprisePayAuth obj)
        {
            this.ExecuteInsert("InsertEnterprisePayAuth", obj);
        }


        public EnterprisePayAuth QueryEnterprisePayAuthByDealerId(Hashtable table)
        {
            EnterprisePayAuth obj = this.ExecuteQueryForObject<EnterprisePayAuth>("QueryEnterprisePayAuthByDealerId", table);
            return obj;
        }
    }
}