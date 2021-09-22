using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess.DP;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;


namespace DMS.Business.DP
{
    public class DPForecastImportService : IDPForecastImportService
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        public DataSet DPForecastExport(string YearMonth, string cbProductLine)
        {
            Hashtable obj = new Hashtable();
            if (!string.IsNullOrEmpty(cbProductLine))
            { 
            obj.Add("cbProductLine", cbProductLine);
            }
            obj.Add("UserId", new Guid(_context.User.Id));
            obj.Add("YEARMONTH", YearMonth);
            using (DPForecastImportDao dao = new DPForecastImportDao())
            {
                return dao.DPForecastExport(obj);
            }
        }

        public DataSet GetYearMonth()
        {
            using (DPForecastImportDao dao = new DPForecastImportDao())
            {
                return dao.GetYearMonth();
            }
        }

        public DataSet Get3MonthBP()
        {
            using (DPForecastImportDao dao = new DPForecastImportDao())
            {
                return dao.Get3MonthBP(_context.User.Id);
            }
        }
    }
}
