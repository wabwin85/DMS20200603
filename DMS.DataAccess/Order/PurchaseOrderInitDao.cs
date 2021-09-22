
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : PurchaseOrderInit
 * Created Time: 2011-6-17 16:47:42
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
    /// PurchaseOrderInit的Dao
    /// </summary>
    public class PurchaseOrderInitDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public PurchaseOrderInitDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public PurchaseOrderInit GetObject(Guid objKey)
        {
            PurchaseOrderInit obj = this.ExecuteQueryForObject<PurchaseOrderInit>("SelectPurchaseOrderInit", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<PurchaseOrderInit> GetAll()
        {
            IList<PurchaseOrderInit> list = this.ExecuteQueryForList<PurchaseOrderInit>("SelectPurchaseOrderInit", null);
            return list;
        }


        /// <summary>
        /// 查询PurchaseOrderInit
        /// </summary>
        /// <returns>返回PurchaseOrderInit集合</returns>
		public IList<PurchaseOrderInit> SelectByFilter(PurchaseOrderInit obj)
        {
            IList<PurchaseOrderInit> list = this.ExecuteQueryForList<PurchaseOrderInit>("SelectByFilterPurchaseOrderInit", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(PurchaseOrderInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePurchaseOrderInit", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeletePurchaseOrderInit", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(PurchaseOrderInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeletePurchaseOrderInit", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(PurchaseOrderInit obj)
        {
            this.ExecuteInsert("InsertPurchaseOrderInit", obj);
        }

        #region added by bozhenfei on 20110617
        /// <summary>
        /// 根据用户删除数据
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public int DeleteByUser(Guid UserId)
        {
            int cnt = (int)this.ExecuteDelete("DeletePurchaseOrderInitByUser", UserId);
            return cnt;
        }

        /// <summary>
        /// 根据条件查询
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public IList<PurchaseOrderInit> SelectByHashtable(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            IList<PurchaseOrderInit> list = this.ExecuteQueryForList<PurchaseOrderInit>("SelectPurchaseOrderInitByHashtable", obj, start, limit, out totalRowCount);
            return list;
        }

        /// <summary>
        /// 调用存储过程
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize(string importType, Guid UserId, string SubCompanyId,string BrandId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("ImportType", importType);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_PurchaseOrderInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }
        #endregion

        /// <summary>
        /// 批量插入数据
        /// </summary>
        /// <param name="list"></param>
        public void BatchInsert(IList<PurchaseOrderInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("POI_ID", typeof(Guid));
            dt.Columns.Add("POI_USER", typeof(Guid));
            dt.Columns.Add("POI_UploadDate", typeof(DateTime));
            dt.Columns.Add("POI_LineNbr", typeof(int));
            dt.Columns.Add("POI_FileName");
            dt.Columns.Add("POI_ErrorFlag", typeof(bool));
            dt.Columns.Add("POI_ErrorDescription");
            dt.Columns.Add("POI_OrderType");
            dt.Columns.Add("POI_ArticleNumber");
            dt.Columns.Add("POI_RequiredQty");
            dt.Columns.Add("POI_LotNumber");
            dt.Columns.Add("POI_DMA_ID", typeof(Guid));
            dt.Columns.Add("POI_OrderType_ErrMsg");
            dt.Columns.Add("POI_ArticleNumber_ErrMsg");
            dt.Columns.Add("POI_RequiredQty_ErrMsg");
            dt.Columns.Add("POI_LotNumber_ErrMsg");
            dt.Columns.Add("POI_Amount");
            dt.Columns.Add("POI_Amount_ErrMsg");
            dt.Columns.Add("POI_ProductLine");
            dt.Columns.Add("POI_ProductLine_ErrMsg");
            dt.Columns.Add("POI_PointType");
            dt.Columns.Add("POI_PointType_ErrMsg");


            foreach (PurchaseOrderInit data in list)
            {
                DataRow row = dt.NewRow();
                row["POI_ID"] = data.Id;
                row["POI_USER"] = data.User;
                row["POI_UploadDate"] = data.UploadDate;
                row["POI_LineNbr"] = data.LineNbr;
                row["POI_FileName"] = data.FileName;
                row["POI_ErrorFlag"] = data.ErrorFlag;
                row["POI_ErrorDescription"] = data.ErrorDescription;
                row["POI_OrderType"] = data.OrderType;
                row["POI_ArticleNumber"] = data.ArticleNumber;
                row["POI_RequiredQty"] = data.RequiredQty;
                row["POI_LotNumber"] = data.LotNumber;
                row["POI_DMA_ID"] = data.DmaId.Value;
                row["POI_OrderType_ErrMsg"] = data.OrderTypeErrMsg;
                row["POI_ArticleNumber_ErrMsg"] = data.ArticleNumberErrMsg;
                row["POI_RequiredQty_ErrMsg"] = data.RequiredQtyErrMsg;
                row["POI_LotNumber_ErrMsg"] = data.LotNumberErrMsg;
                row["POI_Amount"] = data.Amount;
                row["POI_Amount_ErrMsg"] = data.AmountErrMsg;
                row["POI_ProductLine"] = data.ProductLine;
                row["POI_ProductLine_ErrMsg"] = data.ProductLineErrMsg;
                row["POI_PointType"] = data.PointType;
                row["POI_PointType_ErrMsg"] = data.PointTypeErrMsg;
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("PurchaseOrderInit", dt);
        }

        public int UpdateForEdit(PurchaseOrderInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePurchaseOrderInitForEdit", obj);
            return cnt;
        }
    }
}