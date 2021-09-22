using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using System.Collections;
using DMS.Model;
using System.Data;

namespace DMS.Business
{
    public class ProductCodeReportBLL
    {
        public DataSet GetProductCodeReportList(Hashtable condition, int start, int limit, out int totalRowCount)
        {
            using (ProductCodeReportDao dao = new ProductCodeReportDao())
            {
                return dao.SelectProductCodeReportList(condition, start, limit, out totalRowCount);
            }
        }

        public ProductCodeReport GetProductCodeReportById(String reportId)
        {
            using (ProductCodeReportDao dao = new ProductCodeReportDao())
            {
                return dao.SelectProductCodeReportById(reportId);
            }
        }
    }
}
