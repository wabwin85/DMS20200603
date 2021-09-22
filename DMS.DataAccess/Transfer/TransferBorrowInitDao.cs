
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : TransferBorrowInit
 * Created Time: 2019/11/12 20:31:22
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
    /// TransferBorrowInit的Dao
    /// </summary>
    public class TransferBorrowInitDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public TransferBorrowInitDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public TransferBorrowInit GetObject(Guid objKey)
        {
            TransferBorrowInit obj = this.ExecuteQueryForObject<TransferBorrowInit>("SelectTransferBorrowInit", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<TransferBorrowInit> GetAll()
        {
            IList<TransferBorrowInit> list = this.ExecuteQueryForList<TransferBorrowInit>("SelectTransferBorrowInit", null);
            return list;
        }


        /// <summary>
        /// 查询TransferBorrowInit
        /// </summary>
        /// <returns>返回TransferBorrowInit集合</returns>
		public IList<TransferBorrowInit> SelectByFilter(TransferBorrowInit obj)
        {
            IList<TransferBorrowInit> list = this.ExecuteQueryForList<TransferBorrowInit>("SelectByFilterTransferBorrowInit", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(TransferBorrowInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTransferBorrowInit", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTransferBorrowInit", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(TransferBorrowInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteTransferBorrowInit", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(TransferBorrowInit obj)
        {
            this.ExecuteInsert("InsertTransferBorrowInit", obj);
        }

        /// <summary>
        /// 根据用户删除数据
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public int DeleteByUser(Guid UserId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTransferBorrowInitByUser", UserId);
            return cnt;
        }

        /// <summary>
        /// 根据条件查询
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public IList<TransferBorrowInit> SelectByHashtable(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            IList<TransferBorrowInit> list = this.ExecuteQueryForList<TransferBorrowInit>("SelectTransferBorrowInitByHashtable", obj, start, limit, out totalRowCount);
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

            this.ExecuteInsert("GC_TransferBorrowListInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        /// 批量插入数据
        /// </summary>
        /// <param name="list"></param>
        public void BatchInsert(IList<TransferBorrowInit> list)
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
            dt.Columns.Add("TRI_DealerFrom");//
            dt.Columns.Add("TRI_DealerTo");
            dt.Columns.Add("TRI_DMA_ID", typeof(Guid));
            dt.Columns.Add("TRI_ArticleNumber_ErrMsg");
            dt.Columns.Add("TRI_TransferQty_ErrMsg");
            dt.Columns.Add("TRI_LotNumber_ErrMsg");
            dt.Columns.Add("TRI_WarehouseFrom_ErrMsg");
            dt.Columns.Add("TRI_WarehouseTo_ErrMsg");
            dt.Columns.Add("TRI_DealerFrom_ErrMsg");//
            dt.Columns.Add("TRI_DealerTo_ErrMsg");

            foreach (TransferBorrowInit data in list)
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
                row["TRI_DealerFrom"] = data.DealerFrom;//
                row["TRI_DealerTo"] = data.DealerTo;
                row["TRI_ArticleNumber"] = data.ArticleNumber;
                row["TRI_TransferQty"] = data.TransferQty;
                row["TRI_LotNumber"] = data.LotNumber;
                row["TRI_DMA_ID"] = data.DmaId.Value;
                row["TRI_WarehouseFrom_ErrMsg"] = data.WarehouseFromErrMsg;
                row["TRI_WarehouseTo_ErrMsg"] = data.WarehouseToErrMsg;
                row["TRI_DealerFrom_ErrMsg"] = data.DealerFromErrMsg;//
                row["TRI_DealerTo_ErrMsg"] = data.DealerToErrMsg;
                row["TRI_ArticleNumber_ErrMsg"] = data.ArticleNumberErrMsg;
                row["TRI_TransferQty_ErrMsg"] = data.TransferQtyErrMsg;
                row["TRI_LotNumber_ErrMsg"] = data.LotNumberErrMsg;

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("TransferBorrowInit", dt);
        }

        public int UpdateForEdit(TransferBorrowInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTransferBorrowInitForEdit", obj);
            return cnt;
        }

    }
}