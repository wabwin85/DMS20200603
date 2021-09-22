
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : TransferInit
 * Created Time: 2013/12/21 10:40:28
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
    /// TransferInit的Dao
    /// </summary>
    public class TransferInitDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public TransferInitDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public TransferInit GetObject(Guid objKey)
        {
            TransferInit obj = this.ExecuteQueryForObject<TransferInit>("SelectTransferInit", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<TransferInit> GetAll()
        {
            IList<TransferInit> list = this.ExecuteQueryForList<TransferInit>("SelectTransferInit", null);
            return list;
        }


        /// <summary>
        /// 查询TransferInit
        /// </summary>
        /// <returns>返回TransferInit集合</returns>
		public IList<TransferInit> SelectByFilter(TransferInit obj)
        {
            IList<TransferInit> list = this.ExecuteQueryForList<TransferInit>("SelectByFilterTransferInit", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(TransferInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTransferInit", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTransferInit", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(TransferInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteTransferInit", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(TransferInit obj)
        {
            this.ExecuteInsert("InsertTransferInit", obj);
        }

        /// <summary>
        /// 根据用户删除数据
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public int DeleteByUser(Guid UserId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTransferInitByUser", UserId);
            return cnt;
        }

        /// <summary>
        /// 根据条件查询
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public IList<TransferInit> SelectByHashtable(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            IList<TransferInit> list = this.ExecuteQueryForList<TransferInit>("SelectTransferInitByHashtable", obj, start, limit, out totalRowCount);
            return list;
        }

        /// <summary>
        /// 调用存储过程
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize(string importType, Guid UserId, string SubCompanyId, string BrandId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("ImportType", importType);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_TransferInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        /// 批量插入数据
        /// </summary>
        /// <param name="list"></param>
        public void BatchInsert(IList<TransferInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("TRI_ID", typeof(Guid));
            dt.Columns.Add("TRI_USER", typeof(Guid));
            dt.Columns.Add("TRI_UploadDate", typeof(DateTime));
            dt.Columns.Add("TRI_LineNbr", typeof(int));
            dt.Columns.Add("TRI_FileName");
            dt.Columns.Add("TRI_ErrorFlag", typeof(bool));
            dt.Columns.Add("TRI_ErrorDescription");
            dt.Columns.Add("TRI_ArticleNumber");
            dt.Columns.Add("TRI_TransferQty");
            dt.Columns.Add("TRI_LotNumber");
            dt.Columns.Add("TRI_WarehouseFrom");
            dt.Columns.Add("TRI_WarehouseTo");
            dt.Columns.Add("TRI_DMA_ID", typeof(Guid));
            dt.Columns.Add("TRI_ArticleNumber_ErrMsg");
            dt.Columns.Add("TRI_TransferQty_ErrMsg");
            dt.Columns.Add("TRI_LotNumber_ErrMsg");
            dt.Columns.Add("TRI_WarehouseFrom_ErrMsg");
            dt.Columns.Add("TRI_WarehouseTo_ErrMsg");

            foreach (TransferInit data in list)
            {
                DataRow row = dt.NewRow();
                row["TRI_ID"] = data.Id;
                row["TRI_USER"] = data.User;
                row["TRI_UploadDate"] = data.UploadDate;
                row["TRI_LineNbr"] = data.LineNbr;
                row["TRI_FileName"] = data.FileName;
                row["TRI_ErrorFlag"] = data.ErrorFlag;
                row["TRI_ErrorDescription"] = data.ErrorDescription;
                row["TRI_WarehouseFrom"] = data.WarehouseFrom;
                row["TRI_WarehouseTo"] = data.WarehouseTo;
                row["TRI_ArticleNumber"] = data.ArticleNumber;
                row["TRI_TransferQty"] = data.TransferQty;
                row["TRI_LotNumber"] = data.LotNumber;
                row["TRI_DMA_ID"] = data.DmaId.Value;
                row["TRI_WarehouseFrom_ErrMsg"] = data.WarehouseFromErrMsg;
                row["TRI_WarehouseTo_ErrMsg"] = data.WarehouseToErrMsg;
                row["TRI_ArticleNumber_ErrMsg"] = data.ArticleNumberErrMsg;
                row["TRI_TransferQty_ErrMsg"] = data.TransferQtyErrMsg;
                row["TRI_LotNumber_ErrMsg"] = data.LotNumberErrMsg;

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("TransferInit", dt);
        }

        public int UpdateForEdit(TransferInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTransferInitForEdit", obj);
            return cnt;
        }
    }
}