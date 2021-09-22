using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model;
using Grapecity.DataAccess.Transaction;
using DMS.DataAccess;
using System.Collections;

namespace DMS.Business.DataInterface
{
    public class TrasferBLL
    {
        public void ImportInterfaceTransfer(IList<InterfaceTransfer> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceTransferDao dao = new InterfaceTransferDao())
                {
                    foreach (InterfaceTransfer item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public IList<TransferNote> SelectTransferNoteByBatchNbrErrorOnly(string batchNbr)
        {
            using (TransferNoteDao dao = new TransferNoteDao())
            {
                return dao.SelectTransferNoteByBatchNbrErrorOnly(batchNbr);
            }
        }

        public void HandleTransferData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (InterfaceTransferDao dao = new InterfaceTransferDao())
            {
                dao.HandleTransferData(BatchNbr, ClientID, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out RtnVal, out RtnMsg);
            }
        }

        public void HandleTransferLSData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            using (InterfaceTransferDao dao = new InterfaceTransferDao())
            {
                dao.HandleTransferLSData(BatchNbr, ClientID, out RtnVal, out RtnMsg);
            }
        }

        #region T2接口
        public void ImportInterfaceTransferForT2(IList<InterfaceTransferFort2> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceTransferFort2Dao dao = new InterfaceTransferFort2Dao())
                {
                    foreach (InterfaceTransferFort2 item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public void HandleTransferDataForT2(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            using (InterfaceTransferFort2Dao dao = new InterfaceTransferFort2Dao())
            {
                dao.HandleTransferDataForT2(BatchNbr, ClientID, out RtnVal, out RtnMsg);
            }
        }

        public void ImportInterfaceTransferForLS(IList<InterfaceTransferForls> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceTransferForlsDao dao = new InterfaceTransferForlsDao())
                {
                    foreach (InterfaceTransferForls item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }


        public IList<InterfaceTransferForls> SelectTransferForLsByBatchNbrErrorOnly(string batchNbr)
        {
            using (InterfaceTransferForlsDao dao = new InterfaceTransferForlsDao())
            {
                return dao.SelectTransferForLsByBatchNbrErrorOnly(batchNbr);
            }
        }
        #endregion
    }
}
