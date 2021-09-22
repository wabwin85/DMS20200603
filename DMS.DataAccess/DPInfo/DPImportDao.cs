
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : SignRelation
 * Created Time: 2015/7/31 10:50:03
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
    /// BscUser的Dao
    /// </summary>
    public class DPImportDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public DPImportDao()
            : base()
        {
        }

        #region Pay

        public int DeleteDPPayImportByUser(String userId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDPPayImportByUser", userId);
            return cnt;
        }

        public void BatchInsertDPPayImport(IList<Hashtable> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ImportUser", typeof(Guid));
            dt.Columns.Add("ImportTime", typeof(DateTime));
            dt.Columns.Add("LineNum", typeof(int));
            dt.Columns.Add("ErrorFlag", typeof(bool));
            dt.Columns.Add("ErrorDesc");
            dt.Columns.Add("DealerCode");
            dt.Columns.Add("DealerId", typeof(Guid));
            dt.Columns.Add("PayCredit");
            dt.Columns.Add("PayCycle");
            dt.Columns.Add("PayContact");
            dt.Columns.Add("PayDealerType");
            dt.Columns.Add("PayAmount");
            dt.Columns.Add("PayIn");
            dt.Columns.Add("Pay0");
            dt.Columns.Add("Pay31");
            dt.Columns.Add("Pay61");
            dt.Columns.Add("Pay91");
            dt.Columns.Add("Pay181");
            dt.Columns.Add("Pay361");

            foreach (Hashtable data in list)
            {
                DataRow row = dt.NewRow();
                row["ImportUser"] = data["ImportUser"];
                row["ImportTime"] = data["ImportTime"];
                row["LineNum"] = data["LineNum"];
                row["ErrorFlag"] = data["ErrorFlag"];
                row["ErrorDesc"] = data["ErrorDesc"];
                row["DealerCode"] = data["DealerCode"];
                row["DealerId"] = data["DealerId"];
                row["PayCredit"] = data["PayCredit"];
                row["PayCycle"] = data["PayCycle"];
                row["PayContact"] = data["PayContact"];
                row["PayDealerType"] = data["PayDealerType"];
                row["PayAmount"] = data["PayAmount"];
                row["PayIn"] = data["PayIn"];
                row["Pay0"] = data["Pay0"];
                row["Pay31"] = data["Pay31"];
                row["Pay61"] = data["Pay61"];
                row["Pay91"] = data["Pay91"];
                row["Pay181"] = data["Pay181"];
                row["Pay361"] = data["Pay361"];

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("DP.DPPayImport", dt);
        }

        public string ProcImportDPPay(Guid userId, String version)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", userId);
            ht.Add("Version", version);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("ProcImportDPPay", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        public DataSet SelectImportDPPayByCondition(Hashtable condition, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectImportDPPayByCondition", condition, start, limit, out totalCount);
            return ds;
        }

        #endregion

        #region Audit

        public string ProcImportDPAudit(Guid userId, String importType)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", userId);
            ht.Add("ImportType", importType);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("ProcImportDPAudit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        #endregion

        #region Train

        public int DeleteDPTrainImportByUser(String userId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDPTrainImportByUser", userId);
            return cnt;
        }

        public void BatchInsertDPTrainImport(IList<Hashtable> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ImportUser", typeof(Guid));
            dt.Columns.Add("ImportTime", typeof(DateTime));
            dt.Columns.Add("LineNum", typeof(int));
            dt.Columns.Add("ErrorFlag", typeof(bool));
            dt.Columns.Add("ErrorDesc");
            dt.Columns.Add("DealerCode");
            dt.Columns.Add("DealerId", typeof(Guid));
            dt.Columns.Add("TrainDate");
            dt.Columns.Add("TrainTime");
            dt.Columns.Add("TrainDuration");
            dt.Columns.Add("TrainType");
            dt.Columns.Add("TrainOrg");
            dt.Columns.Add("TrainProject");
            dt.Columns.Add("TrainFunction");
            dt.Columns.Add("TrainContent");
            dt.Columns.Add("TrainTeacher");
            dt.Columns.Add("TrainSales");
            dt.Columns.Add("TrainPosition");
            dt.Columns.Add("TrainPhone");
            dt.Columns.Add("TrainHospCode");
            dt.Columns.Add("TrainHospName");

            foreach (Hashtable data in list)
            {
                DataRow row = dt.NewRow();
                row["ImportUser"] = data["ImportUser"];
                row["ImportTime"] = data["ImportTime"];
                row["LineNum"] = data["LineNum"];
                row["ErrorFlag"] = data["ErrorFlag"];
                row["ErrorDesc"] = data["ErrorDesc"];
                row["DealerCode"] = data["DealerCode"];
                row["DealerId"] = data["DealerId"];
                row["TrainDate"] = data["TrainDate"];
                row["TrainTime"] = data["TrainTime"];
                row["TrainDuration"] = data["TrainDuration"];
                row["TrainType"] = data["TrainType"];
                row["TrainOrg"] = data["TrainOrg"];
                row["TrainProject"] = data["TrainProject"];
                row["TrainFunction"] = data["TrainFunction"];
                row["TrainContent"] = data["TrainContent"];
                row["TrainTeacher"] = data["TrainTeacher"];
                row["TrainSales"] = data["TrainSales"];
                row["TrainPosition"] = data["TrainPosition"];
                row["TrainPhone"] = data["TrainPhone"];
                row["TrainHospCode"] = data["TrainHospCode"];
                row["TrainHospName"] = data["TrainHospName"];

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("DP.DPTrainImport", dt);
        }

        public string ProcImportDPTrain(Guid userId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", userId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("ProcImportDPTrain", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        public DataSet SelectImportDPTrainByCondition(Hashtable condition, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectImportDPTrainByCondition", condition, start, limit, out totalCount);
            return ds;
        }

        #endregion

        #region Prize

        public int DeleteDPPrizeImportByUser(String userId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDPPrizeImportByUser", userId);
            return cnt;
        }

        public void BatchInsertDPPrizeImport(IList<Hashtable> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ImportUser", typeof(Guid));
            dt.Columns.Add("ImportTime", typeof(DateTime));
            dt.Columns.Add("LineNum", typeof(int));
            dt.Columns.Add("ErrorFlag", typeof(bool));
            dt.Columns.Add("ErrorDesc");
            dt.Columns.Add("DealerCode");
            dt.Columns.Add("DealerId", typeof(Guid));
            dt.Columns.Add("PrizeName");
            dt.Columns.Add("PrizeYear");
            dt.Columns.Add("PrizeLevel");
            dt.Columns.Add("PrizeReason");

            foreach (Hashtable data in list)
            {
                DataRow row = dt.NewRow();
                row["ImportUser"] = data["ImportUser"];
                row["ImportTime"] = data["ImportTime"];
                row["LineNum"] = data["LineNum"];
                row["ErrorFlag"] = data["ErrorFlag"];
                row["ErrorDesc"] = data["ErrorDesc"];
                row["DealerCode"] = data["DealerCode"];
                row["DealerId"] = data["DealerId"];
                row["PrizeName"] = data["PrizeName"];
                row["PrizeYear"] = data["PrizeYear"];
                row["PrizeLevel"] = data["PrizeLevel"];
                row["PrizeReason"] = data["PrizeReason"];

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("DP.DPPrizeImport", dt);
        }

        public string ProcImportDPPrize(Guid userId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", userId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("ProcImportDPPrize", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        public DataSet SelectImportDPPrizeByCondition(Hashtable condition, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectImportDPPrizeByCondition", condition, start, limit, out totalCount);
            return ds;
        }

        #endregion

        #region Satisfy

        public int DeleteDPSatisfyImportByUser(String userId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDPSatisfyImportByUser", userId);
            return cnt;
        }

        public void BatchInsertDPSatisfyImport(IList<Hashtable> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ImportUser", typeof(Guid));
            dt.Columns.Add("ImportTime", typeof(DateTime));
            dt.Columns.Add("LineNum", typeof(int));
            dt.Columns.Add("ErrorFlag", typeof(bool));
            dt.Columns.Add("ErrorDesc");
            dt.Columns.Add("DealerCode");
            dt.Columns.Add("DealerId", typeof(Guid));
            dt.Columns.Add("ProductLine");
            dt.Columns.Add("Question1");
            dt.Columns.Add("QuestionComment1");
            dt.Columns.Add("Question2");
            dt.Columns.Add("QuestionComment2");
            dt.Columns.Add("Question3");
            dt.Columns.Add("QuestionComment3");
            dt.Columns.Add("Question4");
            dt.Columns.Add("QuestionComment4");
            dt.Columns.Add("Question5");
            dt.Columns.Add("QuestionComment5");
            dt.Columns.Add("Question6");
            dt.Columns.Add("QuestionComment6");
            dt.Columns.Add("Question7");
            dt.Columns.Add("QuestionComment7");
            dt.Columns.Add("Question8");
            dt.Columns.Add("QuestionComment8");
            dt.Columns.Add("Question9");
            dt.Columns.Add("QuestionComment9");
            dt.Columns.Add("Question10");
            dt.Columns.Add("QuestionComment10");
            dt.Columns.Add("Question11");
            dt.Columns.Add("QuestionComment11");
            dt.Columns.Add("Question12");
            dt.Columns.Add("QuestionComment12");
            dt.Columns.Add("Question13");
            dt.Columns.Add("QuestionComment13");
            dt.Columns.Add("Question14");
            dt.Columns.Add("QuestionComment14");
            dt.Columns.Add("Question15");
            dt.Columns.Add("QuestionComment15");
            dt.Columns.Add("Question16");
            dt.Columns.Add("QuestionComment16");
            dt.Columns.Add("Question17");
            dt.Columns.Add("QuestionComment17");
            dt.Columns.Add("Question18");
            dt.Columns.Add("QuestionComment18");
            dt.Columns.Add("Question19");
            dt.Columns.Add("QuestionComment19");
            dt.Columns.Add("Question20");
            dt.Columns.Add("QuestionComment20");
            dt.Columns.Add("Question21");
            dt.Columns.Add("QuestionComment21");

            foreach (Hashtable data in list)
            {
                DataRow row = dt.NewRow();
                row["ImportUser"] = data["ImportUser"];
                row["ImportTime"] = data["ImportTime"];
                row["LineNum"] = data["LineNum"];
                row["ErrorFlag"] = data["ErrorFlag"];
                row["ErrorDesc"] = data["ErrorDesc"];
                row["DealerCode"] = data["DealerCode"];
                row["DealerId"] = data["DealerId"];
                row["ProductLine"] = data["ProductLine"];
                row["Question1"] = data["Question1"];
                row["QuestionComment1"] = data["QuestionComment1"];
                row["Question2"] = data["Question2"];
                row["QuestionComment2"] = data["QuestionComment2"];
                row["Question3"] = data["Question3"];
                row["QuestionComment3"] = data["QuestionComment3"];
                row["Question4"] = data["Question4"];
                row["QuestionComment4"] = data["QuestionComment4"];
                row["Question5"] = data["Question5"];
                row["QuestionComment5"] = data["QuestionComment5"];
                row["Question6"] = data["Question6"];
                row["QuestionComment6"] = data["QuestionComment6"];
                row["Question7"] = data["Question7"];
                row["QuestionComment7"] = data["QuestionComment7"];
                row["Question8"] = data["Question8"];
                row["QuestionComment8"] = data["QuestionComment8"];
                row["Question9"] = data["Question9"];
                row["QuestionComment9"] = data["QuestionComment9"];
                row["Question10"] = data["Question10"];
                row["QuestionComment10"] = data["QuestionComment10"];
                row["Question11"] = data["Question11"];
                row["QuestionComment11"] = data["QuestionComment11"];
                row["Question12"] = data["Question12"];
                row["QuestionComment12"] = data["QuestionComment12"];
                row["Question13"] = data["Question13"];
                row["QuestionComment13"] = data["QuestionComment13"];
                row["Question14"] = data["Question14"];
                row["QuestionComment14"] = data["QuestionComment14"];
                row["Question15"] = data["Question15"];
                row["QuestionComment15"] = data["QuestionComment15"];
                row["Question16"] = data["Question16"];
                row["QuestionComment16"] = data["QuestionComment16"];
                row["Question17"] = data["Question17"];
                row["QuestionComment17"] = data["QuestionComment17"];
                row["Question18"] = data["Question18"];
                row["QuestionComment18"] = data["QuestionComment18"];
                row["Question19"] = data["Question19"];
                row["QuestionComment19"] = data["QuestionComment19"];
                row["Question20"] = data["Question20"];
                row["QuestionComment20"] = data["QuestionComment20"];
                row["Question21"] = data["Question21"];
                row["QuestionComment21"] = data["QuestionComment21"];

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("DP.DPSatisfyImport", dt);
        }

        public string ProcImportDPSatisfy(Guid userId, String version)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", userId);
            ht.Add("Version", version);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("ProcImportDPSatisfy", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        public DataSet SelectImportDPSatisfyByCondition(Hashtable condition, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectImportDPSatisfyByCondition", condition, start, limit, out totalCount);
            return ds;
        }

        #endregion

        #region AuditChannel

        public string ProcImportDPAuditChannel(Guid userId, String importType)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", userId);
            ht.Add("ImportType", importType);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("ProcImportDPAuditChannel", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        #endregion

        #region BaseComp

        public string ProcImportDPBaseComp(Guid userId, String importType)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", userId);
            ht.Add("ImportType", importType);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("ProcImportDPBaseComp", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        #endregion

        #region DeepComp

        public string ProcImportDPDeepComp(Guid userId, String importType)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", userId);
            ht.Add("ImportType", importType);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("ProcImportDPDeepComp", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        #endregion

        #region Comp

        public int DeleteDPCompImportByUser(String userId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDPCompImportByUser", userId);
            return cnt;
        }

        public DataSet SelectImportDPCompByCondition(Hashtable condition, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectImportDPCompByCondition", condition, start, limit, out totalCount);
            return ds;
        }

        public String GenerateVersion()
        {
            Hashtable ht = base.ExecuteQueryForObject<Hashtable>("GenerateVersion", null);
            return ht["Version"].ToString();
        }

        public void InsertDpCompImport(Hashtable info)
        {
            this.ExecuteInsert("InsertDpCompImport", info);
        }

        public void InsertDpCompHead(Hashtable info)
        {
            this.ExecuteInsert("InsertDpCompHead", info);
        }

        public void InsertDpCompOpePay(Hashtable info)
        {
            this.ExecuteInsert("InsertDpCompOpePay", info);
        }

        public void InsertDpCompPubLawsuit(Hashtable info)
        {
            this.ExecuteInsert("InsertDpCompPubLawsuit", info);
        }

        public void InsertDpCompRegChange(Hashtable info)
        {
            this.ExecuteInsert("InsertDpCompRegChange", info);
        }

        public void InsertDpCompRegPort(Hashtable info)
        {
            this.ExecuteInsert("InsertDpCompRegPort", info);
        }

        public void InsertDpCompStaff(Hashtable info)
        {
            this.ExecuteInsert("InsertDpCompStaff", info);
        }

        public void InsertDpCompStaffResume(Hashtable info)
        {
            this.ExecuteInsert("InsertDpCompStaffResume", info);
        }

        public void InsertDpCompStoInvest(Hashtable info)
        {
            this.ExecuteInsert("InsertDpCompStoInvest", info);
        }

        public void InsertDpCompStoState(Hashtable info)
        {
            this.ExecuteInsert("InsertDpCompStoState", info);
        }

        public void InsertDpCompStoStructure(Hashtable info)
        {
            this.ExecuteInsert("InsertDpCompStoStructure", info);
        }

        #endregion

        public int DeleteDPImportHead(String importUser, String importType)
        {
            Hashtable condition = new Hashtable();
            condition.Add("ImportUser", importUser);
            condition.Add("ImportType", importType);
            int cnt = (int)this.ExecuteDelete("DeleteDPImportHead", condition);
            return cnt;
        }

        public int DeleteDPImportLine(String importUser, String importType)
        {
            Hashtable condition = new Hashtable();
            condition.Add("ImportUser", importUser);
            condition.Add("ImportType", importType);
            int cnt = (int)this.ExecuteDelete("DeleteDPImportLine", condition);
            return cnt;
        }

        public void BatchInsertDPImportHead(IList<Hashtable> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("HeadId", typeof(Guid));
            dt.Columns.Add("ImportType");
            dt.Columns.Add("ImportUser", typeof(Guid));
            dt.Columns.Add("ImportTime", typeof(DateTime));
            dt.Columns.Add("LineNum", typeof(int));
            dt.Columns.Add("ErrorFlag", typeof(bool));
            dt.Columns.Add("ErrorDesc");
            dt.Columns.Add("DealerCode");
            dt.Columns.Add("DealerId", typeof(Guid));
            for (int i = 1; i <= 50; i++)
            {
                dt.Columns.Add("Column" + i.ToString());
            }

            foreach (Hashtable data in list)
            {
                DataRow row = dt.NewRow();
                row["HeadId"] = data["HeadId"];
                row["ImportType"] = data["ImportType"];
                row["ImportUser"] = data["ImportUser"];
                row["ImportTime"] = data["ImportTime"];
                row["LineNum"] = data["LineNum"];
                row["ErrorFlag"] = data["ErrorFlag"];
                row["ErrorDesc"] = data["ErrorDesc"];
                row["DealerCode"] = data["DealerCode"];
                row["DealerId"] = data["DealerId"];
                for (int i = 1; i <= 50; i++)
                {
                    row["Column" + i.ToString()] = data["Column" + i.ToString()];
                }

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("DP.DPImportHead", dt);
        }

        public void BatchInsertDPImportLine(IList<Hashtable> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("LineId", typeof(Guid));
            dt.Columns.Add("HeadId", typeof(Guid));
            dt.Columns.Add("ImportType");
            dt.Columns.Add("ImportUser", typeof(Guid));
            dt.Columns.Add("DealerCode");
            dt.Columns.Add("DealerId", typeof(Guid));
            for (int i = 1; i <= 30; i++)
            {
                dt.Columns.Add("Column" + i.ToString());
            }

            foreach (Hashtable data in list)
            {
                DataRow row = dt.NewRow();
                row["LineId"] = data["LineId"];
                row["HeadId"] = data["HeadId"];
                row["ImportType"] = data["ImportType"];
                row["ImportUser"] = data["ImportUser"];
                row["DealerCode"] = data["DealerCode"];
                row["DealerId"] = data["DealerId"];
                for (int i = 1; i <= 30; i++)
                {
                    row["Column" + i.ToString()] = data["Column" + i.ToString()];
                }

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("DP.DPImportLine", dt);
        }

        public DataSet SelectDPImportHead(Hashtable condition, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDPImportHead", condition, start, limit, out totalCount);
            return ds;
        }
    }
}