using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.DataAccess
{
    using DMS.Model;
    using System.Data;
    public class HospitalPositionInitDao : BaseSqlMapDao
    {
        #region 上传用户入职信息和核算指标时间        
        public int DeleteHospitalPositionInitByUser(Guid UserId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteHospitalPositionInitByUser", UserId);

            return cnt;
        }
        public void BatchHospitalPositionInitInsert(IList<HospitalPositionInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Id", typeof(Guid));
            dt.Columns.Add("HospitalCode");       
            dt.Columns.Add("IsError", typeof(bool));
            dt.Columns.Add("ErrorMsg");
            dt.Columns.Add("LineNbr", typeof(int));
            dt.Columns.Add("ImportUser", typeof(Guid));
            dt.Columns.Add("ImportDate", typeof(DateTime));

            foreach (HospitalPositionInit data in list)
            {
                DataRow row = dt.NewRow();
                row["Id"] = data.Id;
                row["HospitalCode"] = data.HospitalCode;           
                row["IsError"] = data.IsError;
                row["ErrorMsg"] = data.ErrorMsg;
                row["LineNbr"] = data.LineNbr;
                row["ImportUser"] = data.ImportUser;
                row["ImportDate"] = data.ImportDate;

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("HospitalPositionInit", dt);
        }

        public void HospitalPositionInitVerify(Guid UserId, int IsImport, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("IsImport", IsImport);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_HospitalPositionInitVerify", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
        public DataSet QueryHospitalPositionInitData(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return this.ExecuteQueryForDataSet("QueryHospitalPositionInitData", table, start, limit, out totalRowCount);
        }
        #endregion
    }
}
