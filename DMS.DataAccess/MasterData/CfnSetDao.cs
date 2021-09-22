
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : CfnSet
 * Created Time: 2010-4-26 16:43:42
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
    /// CfnSet的Dao
    /// </summary>
    public class CfnSetDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public CfnSetDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public CfnSet GetObject(Guid objKey)
        {
            CfnSet obj = this.ExecuteQueryForObject<CfnSet>("SelectCfnSet", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<CfnSet> GetAll()
        {
            IList<CfnSet> list = this.ExecuteQueryForList<CfnSet>("SelectCfnSet", null);          
            return list;
        }


        /// <summary>
        /// 查询CfnSet
        /// </summary>
        /// <returns>返回CfnSet集合</returns>
		public IList<CfnSet> SelectByFilter(CfnSet obj)
		{ 
			IList<CfnSet> list = this.ExecuteQueryForList<CfnSet>("SelectByFilterCfnSet", obj);          
            return list;
		}        

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(CfnSet obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateCfnSet", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteCfnSet", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(CfnSet obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteCfnSet", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public object Insert(CfnSet obj)
        {
            return base.ExecuteInsert("InsertCfnSet", obj);           
        }

        /// <summary>
        /// 成套产品信息查询,带分页
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryDataByFilterCfnSet(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryDataByFilterCfnSet", table, start, limit, out totalRowCount);
            return ds;
        }
        /// <summary>
        /// 寄售成套产品信息查询,带分页
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryDataByFilterConsignmentCfnSet(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryDataByFilterConsignmentCfnSet", table, start, limit, out totalRowCount);
            return ds;
        }
        /// <summary>
        /// 根据ID查询CfnSet
        /// </summary>
        /// <returns>返回CfnSet集合</returns>
        public IList<CfnSet> QueryDataByID(String Id)
        {
            IList<CfnSet> list = this.ExecuteQueryForList<CfnSet>("SelectCfnSet",Id);
            return list;
        }
        public DataTable SelectCfnSetById(String Id, string SubCompanyId, string BrandId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("value", Id);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            DataTable dt = this.ExecuteQueryForDataSet("SelectCfnSetById", ht).Tables[0];
            return dt;
        }
        #region added by bozhenfei on 20110217
        /// <summary>
        /// 根据经销商和产品线，根据经销商授权查询成套产品
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCfnSetForPurchaseOrderByAuth(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryBSCCfnSetForPurchaseOrderByAuth", table, start, limit, out totalRowCount);
            return ds;
        }
        #endregion
    }
}