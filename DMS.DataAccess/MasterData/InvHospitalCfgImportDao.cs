using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using DMS.Model;

namespace DMS.DataAccess.MasterData
{
    public class InvHospitalCfgImportDao: BaseSqlMapDao
    {
        public int DeleteHospitalCfgImportByUser(string obj)
        {
            int cnt = (int)this.ExecuteDelete("DelInvHospitalCfgInitByUserId", obj);
            return cnt;
        } 

        public DataSet GetInvHospitalCfgInitCheckData(Guid UserId)
        {
            return this.ExecuteQueryForDataSet("QueryInvHospitalCfgImportCheck", UserId);
        }

        public void DeleteInvHospitalCfg(Guid id)
        {
            this.ExecuteDelete("DeleteInvHospitalCfg", id);
        }

        public int UpdateInvHospitalCfgImportValid(DataTable dt)
        {
            int cnt = 0;
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                Hashtable ht = new Hashtable();
                ht.Add("ImportUser", new Guid(dt.Rows[i]["ImportUser"].ToString())); 
                ht.Add("Id", dt.Rows[i]["Id"].ToString());
                cnt = this.ExecuteUpdate("UpdateExistInvHospitalCfgImportStatus", ht);
            }
            return cnt;
        }

        public string InitializeInvHospitalInitImport(string importType, Guid UserId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("ImportType", importType);
            ht.Add("IsValid", IsValid);


            this.ExecuteInsert("GC_InitializeInvHospitalInitImport", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }
        public void BatchInsert(IList<InvHospitalCfgInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Id", typeof(Guid)); 
            dt.Columns.Add("DMSHospitalName");
            dt.Columns.Add("InvHospitalName");
            dt.Columns.Add("Hos_Code");
            dt.Columns.Add("Hos_SFECode");
            dt.Columns.Add("Hos_Province");
            dt.Columns.Add("Hos_City");
            dt.Columns.Add("Hos_District");

            dt.Columns.Add("ImportUser", typeof(Guid));
            dt.Columns.Add("ImportDate", typeof(DateTime));
            dt.Columns.Add("ErrorMsg");
            dt.Columns.Add("IsError", typeof(bool));
            foreach (InvHospitalCfgInit data in list)
            {
                DataRow dr = dt.NewRow();
                dr["Id"] = data.Id; 
                dr["DMSHospitalName"] = data.DMSHospitalName;
                dr["InvHospitalName"] = data.InvHospitalName;
                dr["Hos_Code"] = data.Hos_Code;
                dr["Hos_SFECode"] = data.Hos_SFECode;
                dr["Hos_Province"] = data.Province;
                dr["Hos_City"] = data.City;
                dr["Hos_District"] = data.District;

                dr["ImportUser"] = data.ImportUser;
                dr["ImportDate"] = data.ImportDate;
                dr["ErrorMsg"] = data.ErrorMsg;
                dr["IsError"] = data.IsError;
                dt.Rows.Add(dr);
            }
            this.ExecuteBatchInsert("InvHospitalCfgInit", dt);
        }

        public DataSet QueryErrorData(Hashtable table, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryInvHospitalCfgImport", table, start, limit, out totalCount);
            return ds;
        }
    }
}
