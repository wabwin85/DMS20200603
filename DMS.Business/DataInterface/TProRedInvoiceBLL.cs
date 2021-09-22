using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model;
using DMS.DataAccess;
using Grapecity.DataAccess.Transaction;
using System.Collections;
using DMS.Model.Data;

namespace DMS.Business.DataInterface
{
    public class TProRedInvoiceBLL
    {
        public void ImportInterfaceT_PRO_TProRedInvoice(IList<TProRedInvoice> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                foreach (TProRedInvoice item in list)
                {
                    using (TProRedInvoiceDao dao = new TProRedInvoiceDao())
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }
        public void HandleInterfaceTPRORedInvoiceDate(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            using (TProRedInvoiceDao dao = new TProRedInvoiceDao())
            {
                dao.HandleInterfaceTPRORedInvoiceDate(BatchNbr, ClientID, out RtnVal, out RtnMsg);
            }
        }
        public IList<TProRedInvoice> SelectInterfaceTProRedInvoiceByBatchNbrErrorOnly(string BatchNbr)
        {
            using (TProRedInvoiceDao dao = new TProRedInvoiceDao())
            {
               return dao.SelectInterfaceTProRedInvoiceByBatchNbrErrorOnly(BatchNbr);
            }
        }
    }
}
