using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using DMS.Model;
    using DMS.DataAccess;
    using DMS.Common;
    using System.Collections;
    using Grapecity.DataAccess.Transaction;
    using Lafite.RoleModel.Security.Authorization;
    using Grapecity.Logging.CallHandlers;

    public class DealerRelationBLL: IDealerRelationBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region Action Define
        public const string Action_DealerRelation = "DealerRelation";
        #endregion

        [AuthenticateHandler(ActionName = Action_DealerRelation, Description = "经销商关联", Permissoin = PermissionType.Read)]
        public IList<DealerRelation> SelectByFilter(DealerRelation obj, int start, int limit, out int totalRowCount)
        {
            using (DealerRelationDao dao = new DealerRelationDao())
            {
                return dao.SelectByFilter( obj, start, limit, out totalRowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerRelation, Description = "经销商关联", Permissoin = PermissionType.Read)]
        public DealerRelation GetObject(Guid objKey)
        {
            using (DealerRelationDao dao = new DealerRelationDao())
            {
                return dao.GetObject(objKey);
            }
        }

        public bool Verify(DealerRelation obj)
        {
            bool reslut = false;

            using (DealerRelationDao dao = new DealerRelationDao())
            {
                if (dao.SelectByFilterVerify(obj).Count > 0)
                reslut = true;
            }

            return reslut;
        }

        [AuthenticateHandler(ActionName = Action_DealerRelation, Description = "经销商关联", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_DealerRelation, Title = "经销商关联", Message = "新增经销商关联", Categories = new string[] { Data.DMSLogging.DealerRelationCategory })]
        public bool Insert(DealerRelation obj)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                using (DealerRelationDao dao = new DealerRelationDao())
                {
                    obj.Id = Guid.NewGuid();

                    obj.UpdateDate = DateTime.Now;
                    obj.UpdateUser = new Guid(_context.User.Id);

                    obj.CreateDate = obj.UpdateDate;
                    obj.CreateUser = obj.UpdateUser;

                    dao.Insert(obj);
                }
                trans.Complete();

                result = true;
            }

            return result;
        }

        [AuthenticateHandler(ActionName = Action_DealerRelation, Description = "经销商关联", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_DealerRelation, Title = "经销商关联", Message = "新增经销商关联", Categories = new string[] { Data.DMSLogging.DealerRelationCategory })]
        public bool Save(DealerRelation obj)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                using (DealerRelationDao dao = new DealerRelationDao())
                {
                    if (obj.Id == Guid.Empty)
                    {
                        this.Insert(obj);
                    }
                    else
                    {
                        if (this.Delete(obj.Id))
                        {
                            obj.UpdateDate = DateTime.Now;
                            obj.UpdateUser = new Guid(_context.User.Id);

                            dao.Insert(obj);
                        }
                    }
                }
                trans.Complete();

                result = true;
            }

            return result;
        }

        [AuthenticateHandler(ActionName = Action_DealerRelation, Description = "经销商关联", Permissoin = PermissionType.Delete)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_DealerRelation, Title = "经销商关联", Message = "删除经销商关联", Categories = new string[] { Data.DMSLogging.DealerRelationCategory })]
        public bool Delete(Guid id)
        {
            bool result = false;

            int num = 0;
            using (TransactionScope trans = new TransactionScope())
            {
                using (DealerRelationDao dao = new DealerRelationDao())
                {
                    num = dao.Delete(id);
                }
                trans.Complete();

                result = true;
            }

            return result;
        }

    }
}
