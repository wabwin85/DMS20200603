
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : CfnSetDetail
 * Created Time: 2010-4-26 16:43:43
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
    /// CfnSetDetail的Dao
    /// </summary>
    public class CfnSetDetailDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public CfnSetDetailDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public CfnSetDetail GetObject(Guid objKey)
        {
            CfnSetDetail obj = this.ExecuteQueryForObject<CfnSetDetail>("SelectCfnSetDetail", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<CfnSetDetail> GetAll()
        {
            IList<CfnSetDetail> list = this.ExecuteQueryForList<CfnSetDetail>("SelectCfnSetDetail", null);
            return list;
        }


        /// <summary>
        /// 查询CfnSetDetail
        /// </summary>
        /// <returns>返回CfnSetDetail集合</returns>
		public IList<CfnSetDetail> SelectByFilter(CfnSetDetail obj)
        {
            IList<CfnSetDetail> list = this.ExecuteQueryForList<CfnSetDetail>("SelectByFilterCfnSetDetail", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(CfnSetDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateCfnSetDetail", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteCfnSetDetail", objKey);
            return cnt;
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int DeleteByCfnsID(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteCfnSetDetailByCfnsID", objKey);
            return cnt;
        }

        public int DeleteByCFNSetUPN(string MasterUPN)
        {
            int cnt = (int)this.ExecuteDelete("DeleteCfnSetDetailByMasterUPN", MasterUPN);
            return cnt;
        }
        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(CfnSetDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteCfnSetDetail", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(CfnSetDetail obj)
        {
            this.ExecuteInsert("InsertCfnSetDetail", obj);
        }
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void InsertProductBOM(ProductBOM obj)
        {
            this.ExecuteInsert("InsertProductBOM", obj);
        }
        /// <summary>
        /// 成套产品明细信息查询
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCfnSetDetailByCFNSID(Guid CFNSID, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryCfnSetDetailByCFNSID", CFNSID, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet QueryCfnSetDetailByCFNSetUPN(Guid CFNSetUPN, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryCfnSetDetailByUPN", CFNSetUPN, start, limit, out totalRowCount);
            return ds;
        }

        #region added by bozhenfei on 20110218
        /// <summary>
        /// 根据经销商和产品线，根据经销商授权查询成套产品明细
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCFNSetDetailForPurchaseOrderByAuth(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryBSCCFNSetDetailForPurchaseOrderByAuth", table, start, limit, out totalRowCount, true);
            return ds;
        }

        #endregion
        #region add 20151125
        public DataSet QueryConsignmenCfnSetDetailByCFNSID(string CFNSId, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryConsignmenCfnSetDetailByCFNSID", CFNSId, start, limit, out totalRowCount);
            return ds;
        }
        #endregion
    }
}