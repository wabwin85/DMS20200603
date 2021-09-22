using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model;
using Grapecity.DataAccess.Transaction;
using DMS.DataAccess;
using System.Data;
using System.Collections;

namespace DMS.Business.DataInterface
{
    public class SalesBLL
    {
        public void ImportInterfaceSales(IList<InterfaceSales> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceSalesDao dao = new InterfaceSalesDao())
                {
                    foreach (InterfaceSales item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public IList<SalesNote> SelectSalesNoteByBatchNbrErrorOnly(string batchNbr)
        {
            using (SalesNoteDao dao = new SalesNoteDao())
            {
                return dao.SelectSalesNoteByBatchNbrErrorOnly(batchNbr);
            }
        }

        public void HandleSalesData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (InterfaceSalesDao dao = new InterfaceSalesDao())
            {
                dao.HandleSalesData(BatchNbr, ClientID, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out RtnVal, out RtnMsg);
            }
        }

        public DataSet SelectHospitalSalesByBatchNbr(string BatchNbr)
        {
            using (InterfaceSalesDao dao = new InterfaceSalesDao())
            {
                return dao.SelectHospitalSalesByBatchNbr(BatchNbr);
            }
        }

        public void ImportInterfaceSalesForT2(IList<InterfaceHospitalSalesFort2> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceHospitalSalesFort2Dao dao = new InterfaceHospitalSalesFort2Dao())
                {
                    foreach (InterfaceHospitalSalesFort2 item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public IList<SalesNote> SelectSalesNoteForT2ByBatchNbrErrorOnly(string batchNbr)
        {
            using (SalesNoteDao dao = new SalesNoteDao())
            {
                return dao.SelectSalesNoteByBatchNbrErrorOnly(batchNbr);
            }
        }

        public void HandleSalesForT2Data(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            using (InterfaceHospitalSalesFort2Dao dao = new InterfaceHospitalSalesFort2Dao())
            {
                dao.HandleSalesData(BatchNbr, ClientID, out RtnVal, out RtnMsg);
            }
        }

        public DataSet SelectHospitalSalesForT2ByBatchNbr(string BatchNbr)
        {
            using (InterfaceHospitalSalesFort2Dao dao = new InterfaceHospitalSalesFort2Dao())
            {
                return dao.SelectHospitalSalesByBatchNbr(BatchNbr);
            }
        }
    }
}
