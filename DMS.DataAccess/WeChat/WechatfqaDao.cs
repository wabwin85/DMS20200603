
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : Wechatfqa
 * Created Time: 2014/5/29 13:48:01
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
    /// Wechatfqa的Dao
    /// </summary>
    public class WechatfqaDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public WechatfqaDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public Wechatfqa GetObject(Guid objKey)
        {
            Wechatfqa obj = this.ExecuteQueryForObject<Wechatfqa>("SelectWechatfqa", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<Wechatfqa> GetAll()
        {
            IList<Wechatfqa> list = this.ExecuteQueryForList<Wechatfqa>("SelectWechatfqa", null);
            return list;
        }


        /// <summary>
        /// 查询Wechatfqa
        /// </summary>
        /// <returns>返回Wechatfqa集合</returns>
        public IList<Wechatfqa> SelectByFilter(Wechatfqa obj)
        {
            IList<Wechatfqa> list = this.ExecuteQueryForList<Wechatfqa>("SelectByFilterWechatfqa", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(Wechatfqa obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateWechatfqa", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteWechatfqa", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(Wechatfqa obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteWechatfqa", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(Wechatfqa obj)
        {
            this.ExecuteInsert("InsertWechatfqa", obj);
        }

        public DataSet GetFunctionSuggest(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFunctionSuggest", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetFunctionSuggest(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFunctionSuggest", obj);
            return ds;
        }

        public DataSet GetFQA(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByWechatfqa", obj, start, limit, out totalCount);
            return ds;
        }

        public Wechatfqa GetFQAByFqaId(Guid id)
        {
            Wechatfqa obj = this.ExecuteQueryForObject<Wechatfqa>("SelectWechatfqa", id);
            return obj;
        }

        public DataSet GetFQAList()
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFQAList", null);
            return ds;
        }

        public DataSet GetFQAAnnexList()
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFQAAnnexList", null);
            return ds;
        }
    }
}