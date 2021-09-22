using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper; 
using System.Data;
using Grapecity.DataAccess.Transaction;

namespace DMS.DataAccess.MasterData
{
    public class XlsImportDao : BaseSqlMapDao
    {
        public XlsImportDao() : base()
        {
        }

        
        public String XlsImportTempTable_Check1(Hashtable hashtable)
        {
            this.ExecuteUpdate("XlsImportTempTable_Check1", hashtable);
            String result = (String)hashtable["IsValid"];
            return result;
        }

        public String XlsImportTempTable_Check2(Hashtable hashtable)
        {
            this.ExecuteUpdate("XlsImportTempTable_Check2", hashtable);
            String result = (String)hashtable["IsValid"];
            return result;
        }

        public void XlsImportTempTable_Delete(Hashtable hashtable)
        {
            this.ExecuteUpdate("XlsImportTempTable_Delete", hashtable);
        }

        public void XlsImportTempTable_Insert(string TableName,DataTable dt)
        {
            this.ExecuteBatchInsert(TableName, dt);
        }

        public DataTable XlsImportTempTable_GetErrorList(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("XlsImportTempTable_GetErrorList", obj);
            totalRowCount = ds.Tables[0].Rows.Count;
            DataTable dt = ds.Tables[0].Clone();  // 复制表结构
            DataRow[] dr = ds.Tables[0].Select("row_number>=" + start.ToString() + " and row_number<" + (start + limit).ToString());
            
            foreach (DataRow row in dr)
                dt.Rows.Add(row.ItemArray);  // 将DataRow添加到DataTable中
            return dt;
        }
    }
}
