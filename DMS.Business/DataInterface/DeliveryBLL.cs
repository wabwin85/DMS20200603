using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model;
using DMS.DataAccess;
using Grapecity.DataAccess.Transaction;
using System.Collections;
using System.Data;
using DMS.Model.Data;
using DMS.Model.DataInterface;

namespace DMS.Business.DataInterface
{
    public class DeliveryBLL
    {
        public void InsertInterfaceShipment(InterfaceShipment obj)
        {
            using (InterfaceShipmentDao dao = new InterfaceShipmentDao())
            {
                dao.Insert(obj);
            }
        }

        public void ImportInterfaceShipment(IList<InterfaceShipment> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceShipmentDao dao = new InterfaceShipmentDao())
                {
                    foreach (InterfaceShipment item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public int InitDeliveryInterfaceByClientID(string clientid, string batchNbr)
        {
            using (DeliveryInterfaceDao dao = new DeliveryInterfaceDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("Clientid", clientid);
                ht.Add("BatchNbr", batchNbr);
                ht.Add("UpdateDate", DateTime.Now);
                return dao.InitByClientID(ht);
            }
        }

        public IList<SapDeliveryData> QuerySapDeliveryDataByBatchNbr(string batchNbr)
        {
            using (DeliveryInterfaceDao dao = new DeliveryInterfaceDao())
            {
                return dao.QuerySapDeliveryDataByBatchNbr(batchNbr);
            }
        }

        public int UpdateDeliveryInterfaceForDownloadedByBatchNbr(string batchNbr, PurchaseOrderMakeStatus status)
        {
            using (DeliveryInterfaceDao dao = new DeliveryInterfaceDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("BatchNbr", batchNbr);
                ht.Add("Status", status.ToString());
                ht.Add("UpdateDate", DateTime.Now);
                return dao.UpdateDeliveryInterfaceForDownloadedByBatchNbr(ht);
            }
        }


        public void ImportInterfaceDeliveryConfirmation(IList<InterfaceDeliveryConfirmation> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceDeliveryConfirmationDao dao = new InterfaceDeliveryConfirmationDao())
                {
                    foreach (InterfaceDeliveryConfirmation item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public IList<DeliveryNote> SelectDeliveryNoteByBatchNbrErrorOnly(string batchNbr)
        {
            using (DeliveryNoteDao dao = new DeliveryNoteDao())
            {
                return dao.SelectDeliveryNoteByBatchNbrErrorOnly(batchNbr);
            }
        }
        public IList<OrderStatusData> SelectOrderStatusNoteByBatchNbrErrorOnly(string batchNbr)
        {
            using (DeliveryNoteDao dao = new DeliveryNoteDao())
            {
                return dao.SelectOrderStatusNoteByBatchNbrErrorOnly(batchNbr);
            }
        }

        public DataSet SelectOrderStatusNoteByBatchNbrToCompleted(string batchNbr)
        {
            using (DeliveryNoteDao dao = new DeliveryNoteDao())
            {
                return dao.SelectOrderStatusNoteByBatchNbrToCompleted(batchNbr);
            }
        }

        public IList<DeliveryConfirmation> SelectDeliveryConfirmationByBatchNbrErrorOnly(string batchNbr)
        {
            using (DeliveryConfirmationDao dao = new DeliveryConfirmationDao())
            {
                return dao.SelectDeliveryConfirmationByBatchNbrErrorOnly(batchNbr);
            }
        }

        public void HandleShipmentData(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            Hashtable ht = new Hashtable();
            //BaseService.AddCommonFilterCondition(ht);
            using (InterfaceShipmentDao dao = new InterfaceShipmentDao())
            {
                dao.HandleShipmentData(BatchNbr, ClientID, out IsValid, out RtnMsg);
            }
        }
        public void HandleShipmentDataVR(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            Hashtable ht = new Hashtable();
            //BaseService.AddCommonFilterCondition(ht);
            using (InterfaceShipmentDao dao = new InterfaceShipmentDao())
            {
                dao.HandleShipmentDataVR(BatchNbr, ClientID, out IsValid, out RtnMsg);
            }
        }
        public void HandleOrderStatusData(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            Hashtable ht = new Hashtable();
            //BaseService.AddCommonFilterCondition(ht);
            using (InterfaceShipmentDao dao = new InterfaceShipmentDao())
            {
                dao.HandleOrderStatusData(BatchNbr, ClientID, out IsValid, out RtnMsg);
            }
        }
        public void HandleShipmentT2NormalData(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            Hashtable ht = new Hashtable();
            //BaseService.AddCommonFilterCondition(ht);
            using (InterfaceShipmentDao dao = new InterfaceShipmentDao())
            {
                dao.HandleShipmentT2NormalData(BatchNbr, ClientID,out IsValid, out RtnMsg);
            }
        }

        public void HandleShipmentT2ConsignmentData(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (InterfaceShipmentDao dao = new InterfaceShipmentDao())
            {
                dao.HandleShipmentT2ConsignmentData(BatchNbr, ClientID, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out IsValid, out RtnMsg);
            }
        }

        public void HandleDeliveryConfirmationData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            using (InterfaceDeliveryConfirmationDao dao = new InterfaceDeliveryConfirmationDao())
            {
                dao.HandleDeliveryConfirmationData(BatchNbr, ClientID, out RtnVal, out RtnMsg);
            }
        }

        public void ImportInterfaceDealerConsignmentSalesPrice(IList<InterfaceDealerConsignmentSalesPrice> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceDealerConsignmentSalesPriceDao dao = new InterfaceDealerConsignmentSalesPriceDao())
                {
                    foreach (InterfaceDealerConsignmentSalesPrice item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public void HandleDealerConsignmentSalesPriceData(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            using (InterfaceDealerConsignmentSalesPriceDao dao = new InterfaceDealerConsignmentSalesPriceDao())
            {
                dao.HandleDealerConsignmentSalesPriceData(BatchNbr, ClientID, out IsValid, out RtnMsg);
            }
        }

        public IList<InterfaceDealerConsignmentSalesPrice> SelectDataByBatchNbrErrorOnly(string batchNbr)
        {
            using (InterfaceDealerConsignmentSalesPriceDao dao = new InterfaceDealerConsignmentSalesPriceDao())
            {
                return dao.SelectDataByBatchNbrErrorOnly(batchNbr);
            }
        }


        //增加畅联波科发货数据接口，Add By SongWeiming on 2015-12-07
        public void ImportInterfaceShipmentBSCSLC(IList<InterfaceShipmentbscslc> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceShipmentbscslcDao dao = new InterfaceShipmentbscslcDao())
                {
                    foreach (InterfaceShipmentbscslc item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        //增加畅联波科发货数据接口，Add By SongWeiming on 2015-12-07
        public void HandleShipmentBSCSLCData(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            using (InterfaceShipmentbscslcDao dao = new InterfaceShipmentbscslcDao())
            {
                dao.HandleShipmentBSCSLCData(BatchNbr, ClientID, out IsValid, out RtnMsg);
            }
        }

        //增加畅联波科发货数据接口-获取错误信息，Add By SongWeiming on 2015-12-07
        public IList<DeliveryNotebscslc> SelectDeliveryNoteBSCSLCByBatchNbrErrorOnly(string batchNbr)
        {
            using (DeliveryNotebscslcDao dao = new DeliveryNotebscslcDao())
            {
                return dao.SelectDeliveryNoteBSCSLCByBatchNbrErrorOnly(batchNbr);
            }
        }

        #region 佑成接口
        public void ImportInterfaceT2DeliveryConfirmation(IList<Interfacet2DeliveryConfirmation> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (Interfacet2DeliveryConfirmationDao dao = new Interfacet2DeliveryConfirmationDao())
                {
                    foreach (Interfacet2DeliveryConfirmation item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public void HandleT2DeliveryConfirmationData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            using (Interfacet2DeliveryConfirmationDao dao = new Interfacet2DeliveryConfirmationDao())
            {
                dao.HandleT2DeliveryConfirmationData(BatchNbr, ClientID, out RtnVal, out RtnMsg);
            }
        }

        public int InitT2DeliveryInterfaceByClientID(string clientid, string batchNbr)
        {
            using (DeliveryInterfaceDao dao = new DeliveryInterfaceDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("Clientid", clientid);
                return dao.InitT2ByClientID(ht);
            }
        }

        public IList<LPDeliveryForT2Data> QueryT2DeliveryDataByBatchNbr(string batchNbr)
        {
            using (DeliveryInterfaceDao dao = new DeliveryInterfaceDao())
            {
                return dao.QueryT2DeliveryDataByBatchNbr(batchNbr);
            }
        }
        #endregion
    }
}
