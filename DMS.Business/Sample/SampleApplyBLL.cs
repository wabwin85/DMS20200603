using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using System.IO;
using DMS.Business.MasterData;
using DMS.Model.DataInterface.eWorkflow;
using DMS.Common.Common;

namespace DMS.Business
{
    public class SampleApplyBLL
    {
        private IClientBLL _clientBLL = new ClientBLL();
        public DataSet GetSampleApplyList(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                DataSet ds = dao.SelectSampleApplyList(table, start, limit, out totalRowCount);
                return ds;
            }

        }
        public SampleApplyHead GetSampleApplyHeadById(Guid Id)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                SampleApplyHead Head = dao.GetObject(Id);
                return Head;
            }
        }
        public DataSet GetSampleUpnList(Guid HeadId)
        {
            using (SampleUpnDao dao = new SampleUpnDao())
            {
                DataSet ds = dao.SelectSampleUpnList(HeadId);
                return ds;
            }
        }
        public DataSet GetOperLogList(Guid id)
        {
            Hashtable table = new Hashtable();
            table.Add("EscId", id);

            using (ScoreCardLogDao dao = new ScoreCardLogDao())
            {
                return dao.QueryScoreCardLogByFilter(table);
            }
        }
        public IList<SampleTesting> GetSampleTestingList(Guid HeadId)
        {
            using (SampleTestingDao dao = new SampleTestingDao())
            {
                return dao.SelectSampleTestingList(HeadId);
            }
        }
        public DataTable GetSampleDeliveryList(String sampleNo)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                return dao.SelectSampleDeliveryList(sampleNo);
            }
        }
        public DataTable GetSampleRemainList(string HeadId, string UpnId)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("HeadId", HeadId);
                ht.Add("UpnId", UpnId);
                return dao.SelectSampleRemainList(ht);
            }
        }
        public DataSet GetSampleReturnList(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (SampleReturnHeadDao dao = new SampleReturnHeadDao())
            {
                return dao.SelectSampleReturnList(table, start, limit, out totalRowCount);
            }
        }
        public SampleReturnHead GetSampleRetrunHeadById(Guid Id)
        {
            using (SampleReturnHeadDao dao = new SampleReturnHeadDao())
            {
                return dao.GetObject(Id);
            }
        }

        public SampleApplyHead GetSampleApplyHeadByApplyNo(String applyNo)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                return dao.SelectSampleApplyHeadByApplyNo(applyNo);
            }
        }

        public SampleReturnHead GetSampleReturnHeadByReturnNo(String returnNo)
        {
            using (SampleReturnHeadDao dao = new SampleReturnHeadDao())
            {
                return dao.SelectSampleReturnHeadByReturnNo(returnNo);
            }
        }

        public void CreateSampleApply(SampleApplyHead applyHead, IList<SampleUpn> upnList, IList<SampleTesting> testingList)
        {
            using (TransactionScope trans = new TransactionScope())
            {

                SampleApplyHeadDao sampleApplyHeadDao = new SampleApplyHeadDao();
                SampleUpnDao sampleUpnDao = new SampleUpnDao();
                SampleTestingDao sampleTestingDao = new SampleTestingDao();
                SampleSyncStackDao sampleSyncStackDao = new SampleSyncStackDao();

                sampleApplyHeadDao.Insert(applyHead);
                foreach (SampleUpn upn in upnList)
                {
                    sampleUpnDao.Insert(upn);
                }
                foreach (SampleTesting testing in testingList)
                {
                    sampleTestingDao.Insert(testing);
                }

                //生成接口XML
                //BaseRequestData data = new BaseRequestData { FlowId = "1257", IgnoreAlarm = "1", Initiator = applyHead.ApplyUserId, ApproveSelect = "", Principal = "" };
                BaseRequestData data = new BaseRequestData { FlowId = "1834", IgnoreAlarm = "1", Initiator = applyHead.ApplyUserId, ApproveSelect = "", Principal = "" };
                data.Tables = new List<BaseRequestTable>();

                BaseRequestTable headerTable = new BaseRequestTable { Name = "BIZ_SAMPLE_NEWMAIN" };
                headerTable.Rows = new List<BaseRequestTableRow>();

                SampleApplyHeaderRow headerRow = new SampleApplyHeaderRow();
                headerRow.Index = "1";
                headerRow.EID = applyHead.ApplyUserId;
                headerRow.DEPID = "";
                headerRow.SAMPLETYPE = "2";
                headerRow.PURPOSETYPE = "";
                headerRow.TOTALAMOUNTUSD = this.GetTotalAmountUsdBySamplyApplyId(applyHead.SampleApplyHeadId).ToString();
                headerRow.XML = sampleApplyHeadDao.FuncGetSampleApplyHtml(applyHead.SampleApplyHeadId);
                headerRow.HOSTIPAL = "";

                if (testingList.Count > 0)
                    headerRow.REGTYPE = testingList[0].Certificate;

                headerRow.DMSNO = applyHead.ApplyNo;
                headerTable.Rows.Add(headerRow);

                BaseRequestTable detailTable = new BaseRequestTable { Name = "BIZ_SAMPLE_NEWUPN" };
                detailTable.Rows = new List<BaseRequestTableRow>();

                int index = 1;
                foreach (SampleUpn upn in upnList)
                {
                    detailTable.Rows.Add(new SampleApplyDetailRow { Index = index.ToString(), UPN = upn.UpnNo });
                    index++;
                }

                data.Tables.Add(headerTable);
                data.Tables.Add(detailTable);

                SampleSyncStack sss = new SampleSyncStack();
                sss.SampleHeadId = applyHead.SampleApplyHeadId;
                sss.ApplyType = "申请单";
                sss.SampleType = applyHead.SampleType;
                sss.SyncType = "单据创建";
                sss.SampleNo = applyHead.ApplyNo;
                sss.ApplyUserId = applyHead.ProcessUserId;
                //生成接口XML
                sss.SyncContent = XmlHelper.Serialize<BaseRequestData>(data, Encoding.UTF8);
                sss.SyncStatus = "Wait";
                sss.SyncErrCount = 0;
                sss.SyncMsg = "";
                sss.CreateDate = DateTime.Now;
                sampleSyncStackDao.Insert(sss);

                //检查UPN是否存在，不存在则从interface.T_I_QV_CFN去取，若interface.T_I_QV_CFN中不存在，则直接新增到CFN和Product表
                sampleApplyHeadDao.CheckUPN(applyHead.SampleApplyHeadId);

                trans.Complete();

            }
        }

        public void CreateSampleReturn(SampleReturnHead applyHead, IList<SampleUpn> upnList)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                SampleReturnHeadDao sampleReturnHeadDao = new SampleReturnHeadDao();
                SampleUpnDao sampleUpnDao = new SampleUpnDao();
                SampleSyncStackDao sampleSyncStackDao = new SampleSyncStackDao();

                sampleReturnHeadDao.Insert(applyHead);
                foreach (SampleUpn upn in upnList)
                {
                    sampleUpnDao.Insert(upn);
                }

                //生成接口XML
                //BaseRequestData data = new BaseRequestData { FlowId = "1258", IgnoreAlarm = "1", Initiator = applyHead.ReturnUserId, ApproveSelect = "", Principal = "" };
                BaseRequestData data = new BaseRequestData { FlowId = "1835", IgnoreAlarm = "1", Initiator = applyHead.ReturnUserId, ApproveSelect = "", Principal = "" };
                data.Tables = new List<BaseRequestTable>();

                BaseRequestTable headerTable = new BaseRequestTable { Name = "BIZ_RETURNSAMPLE_MAIN" };
                headerTable.Rows = new List<BaseRequestTableRow>();

                SampleReturnHeaderRow headerRow = new SampleReturnHeaderRow();
                headerRow.Index = "1";
                headerRow.EID = applyHead.ReturnUserId;
                headerRow.DEPID = "";
                headerRow.SAMPLETYPE = "2";
                headerRow.XML = sampleReturnHeadDao.FuncGetSampleReturnHtml(applyHead.SampleReturnHeadId);
                headerRow.DMSNO = applyHead.ReturnNo;
                headerTable.Rows.Add(headerRow);

                data.Tables.Add(headerTable);

                SampleSyncStack sss = new SampleSyncStack();
                sss.SampleHeadId = applyHead.SampleReturnHeadId;
                sss.ApplyType = "退货单";
                sss.SampleType = applyHead.SampleType;
                sss.SyncType = "单据创建";
                sss.SampleNo = applyHead.ReturnNo;
                sss.ApplyUserId = applyHead.ProcessUserId;
                //生成接口XML
                sss.SyncContent = XmlHelper.Serialize<BaseRequestData>(data, Encoding.UTF8);
                sss.SyncStatus = "Wait";
                sss.SyncErrCount = 0;
                sss.SyncMsg = "";
                sss.CreateDate = DateTime.Now;
                sampleSyncStackDao.Insert(sss);

                trans.Complete();
            }
        }

        public DataTable GetSampleApplyDelivery(String applyNo, String deliveryNo)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                Hashtable condition = new Hashtable();
                condition.Add("ApplyNo", applyNo);
                condition.Add("DeliveryNo", deliveryNo);
                return dao.SelectSampleApplyDelivery(condition);
            }
        }

        public void ReceiveSample(String deliveryNo)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                Hashtable condition = new Hashtable();
                condition.Add("DeliveryNo", deliveryNo);
                dao.UpdateSampleApplyDeliveryStatus(condition);
            }
        }

        public void CreateSampleEval(IList<SampleEval> evalList)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                SampleEvalDao sampleEvalDao = new SampleEvalDao();

                foreach (SampleEval eval in evalList)
                {
                    sampleEvalDao.Insert(eval);
                }

                trans.Complete();
            }
        }

        public void CreateDpDelivery(Hashtable condition)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                dao.ProcSaveDpDelivery(condition);
            }
        }

        public DataTable GetSampleTrace(Guid applyId)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                return dao.SelectSampleTrace(applyId);
            }
        }

        public void ModifyDeliveryStatus(Hashtable condition)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                dao.UpdateDeliveryStatus(condition);
            }
        }

        public void ReceiveReturnSample(Hashtable condition)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                dao.ProcReceiveReturnSample(condition);
            }
        }

        public DataSet GetSampleEvalListByCondition(Guid headerId, string Upn, string Lot)
        {
            using (SampleEvalDao dao = new SampleEvalDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("SampleHeadId", headerId);
                ht.Add("UpnNo", Upn);
                ht.Add("Lot", Lot);
                return dao.GetSampleEvalListByCondition(ht);
            }
        }


        #region added by bozhenfei on 2016-08-11
        /// <summary>
        /// 判断样品申请单是否为新证
        /// </summary>
        /// <param name="HeadId"></param>
        /// <returns></returns>
        public bool IsNewCertificate(Guid HeadId)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                return dao.IsNewCertificate(HeadId);
            }
        }

        public decimal GetTotalAmountUsdBySamplyApplyId(Guid id)
        {
            using (SampleUpnDao dao = new SampleUpnDao())
            {
                DataSet ds = dao.GetTotalAmountUsdBySamplyApplyId(id);
                if (ds != null && ds.Tables != null & ds.Tables[0].Rows.Count > 0)
                    return Convert.ToDecimal(ds.Tables[0].Rows[0][0]);
                return 0;
            }
        }

        public void CheckUPN(Guid HeadId)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                dao.CheckUPN(HeadId);
            }
        }
        #endregion

        #region 
        public void ApproveSampleClin(Guid HeadId)
        {
            //更新样品单据状态
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                SampleApplyHead Head = dao.GetObject(HeadId);

                Head.ApplyStatus = "Complete";

                dao.Update(Head);

                //生成订单
                dao.CreatePurchaseOrderHeaderBySampleID(HeadId);
                dao.CreatePurchaseOrderDetailBySampleID(HeadId);
                //写入接口
                using (PurchaseOrderInterfaceDao pdao = new PurchaseOrderInterfaceDao())
                {
                    PurchaseOrderInterface inter = new PurchaseOrderInterface();
                    inter.Id = Guid.NewGuid();
                    inter.BatchNbr = String.Empty;
                    inter.RecordNbr = String.Empty;
                    inter.PohId = HeadId;
                    inter.PohOrderNo = Head.ApplyNo;
                    inter.Status = PurchaseOrderMakeStatus.Pending.ToString();
                    inter.ProcessType = PurchaseOrderCreateType.Manual.ToString();
                    inter.CreateUser = new Guid("12B2B080-E1E3-432C-BDF5-2CA03BCBA662");
                    inter.CreateDate = DateTime.Now;
                    inter.UpdateUser = new Guid("12B2B080-E1E3-432C-BDF5-2CA03BCBA662");
                    inter.UpdateDate = DateTime.Now;
                    inter.Clientid = "EAI";
                    pdao.Insert(inter);
                }
            }
        }
        #endregion

        public DataSet GetUserAccountByEID(string eid)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                return dao.GetUserAccountByEID(eid);
            }
        }
        //获取要商业样品的
        public DataSet GetSampleLimitApply(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                return dao.GetSampleLimitApply(table, start, limit, out totalRowCount);
            }

        }

        public DataSet GetSampleLimitcode(string ProductLine)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                return dao.GetSampleLimitcode(ProductLine);
            }
        }

        public bool InsertSampleApplyLimit(Hashtable obj)
        {
            bool relult = false;
            try
            {
                using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
                {
                    dao.InsertSampleApplyLimit(obj);
                    relult = true;
                }

            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);

            }
            return relult;
        }

        public bool UpdateSampleApplyLimit(string id, string Limit)
        {
            bool relult = false;
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("id", id);
                ht.Add("Limit", Limit);
                dao.UpdateSampleApplyLimit(ht);
                relult = true;
            }
            return relult;
        }

        public void InsertUserLog(Hashtable hs)
        {
            using (SampleApplyHeadDao dao = new SampleApplyHeadDao())
            {
                dao.InsertUserLog(hs);
            }
        }
    }
}
