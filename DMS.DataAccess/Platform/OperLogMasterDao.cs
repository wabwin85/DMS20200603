using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;
using DMS.Model.Platform;

namespace DMS.DataAccess.Platform
{
    public class OperLogMasterDao : BaseSqlMapDao
    {
        public OperLogMasterDao()
            : base()
        {
        }

        #region Select

        public IList<Hashtable> SelectListByForeignTable(String DataSource, Guid InstanceId)
        {
            Hashtable condition = new Hashtable();
            condition.Add("DataSource", DataSource);
            condition.Add("InstanceId", InstanceId);
            return this.ExecuteQueryForList<Hashtable>("Platform.OperLogMasterMap.SelectListByForeignTable", condition);
        }

        #endregion

        #region Insert

        public void Insert(OperLogMasterPO obj)
        {
            base.ExecuteInsert("Platform.OperLogMasterMap.Insert", obj);
        }

        #endregion

        #region Update

        #endregion

        #region Delete

        #endregion

        #region Procdure

        #endregion
    }
}
