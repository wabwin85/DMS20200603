using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Coolite.Ext.Web;
using DMS.Model.Data;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using Grapecity.Logging.CallHandlers;
using Lafite.RoleModel.Domain;

namespace DMS.Business
{
    public class DealerQABLL : IDealerQABLL
    {
        #region Action Define
        private IRoleModelContext _context = RoleModelContext.Current;
        public const string Action_DealerQA = "DealerQA";
        #endregion

        [AuthenticateHandler(ActionName = Action_DealerQA, Description = "经销商问答", Permissoin = PermissionType.Read)]
        public DataSet QuerySelectDealerQAByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (DealerqaDao dao = new DealerqaDao())
            {
                return dao.QuerySelectByFile(table, start, limit, out totalRowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerQA, Description = "经销商问答", Permissoin = PermissionType.Read)]
        public DataSet QuerySelectDealerQAByFilterForDealer(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (DealerqaDao dao = new DealerqaDao())
            {
                return dao.QuerySelectByFileForDealer(table, start, limit, out totalRowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerQA, Description = "经销商问答", Permissoin = PermissionType.Read)]
        public Dealerqa GetObject(Guid id)
        {
            using (DealerqaDao dao = new DealerqaDao())
            {
                return dao.GetObject(id);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerQA, Description = "经销商问答", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_DealerQA, Title = "经销商问答", Message = "新增提问", Categories = new string[] { Data.DMSLogging.DealerQACategory })]
        public bool InsertQuestionInfo(Dealerqa table, string hostUrl)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                using (DealerqaDao dao = new DealerqaDao())
                {
                    dao.Delete(new Guid(table.Id.ToString()));

                    dao.InsertQuestion(table);

                    if (table.Category == ((int)DealerQACategory.Complaint).ToString() && table.Status == DealerComplaintStatus.Submitted.ToString())
                    {
                        DictionaryDomain dictDomain = new DictionaryDomain();
                        dictDomain.DictType = SR.Consts_DealerComplaint_Type;
                        dictDomain.DictKey = table.Type;
                        IList<DictionaryDomain> dictList = DictionaryHelper.GetDomainListByFilter(dictDomain);
                        //Value3有值新增消息列队到临时表
                        if (dictList != null && dictList.Count > 0 && !string.IsNullOrEmpty(dictList.First<DictionaryDomain>().Value3))
                        {
                            MessageBLL msgBll = new MessageBLL();
                            //邮件
                            Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                            Dictionary<String, String> dictMailBody = new Dictionary<String, String>();
                            dictMailSubject.Add("Distributor", this._context.User.CorpName);
                            dictMailSubject.Add("ComplaintTitle", table.Title);

                            dictMailBody.Add("Distributor", this._context.User.CorpName);
                            dictMailBody.Add("ApplyDate", table.QuestionDate.GetDateTimeFormats('D')[3].ToString());
                            dictMailBody.Add("ComplaintTitle", table.Title);

                            //string url = AppSettings.HostUrl.Replace(AppSettings.HostQuery, "").Replace(AppSettings.HostAbsolute, "");// Replace(HttpContext.Current.Request.Url.Query, "").Replace(HttpContext.Current.Request.Url.AbsolutePath, "");
                            dictMailBody.Add("Url", hostUrl);

                            msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_DEALER_COMPLAINT, dictMailSubject, dictMailBody, dictList.First<DictionaryDomain>().Value3);
                        }
                    }

                    trans.Complete();
                    result = true;
                }
            }
            return result;
        }

        [AuthenticateHandler(ActionName = Action_DealerQA, Description = "经销商问答", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_DealerQA, Title = "经销商问答", Message = "新增回答", Categories = new string[] { Data.DMSLogging.DealerQACategory })]
        public bool InsertAnswer(Dealerqa table)
        {
            bool result = false;
            using (DealerqaDao dao = new DealerqaDao())
            {
                int num = dao.UpdateAnswer(table);
                if (num > 0)
                    result = true;
            }
            return result;
        }

        [AuthenticateHandler(ActionName = Action_DealerQA, Description = "经销商问答", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_DealerQA, Title = "经销商问答", Message = "删除提问", Categories = new string[] { Data.DMSLogging.DealerQACategory })]
        public bool DeleteItem(Guid id)
        {
            bool result = false;
            using (DealerqaDao dao = new DealerqaDao())
            {
                int num = dao.Delete(id);
                if (num > 0)
                    result = true;
            }
            return result;
        }

        public int GetConutByStatus(Hashtable table)
        { 
            using(DealerqaDao dao = new DealerqaDao())
            {
                return dao.GetConutByStatus(table);
            }
        }

        public DataSet QueryDealerQAOnLogin(Hashtable table)
        {
            using (DealerqaDao dao = new DealerqaDao())
            {
                return dao.QueryDealerQAOnLogin(table);
            }
        }

        public DataSet QueryDealerQAOnLoginForDealer(Hashtable table)
        {
            using (DealerqaDao dao = new DealerqaDao())
            {
                return dao.QueryDealerQAOnLoginForDealer(table);
            }
        }
        
        //Added By Song Yuqi 0n 2013-9-12 For Wait For Porcess Begin
        public IList<WaitProcessTask> QueryWaitForProcessByDealer(Hashtable table)
        {
            using (DealerqaDao dao = new DealerqaDao())
            {
                return dao.QueryWaitForProcessByDealer(table);
            }
        }
        //Added By Song Yuqi 0n 2013-9-12 End
    }
}
