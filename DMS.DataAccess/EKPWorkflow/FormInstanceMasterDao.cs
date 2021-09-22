using DMS.Model;
using DMS.Model.EKPWorkflow;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.DataAccess.EKPWorkflow
{
    public class FormInstanceMasterDao : BaseSqlMapDao
    {
        /// <summary>
        /// 默认构造函数
        /// </summary>
        public FormInstanceMasterDao() : base()
        {
        }

        public IList<FormInstanceMaster> SelectFormInstanceMasterListByFilter(Hashtable table)
        {
            IList<FormInstanceMaster> list = this.ExecuteQueryForList<FormInstanceMaster>("SelectFormInstanceMasterListByFilter", table);
            return list;
        }

        public void InsertFormInstanceMaster(FormInstanceMaster obj)
        {
            this.ExecuteInsert("InsertFormInstanceMaster", obj);
        }

        public void UpdateFormInstanceMaster(FormInstanceMaster obj)
        {
            this.ExecuteUpdate("UpdateFormInstanceMaster", obj);
        }

        public DataSet GetCommonFormData(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetEkpWorkflowCommonFormData", table);
            return ds;
        }

        public void UpdateCommonFormStatus(Hashtable table)
        {
            this.ExecuteQueryForDataSet("UpdateCommonFormStatus", table);
        }
        public void UpdateCurrentApprover(Hashtable table)
        {
            this.ExecuteQueryForDataSet("UpdateCurrentApprover", table);
        }
        public DataSet GetCommonHtmlData(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetCommonHtmlData", table);
            return ds;
        }

        public bool CheckFormData(String InstanceId, String ModelId, String TemplateFormId, String NodeIds, out String RtnMsg)
        {
            String RtnVal = "";
            RtnMsg = "";

            Hashtable condition = new Hashtable();
            condition.Add("InstanceId", InstanceId);
            condition.Add("ModelId", ModelId);
            condition.Add("TemplateFormId", TemplateFormId);
            condition.Add("NodeIds", NodeIds);
            condition.Add("RtnVal", RtnVal);
            condition.Add("RtnMsg", RtnMsg);

            this.ExecuteUpdate("ProcCheckFormData", condition);

            RtnVal = condition["RtnVal"] != null ? condition["RtnVal"].ToString() : "";
            RtnMsg = condition["RtnMsg"] != null ? condition["RtnMsg"].ToString() : "";

            if (RtnVal == "Success")
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public void ExecutiveCommonFormBusiness(Hashtable table)
        {
            this.ExecuteQueryForDataSet("ExecutiveCommonFormBusiness", table);
        }
    }
}
