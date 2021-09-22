using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model;
using Grapecity.DataAccess.Transaction;
using DMS.DataAccess;

namespace DMS.Business.DataInterface
{
    public class ConfirmationBLL
    {
        public void ImportInterfaceT2OrderConfirmation(IList<InterfaceConfirmation> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceConfirmationDao dao = new InterfaceConfirmationDao())
                {
                    foreach (InterfaceConfirmation item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public IList<PurchaseOrderConfirmation> SelectPurchaseOrderConfirmationByBatchNbrErrorOnly(string batchNbr)
        {
            using (PurchaseOrderConfirmationDao dao = new PurchaseOrderConfirmationDao())
            {
                return dao.SelectPurchaseOrderConfirmationByBatchNbrErrorOnly(batchNbr);
            }
        }

        public void HandleT2OrderConfirmationData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            using (InterfaceConfirmationDao dao = new InterfaceConfirmationDao())
            {
                dao.HandleT2OrderConfirmationData(BatchNbr, ClientID, out RtnVal, out RtnMsg);
            }
        } 
    }
}
