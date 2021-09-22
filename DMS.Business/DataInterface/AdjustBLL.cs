using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model;
using Grapecity.DataAccess.Transaction;
using DMS.DataAccess;
using DMS.Model.DataInterface;
using System.Collections;

namespace DMS.Business.DataInterface
{
    public class AdjustBLL
    {
        public void ImportInterfaceAdjustConfirmation(IList<InterfaceAdjustConfirmation> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceAdjustConfirmationDao dao = new InterfaceAdjustConfirmationDao())
                {
                    foreach (InterfaceAdjustConfirmation item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public void ImportInterfaceAdjust(IList<InterfaceAdjust> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceAdjustDao dao = new InterfaceAdjustDao())
                {
                    foreach (InterfaceAdjust item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public IList<LpReturnData> QueryReturnDetailInfoByBatchNbrForLp(string batchNbr)
        {
            using (AdjustInterfaceDao dao = new AdjustInterfaceDao())
            {
                return dao.QueryReturnDetailInfoByBatchNbrForLp(batchNbr);
            }
        }

        public IList<T2ReturnData> QueryReturnDetailInfoByBatchNbrForT2(string batchNbr)
        {
            using (AdjustInterfaceDao dao = new AdjustInterfaceDao())
            {
                return dao.QueryReturnDetailInfoByBatchNbrForT2(batchNbr);
            }
        }


        public int InitAdjustReturnInterfaceForLpByClientID(string clientid, string batchNbr)
        {
            using (AdjustInterfaceDao dao = new AdjustInterfaceDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("Clientid", clientid);
                ht.Add("BatchNbr", batchNbr);
                ht.Add("UpdateDate", DateTime.Now);
                return dao.InitLPReturnByClientID(ht);
            }
        }

        public int InitAdjustReturnInterfaceForT2ByClientID(string clientid, string batchNbr)
        {
            using (AdjustInterfaceDao dao = new AdjustInterfaceDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("Clientid", clientid);
                ht.Add("BatchNbr", batchNbr);
                ht.Add("UpdateDate", DateTime.Now);
                return dao.InitT2ReturnByClientID(ht);
            }
        }


        public bool AfterLpReturnDetailInfoDownload(string BatchNbr, string ClientID, string Success, out string RtnVal)
        {
            bool result = false;

            using (AdjustInterfaceDao dao = new AdjustInterfaceDao())
            {
                dao.AfterDownload(BatchNbr, ClientID, Success, out RtnVal);
                result = true;
            }
            return result;

        }

        public IList<AdjustConfirmation> SelectAdjustConfirmationByBatchNbrErrorOnly(string batchNbr)
        {
            using (AdjustConfirmationDao dao = new AdjustConfirmationDao())
            {
                return dao.SelectAdjustConfirmationByBatchNbrErrorOnly(batchNbr);
            }
        }

        public void HandleAdjustConfirmationData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            using (InterfaceAdjustConfirmationDao dao = new InterfaceAdjustConfirmationDao())
            {
                dao.HandleAdjustConfirmationData(BatchNbr, ClientID, out RtnVal, out RtnMsg);
            }
        }

        public IList<AdjustNote> SelectAdjustNoteByBatchNbrErrorOnly(string batchNbr)
        {
            using (AdjustNoteDao dao = new AdjustNoteDao())
            {
                return dao.SelectAdjustNoteByBatchNbrErrorOnly(batchNbr);
            }
        }

        public void HandleAdjustData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (InterfaceAdjustDao dao = new InterfaceAdjustDao())
            {
                dao.HandleAdjustData(BatchNbr, ClientID, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out RtnVal, out RtnMsg);
            }
        }

        #region 二级经销商退货平台确认接口
        public void ImportInterfaceDealerReturnConfirm(IList<InterfaceDealerReturnConfirm> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceDealerReturnConfirmDao dao = new InterfaceDealerReturnConfirmDao())
                {
                    foreach (InterfaceDealerReturnConfirm item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public void HandleDealerReturnConfirmData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            using (InterfaceDealerReturnConfirmDao dao = new InterfaceDealerReturnConfirmDao())
            {
                dao.HandleDealerReturnConfirmData(BatchNbr, ClientID, out RtnVal, out RtnMsg);
            }
        }

        public IList<InterfaceDealerReturnConfirm> SelectDealerReturnConfirmByBatchNbrErrorOnly(string BatchNbr)
        {
            using (InterfaceDealerReturnConfirmDao dao = new InterfaceDealerReturnConfirmDao())
            {
                return dao.SelectDealerReturnConfirmByBatchNbrErrorOnly(BatchNbr);
            }
        }
        #endregion

        #region added by huyong on 2014-3-28
        public int InitT2CTOSByClientID(string clientid, string batchNbr)
        {
            using (AdjustInterfaceDao dao = new AdjustInterfaceDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("Clientid", clientid);
                ht.Add("BatchNbr", batchNbr);
                ht.Add("UpdateDate", DateTime.Now);
                return dao.InitT2CTOSByClientID(ht);
            }
        }

        public IList<T2ConsignToSellingData> QueryCTOSDetailInfoByBatchNbr(string batchNbr)
        {
            using (AdjustInterfaceDao dao = new AdjustInterfaceDao())
            {
                return dao.QueryCTOSDetailInfoByBatchNbr(batchNbr);
            }
        }

        #endregion

        #region added by huyong on 2016-7-13
        public void ImportInterfaceHospitalTransaction(IList<InterfaceHospitalTransactionWithqr> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceHospitalTransactionWithqrDao dao = new InterfaceHospitalTransactionWithqrDao())
                {
                    foreach (InterfaceHospitalTransactionWithqr item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public void HandleHospitalTransactionData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            using (InterfaceHospitalTransactionWithqrDao dao = new InterfaceHospitalTransactionWithqrDao())
            {
                dao.HandleHospitalTransactionData(BatchNbr, ClientID, out RtnVal, out RtnMsg);
            }
        }

        public IList<InterfaceHospitalTransactionWithqr> SelectHospitalTransactionByBatchNbrErrorOnly(string BatchNbr)
        {
            using (InterfaceHospitalTransactionWithqrDao dao = new InterfaceHospitalTransactionWithqrDao())
            {
                return dao.SelectHospitalTransactionByBatchNbrErrorOnly(BatchNbr);
            }
        }

        public void ImportInterfaceRedCrossHospitalTransaction(IList<InterfaceRedCrossHospitalTransactionWithqr> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceRedCrossHospitalTransactionWithqrDao dao = new InterfaceRedCrossHospitalTransactionWithqrDao())
                {
                    foreach (InterfaceRedCrossHospitalTransactionWithqr item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public void HandleRedCrossHospitalTransactionData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            using (InterfaceRedCrossHospitalTransactionWithqrDao dao = new InterfaceRedCrossHospitalTransactionWithqrDao())
            {
                dao.HandleRedCrossHospitalTransactionData(BatchNbr, ClientID, out RtnVal, out RtnMsg);
            }
        }

        public IList<InterfaceRedCrossHospitalTransactionWithqr> SelectRedCrossHospitalTransactionByBatchNbrErrorOnly(string BatchNbr)
        {
            using (InterfaceRedCrossHospitalTransactionWithqrDao dao = new InterfaceRedCrossHospitalTransactionWithqrDao())
            {
                return dao.SelectRedCrossHospitalTransactionByBatchNbrErrorOnly(BatchNbr);
            }
        }
        #endregion
    }

}
