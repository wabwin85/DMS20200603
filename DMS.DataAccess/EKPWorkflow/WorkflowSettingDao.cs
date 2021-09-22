using DMS.Model.EKPWorkflow;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.DataAccess.EKPWorkflow
{
    public class WorkflowSettingDao : BaseSqlMapDao
    {
        /// <summary>
        /// 默认构造函数
        /// </summary>
        public WorkflowSettingDao() : base()
        {
        }

        #region WorkflowModelSetting
        public IList<ModelSetting> SelectModelSettingListByFilter(Hashtable table)
        {
            IList<ModelSetting> list = this.ExecuteQueryForList<ModelSetting>("SelectModelSettingListByFilter", table);
            return list;
        }
        #endregion

        #region WorkflowFieldSetting
        public IList<FieldSetting> SelectFieldSettingListByFilter(Hashtable table)
        {
            IList<FieldSetting> list = this.ExecuteQueryForList<FieldSetting>("SelectFieldSettingListByFilter", table);
            return list;
        }
        #endregion

    }
}