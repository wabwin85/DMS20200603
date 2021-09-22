
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : BatchOrderInit
 * Created Time: 2017/3/23 10:37:44
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
    /// BatchOrderInit的Dao
    /// </summary>
    public class BatchOrderInitDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public BatchOrderInitDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public BatchOrderInit GetObject(Guid objKey)
        {
            BatchOrderInit obj = this.ExecuteQueryForObject<BatchOrderInit>("SelectBatchOrderInit", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<BatchOrderInit> GetAll()
        {
            IList<BatchOrderInit> list = this.ExecuteQueryForList<BatchOrderInit>("SelectBatchOrderInit", null);
            return list;
        }


        /// <summary>
        /// 查询BatchOrderInit
        /// </summary>
        /// <returns>返回BatchOrderInit集合</returns>
		public IList<BatchOrderInit> SelectByFilter(BatchOrderInit obj)
        {
            IList<BatchOrderInit> list = this.ExecuteQueryForList<BatchOrderInit>("SelectByFilterBatchOrderInit", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(BatchOrderInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateBatchOrderInit", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteBatchOrderInit", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(BatchOrderInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteBatchOrderInit", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(BatchOrderInit obj)
        {
            this.ExecuteInsert("InsertBatchOrderInit", obj);
        }

        public int DeleteByUser(Guid UserId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteBatchOrderInitByUser", UserId);
            return cnt;
        }


        public void Insert(PurchaseOrderInit obj)
        {
            this.ExecuteInsert("InsertPurchaseOrderInit", obj);
        }


        public void BatchOrderInsert(IList<BatchOrderInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("BOI_ID");
            dt.Columns.Add("BOI_USER");
            dt.Columns.Add("BOI_UploadDate", typeof(DateTime));
            dt.Columns.Add("BOI_LineNbr");
            dt.Columns.Add("BOI_FileName");
            dt.Columns.Add("BOI_ErrorFlag");
            dt.Columns.Add("BOI_ErrorDescription");
            dt.Columns.Add("BOI_POH_ID");
            dt.Columns.Add("BOI_POD_ID");
            dt.Columns.Add("BOI_OrderType");
            dt.Columns.Add("BOI_ArticleNumber");
            dt.Columns.Add("BOI_RequiredQty");
            dt.Columns.Add("BOI_LotNumber");
            dt.Columns.Add("BOI_SAP_Code");
            dt.Columns.Add("BOI_DMA_ID");
            dt.Columns.Add("BOI_CFN_ID");
            dt.Columns.Add("BOI_BUM_ID");
            dt.Columns.Add("BOI_TerritoryCode");
            dt.Columns.Add("BOI_Warehouse");
            dt.Columns.Add("BOI_WHM_ID");
            dt.Columns.Add("BOI_OrderTypeName");
            dt.Columns.Add("BOI_SAP_Code_ErrMsg");
            dt.Columns.Add("BOI_OrderType_ErrMsg");
            dt.Columns.Add("BOI_ArticleNumber_ErrMsg");
            dt.Columns.Add("BOI_RequiredQty_ErrMsg");
            dt.Columns.Add("BOI_LotNumber_ErrMsg");
            dt.Columns.Add("BOI_Amount");
            dt.Columns.Add("BOI_Amount_ErrMsg");
            dt.Columns.Add("BOI_ProductLine");
            dt.Columns.Add("BOI_ProductLine_ErrMsg");

            foreach (BatchOrderInit data in list)
            {
                DataRow row = dt.NewRow();

                row["BOI_ID"] = data.Id;
                row["BOI_USER"] = data.User;
                row["BOI_UploadDate"]=data.UploadDate;
                row["BOI_LineNbr"] = data.LineNbr;
                row["BOI_FileName"] = data.FileName;
                row["BOI_ErrorFlag"] = data.ErrorFlag;
                row["BOI_ErrorDescription"]=data.ErrorDescription;
                row["BOI_POH_ID"] = data.PohId;
                row["BOI_POD_ID"] = data.PodId;
                row["BOI_OrderType"]=data.OrderType;
                row["BOI_ArticleNumber"]=data.ArticleNumber;
                row["BOI_RequiredQty"]=data.RequiredQty;
                row["BOI_LotNumber"]=data.LotNumber;
                row["BOI_SAP_Code"] = data.SapCode;
                row["BOI_DMA_ID"]=data.DmaId;
                row["BOI_CFN_ID"]=data.CfnId;
                row["BOI_BUM_ID"]=data.BumId;
                row["BOI_TerritoryCode"]=data.TerritoryCode;
                row["BOI_Warehouse"]=data.Warehouse;
                row["BOI_WHM_ID"]=data.WhmId;
                row["BOI_OrderTypeName"]=data.OrderTypeName;
                row["BOI_SAP_Code_ErrMsg"]=data.SapCodeErrMsg;
                row["BOI_OrderType_ErrMsg"]=data.OrderTypeErrMsg;
                row["BOI_ArticleNumber_ErrMsg"]=data.ArticleNumberErrMsg;
                row["BOI_RequiredQty_ErrMsg"]=data.RequiredQtyErrMsg;
                row["BOI_LotNumber_ErrMsg"] = data.LotNumberErrMsg ;
                row["BOI_Amount"]=data.Amount;
                row["BOI_Amount_ErrMsg"]=data.AmountErrMsg;
                row["BOI_ProductLine"]=data.ProductLine;
                row["BOI_ProductLine_ErrMsg"]=data.ProductLineErrMsg;

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("BatchOrderInit", dt);
        }


        public DataSet SelectByHashtable(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectBatchOrderInitByHashtable", obj, start, limit, out totalRowCount);
            return ds;
        }


        public string Initialize(string importType, Guid UserId, string SubCompanyId, string BrandId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("ImportType", importType);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_BatchOrderInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }




    }
}