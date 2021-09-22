
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
    public class TrainScoreImportDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public TrainScoreImportDao()
            : base()
        {
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(TrainScoreImport obj)
        {
            this.ExecuteInsert("InsertTrainScoreImport", obj);
        }

        public void BatchInsert(IList<TrainScoreImport> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("TrainScoreId", typeof(Guid));
            dt.Columns.Add("ImportUser", typeof(Guid));
            dt.Columns.Add("ImportTime", typeof(DateTime));
            dt.Columns.Add("ImportFileName");
            dt.Columns.Add("LineNum", typeof(int));
            dt.Columns.Add("DealerCode");
            dt.Columns.Add("SalesName");
            dt.Columns.Add("IsPass");
            dt.Columns.Add("ErrorFlag", typeof(bool));
            dt.Columns.Add("ErrorDesc");
            dt.Columns.Add("DealerCodeDesc");
            dt.Columns.Add("SalesNameDesc");
            dt.Columns.Add("IsPassDesc");

            foreach (TrainScoreImport data in list)
            {
                DataRow row = dt.NewRow();
                row["TrainScoreId"] = data.TrainScoreId;
                row["ImportUser"] = data.ImportUser;
                row["ImportTime"] = data.ImportTime;
                row["ImportFileName"] = data.ImportFileName;
                row["LineNum"] = data.LineNum;
                row["DealerCode"] = data.DealerCode;
                row["SalesName"] = data.SalesName;
                row["IsPass"] = data.IsPass;
                row["ErrorFlag"] = data.ErrorFlag;
                row["ErrorDesc"] = data.ErrorDesc;
                row["DealerCodeDesc"] = data.DealerCodeDesc;
                row["SalesNameDesc"] = data.SalesNameDesc;
                row["IsPassDesc"] = data.IsPassDesc;

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("Commando.TrainScoreImport", dt);
        }

        public int Delete(String objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTrainScoreImport", objKey);
            return cnt;
        }

        public int DeleteTrainScoreImportByUser(String userId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTrainScoreImportByUser", userId);
            return cnt;
        }

        public DataSet SelectTrainScoreImportByCondition(Hashtable condition, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTrainScoreImportByCondition", condition, start, limit, out totalCount);
            return ds;
        }

        public void UpdateTrainScoreImportForEdit(TrainScoreImport obj)
        {
            this.ExecuteUpdate("UpdateTrainScoreImportForEdit", obj);
        }

        public string ProcImportTrainScore(String trainId, String classId, Guid UserId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("TrainId", trainId);
            ht.Add("ClassId", classId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("ProcImportTrainScore", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }
    }
}