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
    public class ProductCodeQueryBLL
    {
        public DataSet SelectProductCode(string QrCode)
        {
            using (ProductCodeReportDao dao = new ProductCodeReportDao())
            {
                DataSet ds = dao.ProductCodeQuery(QrCode);
                return ds;
            }
        }
        public DataSet ProductDelareQuery(string QrCode)
        {
            using (ProductCodeReportDao dao = new ProductCodeReportDao())
            {
                DataSet ds = dao.ProductDelareQuery(QrCode);
                return ds;
            }
        }

        public bool IsQrCodeExists(string qrCode)
        {
            using (ProductCodeReportDao dao = new ProductCodeReportDao())
            {
                DataSet ds = dao.SelectQrCodeByCode(qrCode);
                if (ds != null && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
    }
}
