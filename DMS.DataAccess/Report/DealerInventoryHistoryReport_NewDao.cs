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
    public class DealerInventoryHistoryReport_NewDao : BaseSqlMapDao
    {
        public DealerInventoryHistoryReport_NewDao()
            : base()
        {
        }

        public DataTable SelectDealerInventoryHistoryReport(bool IsDealer,string Dealer, string StartDate, string EndDate, string Type, string UserId, string CorpId, string SubCompanyId, string BrandId)
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

            Hashtable ConsignContract = new Hashtable();

            ConsignContract.Add("SubCompanyId", SubCompanyId);
            ConsignContract.Add("BrandId", BrandId);
            if (!string.IsNullOrEmpty(Dealer.Trim()))
            {
                ConsignContract.Add("Dealer", Dealer);
            }

            ConsignContract.Add("StartDate", StartDate);
            ConsignContract.Add("EndDate", EndDate);
            ConsignContract.Add("UserId", UserId);

            if (IsDealer)
            {
                if (Type.Trim().ToUpper() == "LP" || Type.Trim().ToUpper() == "LS")
                {
                    ConsignContract.Add("DealerType", "LP");
                    ConsignContract.Add("CorpId", CorpId);
                }
                else
                {
                    ConsignContract.Add("DealerType", "DEALER");
                    ConsignContract.Add("CorpId", CorpId);
                }
            }
            else
            {
                ConsignContract.Add("DealerType", "USER");
            }
            
            DataTable ds = this.ExecuteQueryForDataSet("SelectDealerInventoryHistoryReport", ConsignContract).Tables[0];
            return ds;
        }

        public DataSet ExportDealerInventoryHistoryReport(bool IsDealer, string Dealer, string StartDate, string EndDate, string Type, string UserId, string CorpId, string SubCompanyId, string BrandId)
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

            Hashtable ConsignContract = new Hashtable();

            ConsignContract.Add("SubCompanyId", SubCompanyId);
            ConsignContract.Add("BrandId", BrandId);
            if (!string.IsNullOrEmpty(Dealer.Trim()))
            {
                ConsignContract.Add("Dealer", Dealer);
            }

            ConsignContract.Add("StartDate", StartDate);
            ConsignContract.Add("EndDate", EndDate);
            ConsignContract.Add("UserId", UserId);

            if (IsDealer)
            {
                if (Type.Trim().ToUpper() == "LP" || Type.Trim().ToUpper() == "LS")
                {
                    ConsignContract.Add("DealerType", "LP");
                    ConsignContract.Add("CorpId", CorpId);
                }
                else
                {
                    ConsignContract.Add("DealerType", "DEALER");
                    ConsignContract.Add("CorpId", CorpId);
                }
            }
            else
            {
                ConsignContract.Add("DealerType", "USER");
            }

            return this.ExecuteQueryForDataSet("ExportDealerInventoryHistoryReport", ConsignContract);
        }
    }
}
