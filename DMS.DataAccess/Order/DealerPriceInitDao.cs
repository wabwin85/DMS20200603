
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
    /// DealerPriceInit的Dao
    /// </summary>
    public class DealerPriceInitDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
        public DealerPriceInitDao()
            : base()
        {
        }

        #region added by bozhenfei on 20110617
        /// <summary>
        /// 根据用户删除数据
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public int DeleteByUser(Guid UserId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerPriceInitByUser", UserId);
            return cnt;
        }

        /// <summary>
        /// 根据条件查询
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public DataSet SelectByHashtable(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet list = this.ExecuteQueryForDataSet("SelectDealerPriceInitByHashtable", obj, start, limit, out totalRowCount);
            return list;
        }

        public int UpdateForEdit(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerPriceInitForEdit", obj);
            return cnt;
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerPriceInit", objKey);
            return cnt;
        }

        /// <summary>
        /// 调用存储过程
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize(string importType, Guid UserId, String Remark)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("ImportType", importType);
            ht.Add("IsValid", IsValid);
            ht.Add("Remark", Remark);

            this.ExecuteInsert("GC_DealerPriceInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        public DataSet SelectDealerPriceHeadByHashtable(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet list = this.ExecuteQueryForDataSet("SelectDealerPriceHeadByHashtable", obj, start, limit, out totalRowCount);
            return list;
        }

        public DataSet SelectDealerPriceDetailByHead(String HId, int start, int limit, out int totalRowCount)
        {
            DataSet list = this.ExecuteQueryForDataSet("SelectDealerPriceDetailByHead", HId, start, limit, out totalRowCount);
            return list;
        }

        #endregion

        /// <summary>
        /// 批量插入数据
        /// </summary>
        /// <param name="list"></param>
        public void BatchInsert(IList<Hashtable> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("DPI_ID", typeof(Guid));
            dt.Columns.Add("DPI_USER", typeof(Guid));
            dt.Columns.Add("DPI_UploadDate", typeof(DateTime));
            dt.Columns.Add("DPI_LineNbr", typeof(int));
            dt.Columns.Add("DPI_FileName");
            dt.Columns.Add("DPI_ErrorFlag", typeof(bool));
            dt.Columns.Add("DPI_ErrorDescription");
            dt.Columns.Add("DPI_LP_ID", typeof(Guid));
            dt.Columns.Add("DPI_ArticleNumber");
            dt.Columns.Add("DPI_ArticleNumber_ErrMsg");
            dt.Columns.Add("DPI_Dealer");
            dt.Columns.Add("DPI_Dealer_ErrMsg");
            dt.Columns.Add("DPI_Price");
            dt.Columns.Add("DPI_Price_ErrMsg");
            dt.Columns.Add("DPI_PriceTypeName");
            dt.Columns.Add("DPI_PriceTypeName_ErrMsg");

            foreach (Hashtable data in list)
            {
                DataRow row = dt.NewRow();
                row["DPI_ID"] = data["Id"];
                row["DPI_USER"] = data["User"];
                row["DPI_UploadDate"] = data["UploadDate"];
                row["DPI_LineNbr"] = data["LineNbr"];
                row["DPI_FileName"] = data["FileName"];
                row["DPI_ErrorFlag"] = data["ErrorFlag"];
                row["DPI_ErrorDescription"] = data["ErrorDescription"];
                row["DPI_LP_ID"] = data["LPId"];
                row["DPI_ArticleNumber"] = data["ArticleNumber"];
                row["DPI_ArticleNumber_ErrMsg"] = data["ArticleNumberErrMsg"];
                row["DPI_Dealer"] = data["Dealer"];
                row["DPI_Dealer_ErrMsg"] = data["DealerErrMsg"];
                row["DPI_Price"] = data["Price"];
                row["DPI_Price_ErrMsg"] = data["PriceErrMsg"];
                row["DPI_PriceTypeName"] = data["PriceTypeName"];
                row["DPI_PriceTypeName_ErrMsg"] = data["PriceTypeErrMsg"];

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("DealerPriceInit", dt);
        }
    }
}