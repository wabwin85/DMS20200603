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
    public class DealerAuthCate_NewDao : BaseSqlMapDao
    {
        public DealerAuthCate_NewDao()
            : base()
        {
        }

        public DataTable SelectDealerAuthCate(string ProductLine,string UserId, string DealerId)
        {
            Hashtable ConsignContract = new Hashtable();

            ConsignContract.Add("UserId", UserId);
            if (!string.IsNullOrEmpty(ProductLine.Trim()))
            {
                ConsignContract.Add("ProductLine", ProductLine);
            }
            ConsignContract.Add("DealerId", DealerId);

            DataTable ds = this.ExecuteQueryForDataSet("SelectDealerAuthCate", ConsignContract).Tables[0];
            return ds;
        }

        public DataSet ExportDealerAuthCate(string ProductLine,string UserId, string DealerId)
        {
            Hashtable ConsignContract = new Hashtable();

            ConsignContract.Add("UserId", UserId);
            if (!string.IsNullOrEmpty(ProductLine.Trim()))
            {
                ConsignContract.Add("ProductLine", ProductLine);
            }
            ConsignContract.Add("DealerId", DealerId);
            return this.ExecuteQueryForDataSet("ExportDealerAuthCate", ConsignContract);
        }
    }
}
