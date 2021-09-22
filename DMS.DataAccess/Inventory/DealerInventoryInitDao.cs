
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealerInventoryInit
 * Created Time: 2013/8/21 14:40:10
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
    /// DealerInventoryInit的Dao
    /// </summary>
    public class DealerInventoryInitDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public DealerInventoryInitDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerInventoryInit GetObject(Guid objKey)
        {
            DealerInventoryInit obj = this.ExecuteQueryForObject<DealerInventoryInit>("SelectDealerInventoryInit", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DealerInventoryInit> GetAll()
        {
            IList<DealerInventoryInit> list = this.ExecuteQueryForList<DealerInventoryInit>("SelectDealerInventoryInit", null);
            return list;
        }


        /// <summary>
        /// 查询DealerInventoryInit
        /// </summary>
        /// <returns>返回DealerInventoryInit集合</returns>
        public IList<DealerInventoryInit> SelectByFilter(DealerInventoryInit obj)
        {
            IList<DealerInventoryInit> list = this.ExecuteQueryForList<DealerInventoryInit>("SelectByFilterDealerInventoryInit", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerInventoryInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerInventoryInit", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerInventoryInit", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DealerInventoryInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDealerInventoryInit", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerInventoryInit obj)
        {
            this.ExecuteInsert("InsertDealerInventoryInit", obj);
        }

        public IList<DealerInventoryInit> SelectByHashtable(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            IList<DealerInventoryInit> list = this.ExecuteQueryForList<DealerInventoryInit>("SelectDealerInventoryInitByHashtable", obj, start, limit, out totalRowCount);
            return list;
        }

        public int DeleteByUser(Guid userId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerInventoryInitByUser", userId);
            return cnt;
        }

        public void BatchInsert(IList<DealerInventoryInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("DII_ID", typeof(Guid));
            dt.Columns.Add("DII_USER", typeof(Guid));
            dt.Columns.Add("DII_UploadDate", typeof(DateTime));
            dt.Columns.Add("DII_LineNbr", typeof(int));
            dt.Columns.Add("DII_FileName");
            dt.Columns.Add("DII_ErrorFlag", typeof(bool));
            dt.Columns.Add("DII_Warehouse");
            dt.Columns.Add("DII_DMA_ID", typeof(Guid));
            dt.Columns.Add("DII_LotNumber");
            dt.Columns.Add("DII_Qty");
            dt.Columns.Add("DII_ArticleNumber");
            dt.Columns.Add("DII_Warehouse_ErrMsg");
            dt.Columns.Add("DII_ArticleNumber_ErrMsg");
            dt.Columns.Add("DII_LotNumber_ErrMsg");
            dt.Columns.Add("DII_Qty_ErrMsg");
            dt.Columns.Add("DII_Period");
            dt.Columns.Add("DII_Period_ErrMsg");


            foreach (DealerInventoryInit data in list)
            {
                DataRow row = dt.NewRow();
                row["DII_ID"] = data.Id;
                row["DII_USER"] = data.User;
                row["DII_UploadDate"] = data.UploadDate;
                row["DII_LineNbr"] = data.LineNbr;
                row["DII_FileName"] = data.FileName;
                row["DII_ErrorFlag"] = data.ErrorFlag;
                row["DII_Warehouse"] = data.Warehouse;
                row["DII_DMA_ID"] = data.DmaId;
                row["DII_LotNumber"] = data.LotNumber;
                row["DII_Qty"] = data.Qty;
                row["DII_ArticleNumber"] = data.ArticleNumber;
                row["DII_Warehouse_ErrMsg"] = data.WarehouseErrMsg;
                row["DII_ArticleNumber_ErrMsg"] = data.ArticleNumberErrMsg;
                row["DII_LotNumber_ErrMsg"] = data.LotNumberErrMsg;
                row["DII_Qty_ErrMsg"] = data.QtyErrMsg;
                row["DII_Period"] = data.Period;
                row["DII_Period_ErrMsg"] = data.PeriodErrMsg;

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("DealerInventoryInit", dt);
        }

        /// <summary>
        /// 调用存储过程
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string InitializeDII(Guid UserId, int IsImport, Guid SubCompanyId, Guid BrandId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("IsImport", IsImport);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_DealerInventoryInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        public void UpdateDII(DealerInventoryInit obj)
        {
            this.ExecuteUpdate("UpdateDealerInveInit", obj);
        }
    }
}