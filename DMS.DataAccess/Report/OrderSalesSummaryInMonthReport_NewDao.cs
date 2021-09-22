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
    public class OrderSalesSummaryInMonthReport_NewDao : BaseSqlMapDao
    {
        public OrderSalesSummaryInMonthReport_NewDao()
            : base()
        {
        }

        public DataTable SelectOrderSalesSummaryInMonthReport(string ProductLine, string Year, string DealerId)
        {
            Hashtable ConsignContract = new Hashtable();

            ConsignContract.Add("Year", Year);
            if (!string.IsNullOrEmpty(ProductLine.Trim()))
            {
                ConsignContract.Add("ProductLine", ProductLine);
            }
            ConsignContract.Add("DealerId", DealerId);
            ConsignContract.Add("LpId", null);

            DataTable ds = this.ExecuteQueryForDataSet("SelectOrderSalesSummaryInMonthReport", ConsignContract).Tables[0];
            return ds;
        }

        public DataSet ExportOrderSalesSummaryInMonthReport(string ProductLine, string Year, string DealerId)
        {
            Hashtable ConsignContract = new Hashtable();

            ConsignContract.Add("Year", Year);
            if (!string.IsNullOrEmpty(ProductLine.Trim()))
            {
                ConsignContract.Add("ProductLine", ProductLine);
            }
            ConsignContract.Add("DealerId", DealerId);
            ConsignContract.Add("LpId", null);

            return this.ExecuteQueryForDataSet("ExportOrderSalesSummaryInMonthReport", ConsignContract);
        }
    }
}
