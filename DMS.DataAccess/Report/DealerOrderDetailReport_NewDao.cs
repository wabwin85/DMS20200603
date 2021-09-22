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
    public class DealerOrderDetailReport_NewDao : BaseSqlMapDao
    {
        public DealerOrderDetailReport_NewDao()
            : base()
        {
        }

        public DataTable SelectDealerOrderDetailReport(string ProductLine, string StartDate, string EndDate, string UserId, string ProductModel,string CorpId)
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

            ht.Add("UserId", UserId);
            ht.Add("StartDate", StartDate);
            ht.Add("EndDate", EndDate);
            ht.Add("CorpId", CorpId);
            if (!string.IsNullOrEmpty(ProductLine.Trim()))
            {
                ht.Add("ProductLine", ProductLine);
            }
            if (!string.IsNullOrEmpty(ProductModel.Trim()))
            {
                ht.Add("CfnNumber", ProductModel);
            }

            DataTable ds = this.ExecuteQueryForDataSet("SelectDealerOrderDetailReport", ht).Tables[0];
            return ds;
        }

        public DataSet ExportDealerOrderDetailReport(string ProductLine, string StartDate, string EndDate, string UserId, string ProductModel, string CorpId)
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

            ht.Add("UserId", UserId);
            ht.Add("StartDate", StartDate);
            ht.Add("EndDate", EndDate);
            ht.Add("CorpId", CorpId);
            if (!string.IsNullOrEmpty(ProductLine.Trim()))
            {
                ht.Add("ProductLine", ProductLine);
            }
            if (!string.IsNullOrEmpty(ProductModel.Trim()))
            {
                ht.Add("CfnNumber", ProductModel);
            }

            return this.ExecuteQueryForDataSet("ExportDealerOrderDetailReport", ht);
        }
    }
}
