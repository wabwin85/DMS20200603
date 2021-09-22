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
using Lafite.RoleModel.Security.Authorization;
using Grapecity.Logging.CallHandlers;

namespace DMS.Business
{
    using Lafite.RoleModel.Security;

    public class BulletinSearchBLL : IBulletinSearchBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region Action Define
        public const string Action_BulletinSearch = "BulletinSearch";
        #endregion

        [AuthenticateHandler(ActionName = Action_BulletinSearch, Description = "经销商通知和公告查询", Permissoin = PermissionType.Read)]
        public DataSet QuerySelectMainByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (BulletinMainDao dao = new BulletinMainDao())
            {
                return dao.QuerySelectByFileOfSearch(table, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryTopTenBulletinMainOnLogin(Hashtable table)
        {
            using (BulletinMainDao dao = new BulletinMainDao())
            {
                return dao.QueryTopTenBulletinMainOnLogin(table);
            }
        }

        [AuthenticateHandler(ActionName = Action_BulletinSearch, Description = "经销商通知和公告查询", Permissoin = PermissionType.Read)]
        public DataSet GetBulletinMainById(Hashtable table)
        {
            using (BulletinMainDao dao = new BulletinMainDao())
            {
                return dao.GetBulletinMainById(table);
            }
        }

        public DataSet GetBulletinMainUsedBySynthesHome(Hashtable table)
        {
            using (BulletinMainDao dao = new BulletinMainDao())
            {
                return dao.GetBulletinMainUsedBySynthesHome(table);
            }
        }

        [AuthenticateHandler(ActionName = Action_BulletinSearch, Description = "经销商通知和公告查询", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_BulletinSearch, Title = "公告查询", Message = "更改公告信息状态", Categories = new string[] { Data.DMSLogging.BulletinSearchCategory })]
        public bool UpdateRead(Hashtable table)
        {
            bool result = false;
            using (BulletinDetailDao dao = new BulletinDetailDao())
            {
                int num = dao.UpdateRead(table);
                if (num > 0)
                    result = true;
            }
            return result;
        }

        [AuthenticateHandler(ActionName = Action_BulletinSearch, Description = "经销商通知和公告查询", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_BulletinSearch, Title = "公告查询", Message = "更改公告信息状态", Categories = new string[] { Data.DMSLogging.BulletinSearchCategory })]
        public bool UpdateConfirm(Hashtable table)
        {
            bool result = false;
            using (BulletinDetailDao dao = new BulletinDetailDao())
            {
                int num = dao.UpdateConfirm(table);
                if (num > 0)
                    result = true;
            }
            return result;
        }

    }
}
