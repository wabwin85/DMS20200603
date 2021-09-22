using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;
using DMS.Model.Consignment;
using Lafite.RoleModel.Security;

namespace DMS.DataAccess.Report
{
    public class HospitalReport_NewDao : BaseSqlMapDao
    {
        public HospitalReport_NewDao()
            : base()
        {
        }

        public DataTable SelectHospitalReport()
        {
            DataTable ds = this.ExecuteQueryForDataSet("SelectHospitalReport", null).Tables[0];
            return ds;
        }

        public DataSet ExportHospitalReport()
        {
            return this.ExecuteQueryForDataSet("ExportHospitalReport", null);
        }
    }
}
