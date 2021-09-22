using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using DMS.Model;
using DMS.DataAccess;
using DMS.Common;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;


namespace DMS.Business
{
    public class DealerTrainBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region 培训课程

        public DataTable GetProductLineAreaList(String productLine)
        {
            using (TrainMasterDao dao = new TrainMasterDao())
            {
                return dao.SelectProductLineAreaList(productLine).Tables[0];
            }
        }

        public DataSet GetTrainList(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (TrainMasterDao dao = new TrainMasterDao())
            {
                return dao.SelectTrainMasterList(obj, start, limit, out totalCount);
            }
        }

        public TrainMaster GetTrainInfo(String trainId)
        {
            using (TrainMasterDao dao = new TrainMasterDao())
            {
                return dao.SelectTrainMasterInfo(trainId);
            }
        }

        public IList<TrainDetail> GetTrainDetailListByCondition(TrainDetail obj)
        {
            using (TrainDetailDao dao = new TrainDetailDao())
            {
                return dao.SelectTrainDetailByCondtition(obj);
            }
        }

        public DataSet GetTrainManagerList(String trainId, int start, int limit, out int totalCount)
        {
            using (TrainManagerDao dao = new TrainManagerDao())
            {
                return dao.SelectTrainManagerList(trainId, start, limit, out totalCount);
            }
        }

        public DataSet GetTrainSalesList(String trainId, int start, int limit, out int totalCount)
        {
            using (SalesTrainMasterDao dao = new SalesTrainMasterDao())
            {
                return dao.SelectSalesByTrainId(trainId, start, limit, out totalCount);
            }
        }

        public DataSet GetTrainSalesList(String trainId)
        {
            using (SalesTrainMasterDao dao = new SalesTrainMasterDao())
            {
                return dao.SelectSalesByTrainId(trainId);
            }
        }

        public DataSet GetSalesByTrainIdForTemplate(String trainId)
        {
            using (SalesTrainMasterDao dao = new SalesTrainMasterDao())
            {
                return dao.SelectSalesByTrainIdForTemplate(trainId);
            }
        }

        public DataSet GetRemainManagerList(Hashtable condition, int start, int limit, out int totalCount)
        {
            using (TrainManagerDao dao = new TrainManagerDao())
            {
                return dao.SelectRemainManagerList(condition, start, limit, out totalCount);
            }
        }

        public DataSet GetRemainDealerSalesList(Hashtable condition, int start, int limit, out int totalCount)
        {
            using (DealerSalesDao dao = new DealerSalesDao())
            {
                return dao.SelectRemainDealerSalesList(condition, start, limit, out totalCount);
            }
        }

        public void AddTrainMaster(TrainMaster TrainM)
        {
            using (TrainMasterDao dao = new TrainMasterDao())
            {
                dao.Insert(TrainM);
            }
        }

        public void AddTrainDetail(TrainDetail TrainD)
        {
            using (TrainDetailDao dao = new TrainDetailDao())
            {
                dao.Insert(TrainD);
            }
        }

        public void AddTrainManager(String trainId, String[] managerList, String userId)
        {
            TrainManagerDao trainManagerDao = new TrainManagerDao();
            foreach (String managerId in managerList)
            {
                TrainManager sr = new TrainManager();
                sr.TrainId = new Guid(trainId);
                sr.ManagerId = new Guid(managerId);
                sr.CreateTime = DateTime.Now;
                sr.CreateUser = new Guid(userId);

                trainManagerDao.Insert(sr);
            }
        }

        public int RemoveManager(TrainManager trainManager)
        {
            using (TrainManagerDao dao = new TrainManagerDao())
            {
                return dao.Delete(trainManager);
            }
        }

        public int ModifyTrainMaster(TrainMaster TrainM)
        {
            using (TrainMasterDao dao = new TrainMasterDao())
            {
                return dao.Update(TrainM);
            }
        }

        public int ModifyTrainDetail(TrainDetail TrainD)
        {
            using (TrainDetailDao dao = new TrainDetailDao())
            {
                return dao.Update(TrainD);
            }
        }

        public int ModifyTrainMasterStatus(TrainMaster TrainM)
        {
            using (TrainMasterDao dao = new TrainMasterDao())
            {
                return dao.UpdateTrainMasterStatus(TrainM);
            }
        }

        public int RemoveTrainMasterById(Guid Id)
        {
            using (TrainMasterDao dao = new TrainMasterDao())
            {
                return dao.Delete(Id);
            }
        }

        public int RemoveTrainDetailById(Guid Id)
        {
            using (TrainDetailDao dao = new TrainDetailDao())
            {
                return dao.Delete(Id);
            }
        }

        public int RemoveTrainDetail(TrainDetail Detail)
        {
            using (TrainDetailDao dao = new TrainDetailDao())
            {
                return dao.DeleteByCondition(Detail);
            }
        }

        public DataSet GetDealerTrainDetailList(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (TrainDetailDao dao = new TrainDetailDao())
            {
                return dao.SelectDealerTrainDetailList(obj, start, limit, out totalCount);
            }
        }

        public TrainDetail GetTrainDetailById(Guid id)
        {
            using (TrainDetailDao dao = new TrainDetailDao())
            {
                return dao.GetObject(id);
            }
        }

        public void AddDealerSales(String trainId, String[] dealerSalesList, String userId)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    SalesTrainMasterDao salesTrainMasterDao = new SalesTrainMasterDao();

                    foreach (String dealerSalesId in dealerSalesList)
                    {
                        SalesTrainMaster stCount = new SalesTrainMaster();
                        stCount.TrainId = new Guid(trainId);
                        stCount.DealerSalesId = new Guid(dealerSalesId);

                        if (salesTrainMasterDao.SelectSalesTrainCount(stCount) > 0)
                        {
                            SalesTrainMaster st = new SalesTrainMaster();
                            st.TrainId = new Guid(trainId);
                            st.DealerSalesId = new Guid(dealerSalesId);
                            st.IsActive = true;
                            st.UpdateUser = new Guid(userId);
                            st.UpdateTime = DateTime.Now;
                            salesTrainMasterDao.UpdateSalesTrainActiveByCondition(st);
                        }
                        else
                        {
                            SalesTrainMaster st = new SalesTrainMaster();
                            st.SalesTrainId = Guid.NewGuid();
                            st.TrainId = new Guid(trainId);
                            st.DealerSalesId = new Guid(dealerSalesId);
                            st.SalesTrainStatus = SalesTrainStatus.Unfinish.ToString();
                            st.IsActive = true;
                            st.CreateUser = new Guid(userId);
                            st.CreateTime = DateTime.Now;
                            st.UpdateUser = new Guid(userId);
                            st.UpdateTime = DateTime.Now;
                            st.IsSendRemind = false;
                            salesTrainMasterDao.Insert(st);
                        }

                        Hashtable condition = new Hashtable();
                        condition.Add("UserId", userId);
                        condition.Add("TrainId", trainId);
                        condition.Add("SalesId", dealerSalesId);

                        salesTrainMasterDao.ProcFillOverdueLesson(condition);
                    }

                    trans.Complete();
                }
            }
            catch
            {

            }
        }

        public bool CheckDelaerSalesRecordExists(String salesTrainId)
        {
            using (SalesTrainMasterDao dao = new SalesTrainMasterDao())
            {
                if (dao.SelectDelaerSalesRecordCount(salesTrainId) == 0)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
        }

        public void RemoveDealerSales(String salesTrainId, String userId)
        {
            SalesTrainMasterDao salesTrainMasterDao = new SalesTrainMasterDao();

            SalesTrainMaster st = new SalesTrainMaster();
            st.SalesTrainId = new Guid(salesTrainId);
            st.IsActive = false;
            st.UpdateUser = new Guid(userId);
            st.UpdateTime = DateTime.Now;
            salesTrainMasterDao.UpdateSalesTrainActiveById(st);
        }

        public bool CheckTrainSignExists(String trainId)
        {
            using (SalesTrainMasterDao dao = new SalesTrainMasterDao())
            {
                if (dao.SelectTrainSignCount(trainId) == 0)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
        }

        #endregion

        #region 发送变更提醒

        public void SendClassChangeMail(String mailAddress, String className, String classAddress, String classDate, String classTime)
        {
            IMessageBLL _messageBLL = new MessageBLL();

            MailMessageTemplate mailMessage = _messageBLL.GetMailMessageTemplate("EMAL_DRM_COMMANDO_REMIND_CLASS_CHANGE");

            MailMessageQueue mail = new MailMessageQueue();
            mail.Id = Guid.NewGuid();
            mail.QueueNo = "email";
            mail.From = "";
            mail.To = mailAddress;
            mail.Subject = mailMessage.Subject;
            mail.Body = mailMessage.Body.Replace("{#CLASSNAME}", className).Replace("{#CLASSADDRESS}", classAddress).Replace("{#CLASSDATE}", classDate).Replace("{#CLASSTIME}", classTime);
            mail.Status = "Waiting";
            mail.CreateDate = DateTime.Now;
            _messageBLL.AddToMailMessageQueue(mail);
        }

        public void SendClassChangeMessage(String massageTo, String className, String classAddress, String classDate, String classTime)
        {
            IMessageBLL _messageBLL = new MessageBLL();

            ShortMessageQueue massage = new ShortMessageQueue();
            massage.Id = Guid.NewGuid();
            massage.QueueNo = "sms";
            massage.To = massageTo;
            massage.Message = "您的面授培训课程已变更。课程名称：" + className + "，课程地址：" + classAddress + "，课程日期：" + classDate + "，开始时间：" + classTime + "。请及时调整您的日程并准时参加培训。";
            massage.Status = "Waiting";
            massage.CreateDate = DateTime.Now;
            _messageBLL.AddToShortMessageQueue(massage);
        }

        public void SendOnlineSelfChangeMail(String mailAddress, String onlineSelfName)
        {
            IMessageBLL _messageBLL = new MessageBLL();

            MailMessageTemplate mailMessage = _messageBLL.GetMailMessageTemplate("EMAL_DRM_COMMANDO_REMIND_ONLINE_SELF_CHANGE");

            MailMessageQueue mail = new MailMessageQueue();
            mail.Id = Guid.NewGuid();
            mail.QueueNo = "email";
            mail.From = "";
            mail.To = mailAddress;
            mail.Subject = mailMessage.Subject;
            mail.Body = mailMessage.Body.Replace("{#ONLINESELFNAME}", onlineSelfName);
            mail.Status = "Waiting";
            mail.CreateDate = DateTime.Now;
            _messageBLL.AddToMailMessageQueue(mail);
        }

        public void SendOnlineSelfChangeMessage(String massageTo, String onlineSelfName)
        {
            IMessageBLL _messageBLL = new MessageBLL();

            ShortMessageQueue massage = new ShortMessageQueue();
            massage.Id = Guid.NewGuid();
            massage.QueueNo = "sms";
            massage.To = massageTo;
            massage.Message = "您的在线学习课程已变更。学习名称：" + onlineSelfName + "。";
            massage.Status = "Waiting";
            massage.CreateDate = DateTime.Now;
            _messageBLL.AddToShortMessageQueue(massage);
        }

        public void SendOnlineExamChangeMail(String mailAddress, String onlineExamName)
        {
            IMessageBLL _messageBLL = new MessageBLL();

            MailMessageTemplate mailMessage = _messageBLL.GetMailMessageTemplate("EMAL_DRM_COMMANDO_REMIND_ONLINE_EXAM_CHANGE");

            MailMessageQueue mail = new MailMessageQueue();
            mail.Id = Guid.NewGuid();
            mail.QueueNo = "email";
            mail.From = "";
            mail.To = mailAddress;
            mail.Subject = mailMessage.Subject;
            mail.Body = mailMessage.Body.Replace("{#ONLINEEXAMNAME}", onlineExamName);
            mail.Status = "Waiting";
            mail.CreateDate = DateTime.Now;
            _messageBLL.AddToMailMessageQueue(mail);
        }

        public void SendOnlineExamChangeMessage(String massageTo, String onlineExamName)
        {
            IMessageBLL _messageBLL = new MessageBLL();

            ShortMessageQueue massage = new ShortMessageQueue();
            massage.Id = Guid.NewGuid();
            massage.QueueNo = "sms";
            massage.To = massageTo;
            massage.Message = "您的在线学习课程已变更。考试名称：" + onlineExamName + "。";
            massage.Status = "Waiting";
            massage.CreateDate = DateTime.Now;
            _messageBLL.AddToShortMessageQueue(massage);
        }

        public void SendTrainChangeMail(String mailAddress, String trainName)
        {
            IMessageBLL _messageBLL = new MessageBLL();

            MailMessageTemplate mailMessage = _messageBLL.GetMailMessageTemplate("EMAL_DRM_COMMANDO_REMIND_TRAIN_CHANGE");

            MailMessageQueue mail = new MailMessageQueue();
            mail.Id = Guid.NewGuid();
            mail.QueueNo = "email";
            mail.From = "";
            mail.To = mailAddress;
            mail.Subject = mailMessage.Subject;
            mail.Body = mailMessage.Body.Replace("{#TRAINNAME}", trainName);
            mail.Status = "Waiting";
            mail.CreateDate = DateTime.Now;
            _messageBLL.AddToMailMessageQueue(mail);
        }

        public void SendTrainChangeMessage(String massageTo, String trainName)
        {
            IMessageBLL _messageBLL = new MessageBLL();

            ShortMessageQueue massage = new ShortMessageQueue();
            massage.Id = Guid.NewGuid();
            massage.QueueNo = "sms";
            massage.To = massageTo;
            massage.Message = "您的士兵突击课程（" + trainName + "）已变更。";
            massage.Status = "Waiting";
            massage.CreateDate = DateTime.Now;
            _messageBLL.AddToShortMessageQueue(massage);
        }

        #endregion

        #region 课程成绩导入

        public bool ImportTrainOnlineScore(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    TrainScoreImportDao dao = new TrainScoreImportDao();
                    //删除上传人的数据
                    dao.DeleteTrainScoreImportByUser(_context.User.Id);

                    int lineNbr = 1;
                    IList<TrainScoreImport> list = new List<TrainScoreImport>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        TrainScoreImport data = new TrainScoreImport();
                        data.TrainScoreId = Guid.NewGuid();
                        data.ImportUser = new Guid(_context.User.Id);
                        data.ImportTime = DateTime.Now;
                        data.ImportFileName = fileName;
                        data.ErrorDesc = "";

                        //DealerCode
                        data.DealerCode = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.DealerCode))
                        {
                            data.DealerCodeDesc = "经销商Code为空";
                            data.ErrorDesc += "经销商Code为空;";
                        }

                        //SalesName
                        data.SalesName = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (string.IsNullOrEmpty(data.SalesName))
                        {
                            data.SalesNameDesc = "销售姓名为空";
                            data.ErrorDesc += "销售姓名为空;";
                        }

                        //IsPass
                        data.IsPass = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        if (string.IsNullOrEmpty(data.IsPass))
                        {
                            data.IsPassDesc = "是否通过为空";
                            data.ErrorDesc += "是否通过为空;";
                        }

                        data.LineNum = lineNbr++;

                        data.ErrorFlag = !string.IsNullOrEmpty(data.ErrorDesc);

                        if (data.LineNum != 1)
                        {
                            list.Add(data);
                        }
                    }
                    dao.BatchInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyTrainOnlineScore(String trainId, String classId, out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (TrainScoreImportDao dao = new TrainScoreImportDao())
            {
                IsValid = dao.ProcImportTrainScore(trainId, classId, new Guid(_context.User.Id));
                result = true;
            }
            return result;
        }

        public DataSet GetTrainScoreImportByCondition(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (TrainScoreImportDao dao = new TrainScoreImportDao())
            {
                return dao.SelectTrainScoreImportByCondition(obj, start, limit, out totalCount);
            }
        }

        public void RemoveTrainOnlineScore(String trainScoreId)
        {
            using (TrainScoreImportDao dao = new TrainScoreImportDao())
            {
                dao.Delete(trainScoreId);
            }
        }

        public void ModifyTrainOnlineScore(TrainScoreImport TrainScoreImport)
        {
            using (TrainScoreImportDao dao = new TrainScoreImportDao())
            {
                dao.UpdateTrainScoreImportForEdit(TrainScoreImport);
            }
        }

        #endregion
    }
}
