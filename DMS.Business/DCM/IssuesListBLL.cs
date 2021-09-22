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


namespace DMS.Business
{
    public class IssuesListBLL : IIssuesListBLL
    {

        #region Action Define
        public const string Action_IssuesList = "IssuesList";
        #endregion

        [AuthenticateHandler(ActionName = Action_IssuesList, Description = "经销商政策", Permissoin = PermissionType.Read)]
        public DataSet QuerySelectIssuesList(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (IssuesListDao dao = new IssuesListDao())
            {
                return dao.QuerySelectByFile(table, start, limit, out totalRowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_IssuesList, Description = "经销商政策", Permissoin = PermissionType.Read)]
        public IssuesList GetObject(Guid id)
        { 
            using(IssuesListDao dao = new IssuesListDao())
            {
                return dao.GetObject(id);
            }
        }

        [AuthenticateHandler(ActionName = Action_IssuesList, Description = "经销商政策", Permissoin = PermissionType.Read)]
        public bool VerifySortNo(string SortNo)
        {
            using (IssuesListDao dao = new IssuesListDao())
            {
                IssuesList issues = dao.VerifySortNo(SortNo);

                if (issues == null)
                    return false;
                else
                    return true;
            }
        }

        public int getMaxSortNo()
        {
            using (IssuesListDao dao = new IssuesListDao())
            {
                return dao.getMaxSortNo();
            }
        }

        [AuthenticateHandler(ActionName = Action_IssuesList, Description = "经销商政策", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_IssuesList, Title = "经销商政策", Message = "新增常见问题", Categories = new string[] { Data.DMSLogging.IssuesListCategory })]
        public bool SaveIssues(IssuesList issues)
        {
            bool result = false;

            using(TransactionScope trans = new TransactionScope())
            {
                using(IssuesListDao dao = new IssuesListDao())
                {
                    dao.Delete(issues.Id);

                    dao.Insert(issues);

                    trans.Complete();
                    result = true;
                }
            }

            return result;
        }

        [AuthenticateHandler(ActionName = Action_IssuesList, Description = "经销商政策", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_IssuesList, Title = "经销商政策", Message = "删除常见问题", Categories = new string[] { Data.DMSLogging.IssuesListCategory })]
        public bool DeleteIssues(Guid id)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                using (IssuesListDao dao = new IssuesListDao())
                {
                    dao.FakeDelete(id);

                    trans.Complete();
                    result = true;
                }
            }

            return result;
        }

        public DataSet QueryTopTenIssuesListOnLogin(Hashtable table)
        {
            using (IssuesListDao dao = new IssuesListDao())
            {
                return dao.QueryTopTenIssuesListOnLogin(table);
            }
        }
    }
}
