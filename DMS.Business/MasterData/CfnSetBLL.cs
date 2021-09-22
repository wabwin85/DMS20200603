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
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using Grapecity.Logging.CallHandlers;

namespace DMS.Business
{
    using Lafite.RoleModel.Security;
    using DMS.Model.Data;


    public class CfnSetBLL : ICfnSetBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;


        #region Action Define
        public const string Action_CFNSet = "CFNSet";
        #endregion

        /// <summary>
        /// 寄售成套产品信息查询，带分页
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>        
        [AuthenticateHandler(ActionName = Action_CFNSet, Description = "成套产品维护", Permissoin = PermissionType.Read)]
        public DataSet QueryDataByFilterConsignmentCfnSet(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (CfnSetDao dao = new CfnSetDao())
            {
                BaseService.AddCommonFilterCondition(table);
                return dao.QueryDataByFilterConsignmentCfnSet(table, start, limit, out totalRowCount);
            }
        }
        /// <summary>
        /// 成套产品信息查询，带分页
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>        
        [AuthenticateHandler(ActionName = Action_CFNSet, Description = "成套产品维护", Permissoin = PermissionType.Read)]
        public DataSet QueryDataByFilterCfnSet(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (CfnSetDao dao = new CfnSetDao())
            {

                return dao.QueryDataByFilterCfnSet(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 成套产品信息查询
        /// </summary>       
        /// <param name="Id"></param>
        /// <returns></returns>        
        public IList<CfnSet> QueryCfnSetByID(String Id)
        {
            using (CfnSetDao dao = new CfnSetDao())
            {
                return dao.QueryDataByID(Id);
            }
        }

        /// <summary>
        /// 成套产品明细信息查询，带分页
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>        
        [AuthenticateHandler(ActionName = Action_CFNSet, Description = "成套产品维护", Permissoin = PermissionType.Read)]
        public DataSet QueryCfnSetDetailByCFNSID(Guid CFNSID, int start, int limit, out int totalRowCount)
        {
            using (CfnSetDetailDao dao = new CfnSetDetailDao())
            {

                return dao.QueryCfnSetDetailByCFNSID(CFNSID, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 新增
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_CFNSet, Description = "成套产品维护", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_CFNSet, Title = "成套产品维护", Message = "新增成套产品", Categories = new string[] { Data.DMSLogging.CFNSetCategory })]
        public bool Insert(CfnSet cfnSet)
        {
            bool result = false;
            using (CfnSetDao dao = new CfnSetDao())
            {
                cfnSet.LastUpdateDate = DateTime.Now;
                cfnSet.LastUpdateUser = new Guid(_context.User.Id);

                cfnSet.CreateDate = cfnSet.LastUpdateDate;
                cfnSet.CreateUser = cfnSet.LastUpdateUser;

                object ojb = dao.Insert(cfnSet);
                result = true;
            }
            return result;
        }

        [AuthenticateHandler(ActionName = Action_CFNSet, Description = "成套产品维护", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_CFNSet, Title = "成套产品维护", Message = "新增成套产品", Categories = new string[] { Data.DMSLogging.CFNSetCategory })]
        public bool SaveCfnSet(ChangeRecords<CfnSet> mainData)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {

                //更新单据
                CfnSetDao mainDao = new CfnSetDao();
                CfnSetDetailDao detailDao = new CfnSetDetailDao();
                foreach (CfnSet cfnSet in mainData.Deleted)
                {
                    mainDao.Delete(cfnSet.Id);
                    detailDao.DeleteByCfnsID(cfnSet.Id);
                }
                trans.Complete();
                result = true;
            }

            return result;
        }

        [AuthenticateHandler(ActionName = Action_CFNSet, Description = "成套产品维护", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_CFNSet, Title = "成套产品维护", Message = "新增成套产品", Categories = new string[] { Data.DMSLogging.CFNSetCategory })]
        public bool SaveCfnSet(ChangeRecords<CfnSetDetail> detailData, CfnSet mainData)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                //为新增单据准备ID
                Guid cfnsID = Guid.NewGuid();

                if (mainData.Id == null || mainData.Id.Equals(new Guid()))
                {
                    //写入主数据(如果是新增单据)
                    mainData.Id = cfnsID;
                    mainData.CreateUser = new Guid(_context.User.Id);
                    mainData.CreateDate = DateTime.Now;
                    mainData.DeletedFlag = false;
                    CfnSetDao cfnSetDao = new CfnSetDao();
                    cfnSetDao.Insert(mainData);
                }
                else
                {
                    cfnsID = mainData.Id;
                    //更新主单据(只能更新ChineseName、EnglishName，同时更新UpdateUser、UpdateDate)
                    mainData.UpdateUser = new Guid(_context.User.Id);
                    mainData.UpdateDate = DateTime.Now;
                    CfnSetDao cfnSetDao = new CfnSetDao();
                    cfnSetDao.Update(mainData);
                }

                //更新明细单据
                CfnSetDetailDao detailDao = new CfnSetDetailDao();
                foreach (CfnSetDetail cfnSetDetail in detailData.Deleted)
                {
                    detailDao.Delete(cfnSetDetail.Id);
                }

                foreach (CfnSetDetail cfnSetDetail in detailData.Created)
                {
                    //cfnSetDetail.Id = Guid.NewGuid();
                    cfnSetDetail.CfnsId = cfnsID;
                    detailDao.Insert(cfnSetDetail);
                }

                foreach (CfnSetDetail cfnSetDetail in detailData.Updated)
                {
                    detailDao.Update(cfnSetDetail);
                }
                trans.Complete();

                result = true;
            }

            return result;
        }

        [AuthenticateHandler(ActionName = Action_CFNSet, Description = "成套产品维护", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_CFNSet, Title = "成套产品维护", Message = "新增成套产品", Categories = new string[] { Data.DMSLogging.CFNSetCategory })]
        public bool SaveMainData(CfnSet mainData)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                //为新增单据准备ID
                Guid cfnsID = Guid.NewGuid();

                if (mainData.Id == null || mainData.Id.Equals(new Guid()))
                {
                    //写入主数据(如果是新增单据)
                    mainData.Id = cfnsID;
                    mainData.CreateUser = new Guid(_context.User.Id);
                    mainData.CreateDate = DateTime.Now;
                    mainData.DeletedFlag = false;
                    CfnSetDao cfnSetDao = new CfnSetDao();
                    cfnSetDao.Insert(mainData);
                }
                else
                {
                    cfnsID = mainData.Id;
                    //更新主单据(只能更新ChineseName、EnglishName，同时更新UpdateUser、UpdateDate)
                    mainData.UpdateUser = new Guid(_context.User.Id);
                    mainData.UpdateDate = DateTime.Now;
                    CfnSetDao cfnSetDao = new CfnSetDao();
                    cfnSetDao.Update(mainData);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }

        //added by bozhenfei on 20110217
        /// <summary>
        /// 根据经销商和产品线，根据经销商授权查询成套产品
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCfnSetForPurchaseOrderByAuth(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (CfnSetDao dao = new CfnSetDao())
            {
                using (DealerAuthorizationDao authDao = new DealerAuthorizationDao())
                {
                    DealerAuthorization authObj = new DealerAuthorization();

                    authObj.ProductLineBumId = new Guid(table["ProductLineId"].ToString());
                    authObj.DmaId = new Guid(table["DealerId"].ToString());
                    authObj.Type = DealerAuthorizationType.Order.ToString();

                    IList<DealerAuthorization> autoList = authDao.SelectByFilter(authObj);

                    int OrderAuthCount = 0;
                    if (autoList != null)
                    {
                        OrderAuthCount = autoList.Count();
                    }

                    table.Add("OrderAuthCount", OrderAuthCount);
                    BaseService.AddCommonFilterCondition(table);
                    return dao.QueryCfnSetForPurchaseOrderByAuth(table, start, limit, out totalRowCount);
                }
            }
        }

        /// <summary>
        /// -根据经销商和产品线，根据经销商授权查询成套产品明细
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCFNSetDetailForPurchaseOrderByAuth(Hashtable table, int start, int limit, out int totalRowCount)
        {
            BaseService.AddCommonFilterCondition(table);
            using (CfnSetDetailDao dao = new CfnSetDetailDao())
            {
                return dao.QueryCFNSetDetailForPurchaseOrderByAuth(table, start, limit, out totalRowCount);
            }
        }
        //end
        public DataSet QueryConsignmenCfnSetDetailByCFNSID(string CFNSId, int start, int limit, out int totalRowCount)
        {
            using (CfnSetDetailDao dao = new CfnSetDetailDao())
            {
                return dao.QueryConsignmenCfnSetDetailByCFNSID(CFNSId, start, limit, out totalRowCount);
            }
        }
    }
}
