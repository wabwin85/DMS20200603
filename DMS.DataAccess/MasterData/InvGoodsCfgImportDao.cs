using System;
using System.Collections.Generic;
using System.Linq;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Text;

namespace DMS.DataAccess.MasterData
{
    public class InvGoodsCfgImportDao: BaseSqlMapDao
    {
        public int DeleteInvGoodsCfgImportByUser(string obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInvGoodsCfgImportByUser", obj);
            return cnt;
        }

        public DataSet QueryInvGoodsCfgInitData(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return this.ExecuteQueryForDataSet("QueryHospitalPositionInitData", table, start, limit, out totalRowCount);

        }

        public DataSet GetInvGoodsCfgInitCheckData(Guid UserId)
        {
            return this.ExecuteQueryForDataSet("QueryInvGoodsCfgImportCheck", UserId);
        }

        public void DeleteGoodsCfg(Guid id)
        {
            this.ExecuteDelete("DelInvGoodsCfgById",id);
        }

        public int UpdateInvGoodsCfgImportValid(DataTable dt)
        { 
            int cnt = 0;
            for(int i = 0; i< dt.Rows.Count;i++)
            {
                Hashtable ht = new Hashtable();
                ht.Add("ImportUser", new Guid(dt.Rows[i]["ImportUser"].ToString()));
                ht.Add("SubCompanyName",dt.Rows[i]["SubCompanyName"].ToString());
                ht.Add("BrandName", dt.Rows[i]["BrandName"].ToString());
                ht.Add("ProductLine", dt.Rows[i]["ProductLine"].ToString());
                ht.Add("ProductNameCN", dt.Rows[i]["ProductNameCN"].ToString());
                ht.Add("Id",dt.Rows[i]["Id"].ToString());
                cnt = this.ExecuteUpdate("UpdateExistInvGoodsCfgImportStatus", ht);
            }
            return cnt;
        }

        public string InitializeInvGoodsInitImport(string importType, Guid UserId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("ImportType", importType);
            ht.Add("IsValid", IsValid);
        

            this.ExecuteInsert("GC_InitializeInvGoodsInitImport", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        public void BatchInsert(IList<InvGoodsCfgInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Id", typeof(Guid));
            dt.Columns.Add("SubCompanyName");
            dt.Columns.Add("BrandName");
            dt.Columns.Add("ProductLine");
            dt.Columns.Add("ProductNameCN");
            dt.Columns.Add("InvType");
            dt.Columns.Add("QryCFN");
            dt.Columns.Add("ImportUser", typeof(Guid));
            dt.Columns.Add("ImportDate", typeof(DateTime));
            dt.Columns.Add("ErrorMsg");
            dt.Columns.Add("IsError", typeof(bool));
            foreach(InvGoodsCfgInit data in list)
            {
                DataRow dr = dt.NewRow();
                dr["Id"] = data.Id;
                dr["SubCompanyName"] = data.SubCompanyName;
                dr["BrandName"] = data.BrandName;
                dr["ProductLine"] = data.ProductLine;
                dr["QryCFN"] = data.QryCFN;
                dr["ProductNameCN"] = data.ProductNameCN;
                dr["InvType"] = data.InvType;
                dr["ImportUser"] = data.ImportUser;
                dr["ImportDate"] = data.ImportDate;
                dr["ErrorMsg"] = data.ErrorMsg;
                dr["IsError"] = data.IsError;
                dt.Rows.Add(dr);
            }
            this.ExecuteBatchInsert("InvGoodsCfgInit", dt);
        }

        public DataSet QueryErrorData(Hashtable table, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryInvGoodsCfgImport", table, start, limit, out totalCount);
            return ds;
        }
    }
}
