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
    public class OrderStatusReport_NewDao : BaseSqlMapDao
    {
        public OrderStatusReport_NewDao()
            : base()
        {
        }

        public DataTable SelectOrderStatusReport(string ProductLine, string StartDate, string EndDate, bool? IsInclude, string UserId, string DealerId, string SubCompanyId, string BrandId)
        {
            if (string.IsNullOrEmpty(StartDate.Trim()) && string.IsNullOrEmpty(EndDate.Trim()))
            {
                StartDate = DateTime.Now.AddMonths(-3).ToString("yyyy-MM-dd");
                EndDate = DateTime.Now.ToString("yyyy-MM-dd");
            }
            else if (!string.IsNullOrEmpty(StartDate.Trim()) && string.IsNullOrEmpty(EndDate.Trim()))
            {
                EndDate = DateTime.ParseExact(StartDate, "yyyy-MM-dd", System.Globalization.CultureInfo.CurrentCulture).AddMonths(3).ToString("yyyy-MM-dd");
            }
            else if (string.IsNullOrEmpty(StartDate.Trim()) && !string.IsNullOrEmpty(EndDate.Trim()))
            {
                StartDate = DateTime.ParseExact(EndDate, "yyyy-MM-dd", System.Globalization.CultureInfo.CurrentCulture).AddMonths(-3).ToString("yyyy-MM-dd");
            }

            Hashtable ht = new Hashtable();

            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("UserId", UserId);
            ht.Add("StartDate", StartDate);
            ht.Add("EndDate", EndDate);
            ht.Add("DealerId", DealerId);
            if (!string.IsNullOrEmpty(ProductLine.Trim()))
            {
                ht.Add("ProductLine", ProductLine);
            }
            if (IsInclude==false)
            {
                ht.Add("IsInclude", "1");
            }

            DataTable ds = this.ExecuteQueryForDataSet("SelectOrderStatusReport", ht).Tables[0];
            return ds;
        }

        public DataSet ExportOrderStatusReport(string ProductLine, string StartDate, string EndDate, bool? IsInclude, string UserId, string DealerId, string SubCompanyId, string BrandId)
        {
            if (string.IsNullOrEmpty(StartDate.Trim()) && string.IsNullOrEmpty(EndDate.Trim()))
            {
                StartDate = DateTime.Now.AddMonths(-3).ToString("yyyy-MM-dd");
                EndDate = DateTime.Now.ToString("yyyy-MM-dd");
            }
            else if (!string.IsNullOrEmpty(StartDate.Trim()) && string.IsNullOrEmpty(EndDate.Trim()))
            {
                EndDate = DateTime.ParseExact(StartDate, "yyyy-MM-dd", System.Globalization.CultureInfo.CurrentCulture).AddMonths(3).ToString("yyyy-MM-dd");
            }
            else if (string.IsNullOrEmpty(StartDate.Trim()) && !string.IsNullOrEmpty(EndDate.Trim()))
            {
                StartDate = DateTime.ParseExact(EndDate, "yyyy-MM-dd", System.Globalization.CultureInfo.CurrentCulture).AddMonths(-3).ToString("yyyy-MM-dd");
            }

            Hashtable ht = new Hashtable();

            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("UserId", UserId);
            ht.Add("StartDate", StartDate);
            ht.Add("EndDate", EndDate);
            ht.Add("DealerId", DealerId);
            if (!string.IsNullOrEmpty(ProductLine.Trim()))
            {
                ht.Add("ProductLine", ProductLine);
            }
            if (IsInclude == false)
            {
                ht.Add("IsInclude", "1");
            }

            return this.ExecuteQueryForDataSet("ExportOrderStatusReport", ht);
        }
    }
}
