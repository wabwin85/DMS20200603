using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.Common;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;


namespace DMS.Business
{
    public class DealerOperationLogDLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        /// <summary>
        /// 写日志经销商操作日志
        /// </summary>
        /// <param name="moduleID">模块ID</param>
        public void writeLog(string moduleID)
        {
            writeLog(moduleID, "");
        }

        /// <summary>
        /// 写日志经销商操作日志
        /// </summary>
        /// <param name="moduleID">模块ID</param>
        /// <param name="operType">操作类型</param>
        public void writeLog(string moduleID, string operType)
        {
            try
            {
                if (this._context.User.IdentityType == SR.Consts_System_Dealer_User)
                {
                    using (DealerOperationLogDao dao = new DealerOperationLogDao())
                    {
                        DealerOperationLog log = new DealerOperationLog();
                        log.Id = DMSUtility.GetGuid();
                        log.DealerDmaId = this._context.User.CorpId.Value;
                        log.ModuleId = moduleID;
                        log.OperationDate = DateTime.Now;
                        log.OperationUserId = new Guid(this._context.User.Id);
                        log.OperationType = operType;
                        dao.Insert(log);
                    }
                } else
                {
                    using (DealerOperationLogDao dao = new DealerOperationLogDao())
                    {
                        DealerOperationLog log = new DealerOperationLog();
                        log.Id = DMSUtility.GetGuid();
                        log.DealerDmaId = Guid.Empty;
                        log.ModuleId = moduleID;
                        log.OperationDate = DateTime.Now;
                        log.OperationUserId = new Guid(this._context.User.Id);
                        log.OperationType = operType;
                        dao.Insert(log);
                    }
                }
            }
            finally
            {

            }
        }

        public static DealerOperationLogDLL instance
        {
            get
            {
                return new DealerOperationLogDLL();
            }
        }
    }
}
