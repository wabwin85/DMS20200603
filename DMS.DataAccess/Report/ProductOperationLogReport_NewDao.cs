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
    public class ProductOperationLogReport_NewDao : BaseSqlMapDao
    {
        public ProductOperationLogReport_NewDao()
            : base()
        {
        }

        public DataTable SelectProductOperationLogReport(string ProductLine, string SubCompanyId, string BrandId, string DealerId, string ProductModel, string BatchNo, string StartDate, string EndDate)
        {
            Hashtable ht = new Hashtable();

            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("DealerId", DealerId);
            if (!string.IsNullOrEmpty(ProductLine.Trim()))
            {
                ht.Add("ProductLine", ProductLine);
            }
            if (!string.IsNullOrEmpty(ProductModel.Trim()))
            {
                ht.Add("CfnNumber", ProductModel);
            }
            if (!string.IsNullOrEmpty(BatchNo.Trim()))
            {
                ht.Add("LotNumber", BatchNo);
            }

            if (string.IsNullOrEmpty(StartDate.Trim()) && string.IsNullOrEmpty(EndDate.Trim()))
            {
                StartDate = DateTime.Now.AddMonths(-3).ToString("yyyy-MM-dd");
                EndDate = DateTime.Now.ToString("yyyy-MM-dd");
            }
            if (!string.IsNullOrEmpty(StartDate))
            {
                ht.Add("StartDate", StartDate);
            }
            if (!string.IsNullOrEmpty(EndDate))
            {
                ht.Add("EndDate", EndDate);
            }
            

            DataTable ds = this.ExecuteQueryForDataSet("SelectProductOperationLogReport", ht).Tables[0];
            return ds;
        }

        public DataSet ExportProductOperationLogReport(string ProductLine, string DealerId, string ProductModel, string BatchNo,string StartDate,string EndDate, string SubCompanyId, string BrandId)
        {
            if (string.IsNullOrEmpty(StartDate.Trim()) && string.IsNullOrEmpty(EndDate.Trim()))
            {
                StartDate = DateTime.Now.AddMonths(-3).ToString("yyyy-MM-dd");
                EndDate = DateTime.Now.ToString("yyyy-MM-dd");
            }

            Hashtable ht = new Hashtable();

            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            if (!string.IsNullOrEmpty(StartDate))
            {
                ht.Add("StartDate", StartDate);
            }
            if (!string.IsNullOrEmpty(EndDate))
            {
                ht.Add("EndDate", EndDate);
            }
            ht.Add("DealerId", DealerId);
            if (!string.IsNullOrEmpty(ProductLine.Trim()))
            {
                ht.Add("ProductLine", ProductLine);
            }
            if (!string.IsNullOrEmpty(ProductModel.Trim()))
            {
                ht.Add("CfnNumber", ProductModel);
            }
            if (!string.IsNullOrEmpty(BatchNo.Trim()))
            {
                ht.Add("LotNumber", BatchNo);
            }

            return this.ExecuteQueryForDataSet("ExportProductOperationLogReport", ht);
        }
    }
}
