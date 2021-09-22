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
    public class DealerSalesStatistics_NewDao : BaseSqlMapDao
    {
        public DealerSalesStatistics_NewDao()
            : base()
        {
        }

        public DataTable SelectDealerSalesStatistics(string Dealer, string ProductLine, string StartbeginTime, string StartstopTime, string EndbeginTime, string EndstopTime, string InDueTime, bool? IsPurchased,string IdentityType,string CorpId)
        {
            if (string.IsNullOrEmpty(StartbeginTime.Trim()) && string.IsNullOrEmpty(StartstopTime.Trim()))
            {
                StartbeginTime = DateTime.Now.AddMonths(-3).ToString("yyyy-MM-dd");
                StartstopTime = DateTime.Now.ToString("yyyy-MM-dd");
            }
            else if (!string.IsNullOrEmpty(StartbeginTime.Trim()) && string.IsNullOrEmpty(StartstopTime.Trim()))
            {
                StartstopTime = DateTime.ParseExact(StartbeginTime, "yyyy-MM-dd", System.Globalization.CultureInfo.CurrentCulture).AddMonths(3).ToString("yyyy-MM-dd");
            }
            else if (string.IsNullOrEmpty(StartbeginTime.Trim()) && !string.IsNullOrEmpty(StartstopTime.Trim()))
            {
                StartbeginTime = DateTime.ParseExact(StartstopTime, "yyyy-MM-dd", System.Globalization.CultureInfo.CurrentCulture).AddMonths(-3).ToString("yyyy-MM-dd");
            }

            if (string.IsNullOrEmpty(EndbeginTime.Trim()) && string.IsNullOrEmpty(EndstopTime.Trim()))
            {
                EndbeginTime = DateTime.Now.AddMonths(-3).ToString("yyyy-MM-dd");
                EndstopTime = DateTime.Now.ToString("yyyy-MM-dd");
            }
            else if (!string.IsNullOrEmpty(EndbeginTime.Trim()) && string.IsNullOrEmpty(EndstopTime.Trim()))
            {
                EndstopTime = DateTime.ParseExact(EndbeginTime, "yyyy-MM-dd", System.Globalization.CultureInfo.CurrentCulture).AddMonths(3).ToString("yyyy-MM-dd");
            }
            else if (string.IsNullOrEmpty(EndbeginTime.Trim()) && !string.IsNullOrEmpty(EndstopTime.Trim()))
            {
                EndbeginTime = DateTime.ParseExact(EndstopTime, "yyyy-MM-dd", System.Globalization.CultureInfo.CurrentCulture).AddMonths(-3).ToString("yyyy-MM-dd");
            }

            Hashtable ConsignContract = new Hashtable();

            if (!string.IsNullOrEmpty(ProductLine.Trim()))
            {
                ConsignContract.Add("ProductLine", ProductLine);
            }
            if (!string.IsNullOrEmpty(Dealer.Trim()))
            {
                ConsignContract.Add("Dealer", Dealer);
            }

            ConsignContract.Add("StartbeginTime", StartbeginTime);
            ConsignContract.Add("StartstopTime", StartstopTime);
            ConsignContract.Add("EndbeginTime", EndbeginTime);
            ConsignContract.Add("EndstopTime", EndstopTime);

            if (!string.IsNullOrEmpty(InDueTime.Trim()) && InDueTime.Trim() != "全部")
            {
                ConsignContract.Add("InDueTime", InDueTime);
            }

            if (!string.IsNullOrEmpty(IsPurchased.ToString().Trim()))
            {
                if (IsPurchased == false)
                {
                    ConsignContract.Add("IsPurchased", "0");
                }
                else
                {
                    ConsignContract.Add("IsPurchased", "1");
                }
            }
            ConsignContract.Add("IdentityType", IdentityType);
            ConsignContract.Add("CorpId", CorpId);

            DataTable ds = this.ExecuteQueryForDataSet("SelectDealerSalesStatistics", ConsignContract).Tables[0];
            return ds;
        }

        public DataSet ExportDealerSalesStatistics(string Dealer, string ProductLine, string StartbeginTime, string StartstopTime, string EndbeginTime, string EndstopTime, string InDueTime, bool? IsPurchased, string IdentityType, string CorpId)
        {
            if (string.IsNullOrEmpty(StartbeginTime.Trim()) && string.IsNullOrEmpty(StartstopTime.Trim()))
            {
                StartbeginTime = DateTime.Now.AddMonths(-3).ToString("yyyy-MM-dd");
                StartstopTime = DateTime.Now.ToString("yyyy-MM-dd");
            }
            else if (!string.IsNullOrEmpty(StartbeginTime.Trim()) && string.IsNullOrEmpty(StartstopTime.Trim()))
            {
                StartstopTime = DateTime.ParseExact(StartbeginTime, "yyyy-MM-dd", System.Globalization.CultureInfo.CurrentCulture).AddMonths(3).ToString("yyyy-MM-dd");
            }
            else if (string.IsNullOrEmpty(StartbeginTime.Trim()) && !string.IsNullOrEmpty(StartstopTime.Trim()))
            {
                StartbeginTime = DateTime.ParseExact(StartstopTime, "yyyy-MM-dd", System.Globalization.CultureInfo.CurrentCulture).AddMonths(-3).ToString("yyyy-MM-dd");
            }

            if (string.IsNullOrEmpty(EndbeginTime.Trim()) && string.IsNullOrEmpty(EndstopTime.Trim()))
            {
                EndbeginTime = DateTime.Now.AddMonths(-3).ToString("yyyy-MM-dd");
                EndstopTime = DateTime.Now.ToString("yyyy-MM-dd");
            }
            else if (!string.IsNullOrEmpty(EndbeginTime.Trim()) && string.IsNullOrEmpty(EndstopTime.Trim()))
            {
                EndstopTime = DateTime.ParseExact(EndbeginTime, "yyyy-MM-dd", System.Globalization.CultureInfo.CurrentCulture).AddMonths(3).ToString("yyyy-MM-dd");
            }
            else if (string.IsNullOrEmpty(EndbeginTime.Trim()) && !string.IsNullOrEmpty(EndstopTime.Trim()))
            {
                EndbeginTime = DateTime.ParseExact(EndstopTime, "yyyy-MM-dd", System.Globalization.CultureInfo.CurrentCulture).AddMonths(-3).ToString("yyyy-MM-dd");
            }

            Hashtable ConsignContract = new Hashtable();

            if (!string.IsNullOrEmpty(ProductLine.Trim()))
            {
                ConsignContract.Add("ProductLine", ProductLine);
            }
            if (!string.IsNullOrEmpty(Dealer.Trim()))
            {
                ConsignContract.Add("Dealer", Dealer);
            }

            ConsignContract.Add("StartbeginTime", StartbeginTime);
            ConsignContract.Add("StartstopTime", StartstopTime);
            ConsignContract.Add("EndbeginTime", EndbeginTime);
            ConsignContract.Add("EndstopTime", EndstopTime);

            if (!string.IsNullOrEmpty(InDueTime.Trim()) && InDueTime.Trim() != "全部")
            {
                ConsignContract.Add("InDueTime", InDueTime);
            }

            if (!string.IsNullOrEmpty(IsPurchased.ToString().Trim()))
            {
                if (IsPurchased == false)
                {
                    ConsignContract.Add("IsPurchased", "0");
                }
                else
                {
                    ConsignContract.Add("IsPurchased", "1");
                }
            }
            ConsignContract.Add("IdentityType", IdentityType);
            ConsignContract.Add("CorpId", CorpId);

            return this.ExecuteQueryForDataSet("ExportDealerSalesStatistics", ConsignContract);
        }
    }
}
