using DMS.Model;
using DMS.Model.EKPWorkflow;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.DataAccess.EKPWorkflow
{
    public class WorkflowLogDao : BaseSqlMapDao
    {
        /// <summary>
        /// 默认构造函数
        /// </summary>
        public WorkflowLogDao() : base()
        {
        }

        public DataTable SelectWorkflowLogListByFilter()
        {
            DataTable ds = this.ExecuteQueryForDataSet("SelectWorkflowLogListByFilter", null).Tables[0];
            return ds;
        }

        public void InsertWorkflowLog(WorkflowLog obj)
        {
            this.ExecuteInsert("InsertWorkflowLog", obj);
        }
    }
}
