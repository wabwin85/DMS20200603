
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : AopDealer
 * Created Time: 2010-3-22 15:35:36
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using System.Data;
using DMS.Model;

namespace DMS.DataAccess
{
    /// <summary>
    /// AopDealer的Dao
    /// </summary>
    public class AopDealerDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public AopDealerDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public AopDealer GetObject(Guid objKey)
        {
            AopDealer obj = this.ExecuteQueryForObject<AopDealer>("SelectAopDealer", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<AopDealer> GetAll()
        {
            IList<AopDealer> list = this.ExecuteQueryForList<AopDealer>("SelectAopDealer", null);
            return list;
        }


        /// <summary>
        /// 查询AopDealer
        /// </summary>
        /// <returns>返回AopDealer集合</returns>
        public IList<AopDealer> SelectByFilter(AopDealer obj)
        {
            IList<AopDealer> list = this.ExecuteQueryForList<AopDealer>("SelectByFilterAopDealer", obj);
            return list;
        }

        public DataSet GetYearAOPAll(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealerByQuery", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetAopDealersByFiller(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealersByFiller", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetHospitalProductFiller(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductFiller", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetYearAOPAll(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealerByQuery", obj);
            return ds;
        }

        public object GetDealerCurrentQAop(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectCurrentAopDealer", obj);
            if (ds.Tables[0].Rows.Count > 0) return ds.Tables[0].Rows[0]["Amount"];
            return null;
        }
        ///// <summary>
        ///// 更新实体
        ///// </summary>
        ///// <param name="obj">实体</param>
        ///// <returns>更新数目</returns>
        //public int Update(AopDealer obj)
        //{
        //    int cnt = (int)this.ExecuteUpdate("UpdateAopDealer", obj);
        //    return cnt;
        //}



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAopDealer", obj);
            return cnt;
        }


        ///// <summary>
        ///// 逻辑删除实体
        ///// </summary>
        ///// <param name="obj">实体</param>
        ///// <returns>删除数目</returns>
        //public int FakeDelete(AopDealer obj)
        //{
        //    int cnt = (int)this.ExecuteUpdate("FakeDeleteAopDealer", obj);
        //    return cnt;
        //}

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(AopDealer obj)
        {
            this.ExecuteInsert("InsertAopDealer", obj);
        }

        public DataSet ExportAop(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportAop", obj);
            return ds;
        }

        public DataSet ExportHospitalAop(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportHospitalAop", obj);
            return ds;
        }

        public DataSet ExportHospitalProductAop(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportHospitalProductAop", obj);
            return ds;
        }

        public DataSet ExporAopDealersByFiller(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExporAopDealersByFiller", obj);
            return ds;
        }

        public DataSet ExportHospitalProductFiller(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportHospitalProductFiller", obj);
            return ds;
        }
    }
}