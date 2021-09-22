using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

using Coolite.Ext.Web;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using Grapecity.Logging.CallHandlers;

using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;

namespace DMS.Business
{

    public class BulletinManageBLL : IBulletinManageBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region Action Define
        public const string Action_BulletinManage = "BulletinManage";
        #endregion

        [AuthenticateHandler(ActionName = Action_BulletinManage, Description = "经销商通知和公告维护", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_BulletinManage, Title = "公告维护", Message = "保存公告信息", Categories = new string[] { Data.DMSLogging.BulletinCategory })]
        public bool SaveBulletinSet(ChangeRecords<BulletinDetail> data, BulletinMain main)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                //更新主表信息
                this.DeleteBulletinMain(main.Id);

                main.UpdateUser = new Guid(_context.User.Id);
                main.UpdateDate = DateTime.Now;

                this.InsertBulletinMain(main);

                //更新明细表信息
                foreach (BulletinDetail detail in data.Deleted)
                {
                    this.DeleteBulletinDetail(detail.Id);
                }
                foreach (BulletinDetail detail in data.Updated)
                {
                    detail.BumId = main.Id;
                    this.UpdateBulletinDetail(detail);
                }
                foreach (BulletinDetail detail in data.Created)
                {
                    detail.BumId = main.Id;
                    this.InsertBulletinDetail(detail);
                }
                trans.Complete();
                result = true;
            }

            return result;
        }

        [AuthenticateHandler(ActionName = Action_BulletinManage, Description = "经销商通知和公告维护", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_BulletinManage, Title = "公告维护", Message = "保存公告信息", Categories = new string[] { Data.DMSLogging.BulletinCategory })]
        public bool SaveBulletinSet(BulletinMain main,IList<BulletinDetail> list)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                ////更新主表和明细表信息
                //this.DeleteBulletinByMainId(main.Id);
                this.DeleteBulletinMain(main.Id);

                main.UpdateUser = new Guid(_context.User.Id);
                main.UpdateDate = DateTime.Now;
                
                this.InsertBulletinMain(main);

                foreach (BulletinDetail detail in list)
                {
                    this.InsertBulletinDetail(detail);
                }

                trans.Complete();
                result = true;
            }

            return result;
        }

        [AuthenticateHandler(ActionName = Action_BulletinManage, Description = "经销商通知和公告维护", Permissoin = PermissionType.Read)]
        public DataSet QuerySelectMainByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (BulletinMainDao dao = new BulletinMainDao())
            {

                return dao.QuerySelectByFile(table, start, limit, out totalRowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_BulletinManage, Description = "经销商通知和公告维护", Permissoin = PermissionType.Read)]
        public DataSet QuerySelectDetailByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (BulletinDetailDao dao = new BulletinDetailDao())
            {

                return dao.QuerySelectByFile(table, start, limit, out totalRowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_BulletinManage, Description = "经销商通知和公告维护", Permissoin = PermissionType.Read)]
        public BulletinMain GetObjectById(Guid MainID)
        {
            using (BulletinMainDao dao = new BulletinMainDao())
            {
                return dao.GetObject(MainID);
            }
        }

        [AuthenticateHandler(ActionName = Action_BulletinManage, Description = "经销商通知和公告维护", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_BulletinManage, Title = "公告维护", Message = "删除公告信息", Categories = new string[] { Data.DMSLogging.BulletinCategory })]
        public bool DeleteDraft(Guid MainId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                using(BulletinDetailDao DetailDao = new BulletinDetailDao())
                {
                    using(BulletinMainDao MainDao = new BulletinMainDao())
                    {
                        MainDao.Delete(MainId);
                        DetailDao.DeleteByMainId(MainId);

                        trans.Complete();
                        result = true;
                    }
                }

            }

            return result;
        }

        [AuthenticateHandler(ActionName = Action_BulletinManage, Description = "经销商通知和公告维护", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_BulletinManage, Title = "公告维护", Message = "作废公告信息", Categories = new string[] { Data.DMSLogging.BulletinCategory })]
        public bool CancelledItem(Guid MainId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                using(BulletinMainDao dao = new BulletinMainDao())
                {
                    BulletinMain main = dao.GetObject(MainId);
                    
                    main.Status = BulletinStatus.Cancelled.ToString();

                    int num = dao.UpdateStatus(main);

                    trans.Complete();
                    result = true;
                }
            }

            return result;
        }

        [AuthenticateHandler(ActionName = Action_BulletinManage, Description = "经销商通知和公告维护", Permissoin = PermissionType.Read)]
        public IList<BulletinDetail> QuerySelectDetailByFilter(Hashtable table)
        {
            using (BulletinDetailDao dao = new BulletinDetailDao())
            {

                return dao.QuerySelectByFile(table);
            }
        }

        #region Insert、Update、Delete

        public void InsertBulletinDetail(BulletinDetail detail)
        {
            using (BulletinDetailDao DetailDao = new BulletinDetailDao())
            {
                DetailDao.Insert(detail);
            }
        }

        public void UpdateBulletinDetail(BulletinDetail detail)
        {
            using (BulletinDetailDao DetailDao = new BulletinDetailDao())
            {
                DetailDao.Update(detail);
            }

        }

        public void DeleteBulletinDetail(Guid detailId)
        {
            using (BulletinDetailDao DetailDao = new BulletinDetailDao())
            {
                DetailDao.Delete(detailId);
            }
        }

        public void DeleteBulletinByMainId(Guid mainId)
        {
            using (BulletinDetailDao DetailDao = new BulletinDetailDao())
            {
                DetailDao.DeleteByMainId(mainId);
            }
        }

        public void DeleteBulletinMain(Guid mainId)
        {
            using (BulletinMainDao MainDao = new BulletinMainDao())
            {
                MainDao.Delete(mainId);
            }
        }

        public void InsertBulletinMain(BulletinMain main)
        { 
            using(BulletinMainDao MainDao = new BulletinMainDao())
            {
                MainDao.Insert(main);
            }
        }

        public void UpdateBulletinMain(BulletinMain main)
        { 
            using(BulletinMainDao MainDao = new BulletinMainDao())
            {
                MainDao.Update(main);
            }
        }


        public bool deatil(Guid id)
        {
            bool result = false;
            using (BulletinDetailDao DetailDao = new BulletinDetailDao())
            {
                DetailDao.Deletet(id);
                result = true;
            }
            return result;
        }

        public bool Updatemain(BulletinMain main)
        {
            bool result = false;
            using (BulletinMainDao dao = new BulletinMainDao())
            {
                 dao.Update(main);
               
                result = true;
            }
            return result;
        }
        public void insertmain(Hashtable obj)
        {

            using (BulletinMainDao dao = new BulletinMainDao())
            {
                dao.Insertmain(obj);

            }
            
        }

        public void InsertDetail(IList<BulletinDetail> list)
        {
            foreach (BulletinDetail detail in list)
            {
                this.InsertBulletinDetail(detail);
            }
        }




        #endregion

    }
}
