using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model;
using DMS.DataAccess;
using Grapecity.DataAccess.Transaction;
using System.Collections;
using DMS.Model.Data;

namespace DMS.Business.MasterData
{
    public class QRCodeBLL
    {
        //增加二维码平台上传二维码主数据数据接口，Add By SongWeiming on 2015-12-10
        public void ImportInterfaceQRCodeMaster(IList<InterfaceqrCodeMaster> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceqrCodeMasterDao dao = new InterfaceqrCodeMasterDao())
                {
                    foreach (InterfaceqrCodeMaster item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }


        //增加二维码平台上传二维码主数据数据接口，Add By SongWeiming on 2015-12-10
        public void HandleQRMasterData(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            using (InterfaceqrCodeMasterDao dao = new InterfaceqrCodeMasterDao())
            {
                dao.HandleQRMasterData(BatchNbr, ClientID, out IsValid, out RtnMsg);
            }
        }

        //获取二维码接口中的错误信息，Add By SongWeiming on 2015-12-10
        public IList<InterfaceqrCodeMaster> SelectInterfaceQRCodeMasterByBatchNbrErrorOnly(string batchNbr)
        {
            using (InterfaceqrCodeMasterDao dao = new InterfaceqrCodeMasterDao())
            {
                return dao.SelectInterfaceQRCodeMasterByBatchNbrErrorOnly(batchNbr);
            }
        }



        //增加二维码APP上传经销商收集的二维码信息，Add By SongWeiming on 2016-1-16
        public void ImportInterfaceQRDealerTransaction(IList<InterfaceqrDealerTransaction> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceqrDealerTransactionDao dao = new InterfaceqrDealerTransactionDao())
                {
                    foreach (InterfaceqrDealerTransaction item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        //增加二维码平台上传二维码主数据数据接口，Add By SongWeiming on 2015-12-10
        public void HandleQRDealerTransaction(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            using (InterfaceqrDealerTransactionDao dao = new InterfaceqrDealerTransactionDao())
            {
                dao.HandleQRDealerTransaction(BatchNbr, ClientID, out IsValid, out RtnMsg);
            }
        }

        //获取二维码APP上传经销商收集的二维码操作中的错误信息，Add By SongWeiming on 2016-1-16
        public IList<InterfaceqrDealerTransaction> SelectInterfaceDealerTransactionByBatchNbrErrorOnly(string batchNbr)
        {
            using (InterfaceqrDealerTransactionDao dao = new InterfaceqrDealerTransactionDao())
            {
                return dao.SelectInterfaceQRDealerTransactionByBatchNbrErrorOnly(batchNbr);
            }
        }

    }
}
