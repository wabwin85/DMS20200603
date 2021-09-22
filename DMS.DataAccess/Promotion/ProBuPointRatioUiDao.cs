
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ProBuPointRatioUi
 * Created Time: 2016/6/6 11:01:41
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
    /// ProBuPointRatioUi的Dao
    /// </summary>
    public class ProBuPointRatioUiDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ProBuPointRatioUiDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ProBuPointRatioUi GetObject(int objKey)
        {
            ProBuPointRatioUi obj = this.ExecuteQueryForObject<ProBuPointRatioUi>("SelectProBuPointRatioUi", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ProBuPointRatioUi> GetAll()
        {
            IList<ProBuPointRatioUi> list = this.ExecuteQueryForList<ProBuPointRatioUi>("SelectProBuPointRatioUi", null);          
            return list;
        }


        /// <summary>
        /// 查询ProBuPointRatioUi
        /// </summary>
        /// <returns>返回ProBuPointRatioUi集合</returns>
		public IList<ProBuPointRatioUi> SelectByFilter(ProBuPointRatioUi obj)
		{ 
			IList<ProBuPointRatioUi> list = this.ExecuteQueryForList<ProBuPointRatioUi>("SelectByFilterProBuPointRatioUi", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ProBuPointRatioUi obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateProBuPointRatioUi", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(int objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteProBuPointRatioUi", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ProBuPointRatioUi obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteProBuPointRatioUi", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ProBuPointRatioUi obj)
        {
            this.ExecuteInsert("InsertProBuPointRatioUi", obj);           
        }
        public void DeletePointRatioUIByCurrUser(string UserId)
        {
            this.ExecuteUpdate("DeletePointRatioUIByCurrUser", UserId);            
        }
        public void VerifyRatioUiInit(string UserId, int IsImport, out string IsValid)
        {
             IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("IsValid", IsValid);
            ht.Add("IsImport", IsImport);
            this.ExecuteInsert("GC_Pro_BU_PointRatioUiInit", ht);

            IsValid = ht["IsValid"].ToString();

        }
        public DataSet QueryPro_BU_PointRatio_UIByUserId(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPro_BU_PointRatio_UIByUserId", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet ExistsByBuDmaId(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExistsByBuDmaId", obj);
            return ds;
        }
        public DataSet QueryPromotionQuotazp(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPromotionQuotazp", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet QueryPromotionQuotajf(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPromotionQuotajf", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet ExporPromotionQuotajf(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExporPromotionQuotajf", obj);
            return ds;
        }
        public DataSet ExporPromotionQuotazp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExporPromotionQuotazp", obj);
            return ds;
        }

        public DataSet GetPromotionQuotajfById(string Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPromotionQuotajfById", Id);
            return ds;
        }
        public DataSet GetPromotionQuotazpById(string Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPromotionQuotazpById", Id);
            return ds;
        }
        public int PromotionAdjustmentLimit(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePromotionLimit", obj);
            return cnt;
        }
        public bool CheckAdjustmentLimitForJF(Hashtable obj)
        {
            bool ret = false;
            DataSet ds = this.ExecuteQueryForDataSet("SelectAdjustmentLimitForJF", obj);
            if (ds.Tables[0].Rows.Count > 0 && Convert.ToDecimal(ds.Tables[0].Rows[0]["SurplusAmount"])>=0)
            {
                ret = true;
            }
            return ret;
        }
        public bool CheckAdjustmentLimitForZP(Hashtable obj)
        {
            bool ret = false;
            DataSet ds = this.ExecuteQueryForDataSet("SelectAdjustmentLimitForZP", obj);
            if (ds.Tables[0].Rows.Count > 0 && Convert.ToDecimal(ds.Tables[0].Rows[0]["SurplusAmount"]) >= 0)
            {
                ret = true;
            }
            return ret;
        }
        public int SubmitAdjustmentLimitForJF(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("SubmitAdjustmentLimitForJF", obj);
            return cnt;
        }
        public int SubmitAdjustmentLimitForZP(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("SubmitAdjustmentLimitForZP", obj);
            return cnt;
        }
        public void InsertAdjustmentLimitLogForJF(Hashtable obj)
        {
            this.ExecuteInsert("InsertAdjustmentLimitLogForJF", obj);
        }
        public void InsertAdjustmentLimitLogForZP(Hashtable obj)
        {
            this.ExecuteInsert("InsertAdjustmentLimitLogForZP", obj);
        }
    }
}