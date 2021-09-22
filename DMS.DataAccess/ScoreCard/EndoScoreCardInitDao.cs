
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : EndoScoreCardInit
 * Created Time: 2014/10/9 11:38:05
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
    /// EndoScoreCardInit的Dao
    /// </summary>
    public class EndoScoreCardInitDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public EndoScoreCardInitDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public EndoScoreCardInit GetObject(Guid objKey)
        {
            EndoScoreCardInit obj = this.ExecuteQueryForObject<EndoScoreCardInit>("SelectEndoScoreCardInit", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<EndoScoreCardInit> GetAll()
        {
            IList<EndoScoreCardInit> list = this.ExecuteQueryForList<EndoScoreCardInit>("SelectEndoScoreCardInit", null);          
            return list;
        }


        /// <summary>
        /// 查询EndoScoreCardInit
        /// </summary>
        /// <returns>返回EndoScoreCardInit集合</returns>
		public IList<EndoScoreCardInit> SelectByFilter(EndoScoreCardInit obj)
		{ 
			IList<EndoScoreCardInit> list = this.ExecuteQueryForList<EndoScoreCardInit>("SelectByFilterEndoScoreCardInit", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(EndoScoreCardInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateEndoScoreCardInit", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteEndoScoreCardInit", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(EndoScoreCardInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteEndoScoreCardInit", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(EndoScoreCardInit obj)
        {
            this.ExecuteInsert("InsertEndoScoreCardInit", obj);           
        }


        public int DeleteByUser(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteEndoScoreCardInitByUser", objKey);
            return cnt;
        }

        public int UpdateEndoScoreCardInitForEdit(EndoScoreCardInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateEndoScoreCardInitForEdit", obj);
            return cnt;
        }

        /// <summary>
        /// 调用存储过程
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize(string importType, Guid UserId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("ImportType", importType);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_EndoScoreCardInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        /// 根据条件查询
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public IList<EndoScoreCardInit> SelectByHashtable(int start, int limit, out int totalRowCount)
        {
            IList<EndoScoreCardInit> list = this.ExecuteQueryForList<EndoScoreCardInit>("SelectByFilterEndoScoreCardInitByHashtable", null, start, limit, out totalRowCount);
            return list;
        }

        public void BatchInsert(IList<EndoScoreCardInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ESCI_ID", typeof(Guid));
            dt.Columns.Add("ESCI_USER", typeof(Guid));
            dt.Columns.Add("ESCI_UploadDate", typeof(DateTime));
            dt.Columns.Add("ESCI_LineNbr", typeof(int));
            dt.Columns.Add("ESCI_FileName");
            dt.Columns.Add("ESCI_ErrorFlag", typeof(bool));
            dt.Columns.Add("ESCI_ErrorDescription");
            dt.Columns.Add("ESCI_DealerName");
            dt.Columns.Add("ESCI_No");
            dt.Columns.Add("ESCI_Year");
            dt.Columns.Add("ESCI_Quarter");
            dt.Columns.Add("ESCI_Score1");
            dt.Columns.Add("ESCI_Score2");
            dt.Columns.Add("ESCI_Remark");
            dt.Columns.Add("ESCI_DealerName_ErrMsg");
            dt.Columns.Add("ESCI_No_ErrMsg");
            dt.Columns.Add("ESCI_Quarter_ErrMsg");
            dt.Columns.Add("ESCI_Score1_ErrMsg");
            dt.Columns.Add("ESCI_Score2_ErrMsg");

            foreach (EndoScoreCardInit data in list)
            {
                DataRow row = dt.NewRow();
                row["ESCI_ID"] = data.Id;
                row["ESCI_USER"] = data.User;
                row["ESCI_UploadDate"] = data.UploadDate;
                row["ESCI_LineNbr"] = data.LineNbr;
                row["ESCI_FileName"] = data.FileName;
                row["ESCI_ErrorFlag"] = data.ErrorFlag;
                row["ESCI_ErrorDescription"] = data.ErrorDescription;
                row["ESCI_DealerName"] = data.DealerName;
                row["ESCI_No"] = data.No;
                row["ESCI_Year"] = data.Year;
                row["ESCI_Quarter"] = data.Quarter;
                row["ESCI_Score1"] = data.Score1;
                row["ESCI_Score2"] = data.Score2;
                row["ESCI_Remark"] = data.Remark;
                row["ESCI_DealerName_ErrMsg"] = data.DealerNameErrMsg;
                row["ESCI_No_ErrMsg"] = data.NoErrMsg;
                row["ESCI_Quarter_ErrMsg"] = data.QuarterErrMsg;
                row["ESCI_Score1_ErrMsg"] = data.Score1ErrMsg;
                row["ESCI_Score2_ErrMsg"] = data.Score2ErrMsg;

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("EndoScoreCardInit", dt);
        }
    }
}