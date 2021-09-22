using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.DataAccess.MasterDatas
{
    public class MasterDatasDao : BaseSqlMapDao
    {
        public MasterDatasDao()
         : base()
        {
        }
        public DataTable SelectMasterDatasList(string Calender)
        {

            if (Calender != null)
            {
                DateTime dt = DateTime.Parse(Calender);
                string yy = dt.Year.ToString();
                string mm = dt.Month.ToString();
                if (mm != "10" && mm != "11" && mm != "12")
                {
                    mm = "0" + mm;
                }
                Calender = yy + mm;
            }
            DataTable ds = this.ExecuteQueryForDataSet("SelectMasterDatasList", Calender).Tables[0];
            return ds;
        }
        public DataTable SelectMasterDatasInfo(string Year)
        {
            DataTable ds = this.ExecuteQueryForDataSet("SelectMasterDatasInfo", Year).Tables[0];
            return ds;
        }
        public DataTable SelectMasterDatasInfoUpdate(string QryApplyDate)
        {
            DateTime dt = DateTime.Parse(QryApplyDate);
            string yy = dt.Year.ToString();
            string mm = dt.Month.ToString();
            if (mm != "10" && mm != "11" && mm != "12")
            {
                mm = "0" + mm;
            }
            QryApplyDate = yy + mm;
            DataTable ds = this.ExecuteQueryForDataSet("SelectMasterDatasInfoUpdate", QryApplyDate).Tables[0];
            return ds;
        }
        public void InsertMasterDatas(bool IsFlag, string StartDate)
        {
            Hashtable hashtable = new Hashtable();
            DateTime dt = DateTime.Parse(StartDate);
            string yy = dt.Year.ToString();
            string mm = dt.Month.ToString();
            string dd = dt.Day.ToString();
            int? flag = null;
            if (IsFlag == false)
            {
                hashtable.Add("flag", flag = 0);
            }
            else
            {
                hashtable.Add("flag", flag = 1);
            }
            if (mm != "10" && mm != "11" && mm != "12")
            {
                mm = "0" + mm;
            }
            hashtable.Add("Calendar", yy + mm);
            hashtable.Add("Day", dd);
            this.ExecuteInsert("InsertMasterDatas", hashtable);
        }
        public void UpdateMasterDatas(bool IsFlag, string StartDate)
        {
            Hashtable hashtable = new Hashtable();
            DateTime dt = DateTime.Parse(StartDate);
            string yy = dt.Year.ToString();
            string mm = dt.Month.ToString();
            string dd = dt.Day.ToString();
            int? flag = null;
            if (IsFlag == false)
            {
                hashtable.Add("flag", flag = 0);
            }
            else
            {
                hashtable.Add("flag", flag = 1);
            }
            if (mm != "10" && mm != "11" && mm != "12")
            {
                mm = "0" + mm;
            }
            hashtable.Add("Calendar", yy + mm);
            hashtable.Add("Day", dd);
            this.ExecuteUpdate("UpdateMasterDatas", hashtable);
        }
        public void InsertCalendarDateLog(string UserId, string StartDate, string operation)
        {
            Hashtable hashtable = new Hashtable();

            DateTime dt = DateTime.Parse(StartDate);
            string yy = dt.Year.ToString();
            string mm = dt.Month.ToString();
            if (mm != "10" && mm != "11" && mm != "12")
            {
                mm = "0" + mm;
            }
            hashtable.Add("Calendar", yy + mm);
            hashtable.Add("operation", operation);
            hashtable.Add("UserId", UserId);
          //  hashtable.Add("CreateDate", DateTime.Now);
            this.ExecuteInsert("InsertCalendarDateLog", hashtable);
        }

    }
}
