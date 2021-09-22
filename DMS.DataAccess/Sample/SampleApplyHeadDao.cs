
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : SampleApplyHead
 * Created Time: 2016/3/4 13:49:06
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
    /// SampleApplyHead的Dao
    /// </summary>
    public class SampleApplyHeadDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public SampleApplyHeadDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public SampleApplyHead GetObject(Guid objKey)
        {
            SampleApplyHead obj = this.ExecuteQueryForObject<SampleApplyHead>("SelectSampleApplyHead", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<SampleApplyHead> GetAll()
        {
            IList<SampleApplyHead> list = this.ExecuteQueryForList<SampleApplyHead>("SelectSampleApplyHead", null);
            return list;
        }


        /// <summary>
        /// 查询SampleApplyHead
        /// </summary>
        /// <returns>返回SampleApplyHead集合</returns>
        public IList<SampleApplyHead> SelectByFilter(SampleApplyHead obj)
        {
            IList<SampleApplyHead> list = this.ExecuteQueryForList<SampleApplyHead>("SelectByFilterSampleApplyHead", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(SampleApplyHead obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateSampleApplyHead", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteSampleApplyHead", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(SampleApplyHead obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteSampleApplyHead", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(SampleApplyHead obj)
        {
            this.ExecuteInsert("InsertSampleApplyHead", obj);
        }

        //add
        public DataSet SelectSampleApplyList(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSampleApplyList", table, start, limit, out totalRowCount);
            return ds;
        }

        public SampleApplyHead SelectSampleApplyHeadByApplyNo(String applyNo)
        {
            SampleApplyHead obj = this.ExecuteQueryForObject<SampleApplyHead>("SelectSampleApplyHeadByApplyNo", applyNo);
            return obj;
        }

        public String FuncGetSampleApplyHtml(Guid applyId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("FuncGetSampleApplyHtml", applyId);
            return ds.Tables[0].Rows[0]["SampleApplyHtml"].ToString();
        }

        public DataTable SelectSampleApplyDelivery(Hashtable condition)
        {
            return base.ExecuteQueryForDataSet("SelectSampleApplyDelivery", condition).Tables[0];
        }

        public void UpdateSampleApplyDeliveryStatus(Hashtable condition)
        {
            this.ExecuteUpdate("UpdateSampleApplyDeliveryStatus", condition);
        }

        public DataTable SelectSampleDeliveryList(String sampleNo)
        {
            return base.ExecuteQueryForDataSet("SelectSampleDeliveryList", sampleNo).Tables[0];
        }

        public DataTable SelectSampleRemainList(Hashtable ht)
        {
            return base.ExecuteQueryForDataSet("SelectSampleRemainList", ht).Tables[0];
        }

        public void ProcSaveDpDelivery(Hashtable condition)
        {
            base.ExecuteUpdate("ProcSaveDpDelivery", condition);
        }

        public DataTable SelectSampleTrace(Guid applyId)
        {
            return base.ExecuteQueryForDataSet("SelectSampleTrace", applyId).Tables[0];
        }

        public void UpdateDeliveryStatus(Hashtable condition)
        {
            base.ExecuteUpdate("UpdateDeliveryStatus", condition);
        }

        public void ProcReceiveReturnSample(Hashtable condition)
        {
            base.ExecuteUpdate("ProcReceiveReturnSample", condition);
        }

        #region added by bozhenfei on 2016-08-11
        public bool IsNewCertificate(Guid HeadId)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SampleApplyIsNewCertificate", HeadId);
            return Convert.ToInt32(ds.Tables[0].Rows[0][0]) > 0;
        }

        public void CheckUPN(Guid HeadId)
        {
            base.ExecuteQueryForDataSet("SampleApplyCheckUPN", HeadId);
        }
        #endregion

        public void CreatePurchaseOrderHeaderBySampleID(Guid HeadId)
        {
            this.ExecuteInsert("InsertPurchaseOrderHeaderBySampleId", HeadId);
        }
        public void CreatePurchaseOrderDetailBySampleID(Guid HeadId)
        {
            this.ExecuteInsert("InsertPurchaseOrderDetailBySampleId", HeadId);
        }

        public DataSet GetUserAccountByEID(string eid)
        {
            DataSet ds = base.ExecuteQueryForDataSet("GetUserAccountByEID", eid);
            return ds;
        }
        //修改商业样品的申请UPN数量
        public DataSet GetSampleLimitApply(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = base.ExecuteQueryForDataSet("GetSampleLimitApply", table, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet GetSampleLimitcode(string ProductLine)
        {
            DataSet ds = base.ExecuteQueryForDataSet("GetSampleLimitcode", ProductLine);
            return ds;
        }
        public void InsertSampleApplyLimit(Hashtable obj)
        {
            this.ExecuteInsert("InsertSampleApplyLimit", obj);
        }
      
        public void UpdateSampleApplyLimit(Hashtable ht)
        {
           this.ExecuteUpdate("updateSampleApplyLimit", ht);
          
        }
        public void InsertUserLog(Hashtable ht)
        {
            this.ExecuteInsert("InsertUserLog", ht);

        }
    }
}