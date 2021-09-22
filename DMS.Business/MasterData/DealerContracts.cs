/**********************************************
 *
 * NameSpace   : DMS.Business 
 * ClassName   : DealerContracts
 * Created Time: 2009-7 
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using Grapecity.Logging.CallHandlers;
    using Lafite.RoleModel.Security;
    using Lafite.RoleModel.Security.Authorization;
    using Grapecity.DataAccess.Transaction;
    using DMS.Common;
    using DMS.Model;
    using DMS.DataAccess;
    using Coolite.Ext.Web;
    using System.Data;
    using System.Collections;
    using DMS.Model.Data;

    /// <summary>
    /// 授权维护
    /// </summary>
    public class DealerContracts : BaseBusiness, IDealerContracts
    {
        #region Action Define
        public const string Action_DealerContracts = "DealerContracts";
        public const string Action_DealerAuthorizations = "DealerAuthorizations";

        #endregion

        private IRoleModelContext _context = RoleModelContext.Current;

        #region 查询

        /// <summary>
        /// Selects the DealerContract by filter.
        /// </summary>
        /// <param name="dealerContract">The dealer contract.</param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerContracts, Description = "合同信息", Permissoin = PermissionType.Read)]
        public IList<DealerContract> SelectByFilter(DealerContract dealerContract, int start, int limit, out int rowCount)
        {
            using (DealerContractDao dao = new DealerContractDao())
            {
                return dao.SelectByFilter(dealerContract, start, limit, out rowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerAuthorizations, Description = "授权信息", Permissoin = PermissionType.Read)]
        public IList<DealerAuthorization> GetAuthorizationList(DealerAuthorization parma)
        {

            using (DealerAuthorizationDao dao = new DealerAuthorizationDao())
            {
                return dao.SelectByFilter(parma);
            }
        }

        public DataSet GetAuthorizationListForDataSet(DealerAuthorization param)
        {
            using (DealerAuthorizationDao dao = new DealerAuthorizationDao())
            {
                return dao.SelectByFilterForDataSet(param);
            }
        }

        public DataSet GetAuthorizationListForDataSetExclude(Guid contractId, Guid authId)
        {
            DealerAuthorization param = new DealerAuthorization();
            param.DclId = contractId;
            param.Id = authId;
            using (DealerAuthorizationDao dao = new DealerAuthorizationDao())
            {
                return dao.SelectByFilterForDataSetExclude(param);
            }
        }

        public IList<DealerAuthorization> GetAuthorizationListByDealer(DealerAuthorization param)
        {
            //DealerAuthorization param = new DealerAuthorization();
            //param.DmaId = dealerId;
            using (DealerAuthorizationDao dao = new DealerAuthorizationDao())
            {
                return dao.SelectByFilter(param);
            }
        }

        public DataSet GetAuthSubCompany(Guid[] productLines)
        {
            using (DealerAuthorizationDao dao = new DealerAuthorizationDao())
            {
                return dao.GetAuthSubCompany(productLines);
            }
        }

        public DataSet GetAuthBrand(Guid subCompanyId, Guid[] productLines)
        {
            using (DealerAuthorizationDao dao = new DealerAuthorizationDao())
            {
                return dao.GetAuthBrand(subCompanyId, productLines);
            }
        }

        public IList<DealerAuthorization> GetLimitAuthorizationListByDealer(DealerAuthorization param)
        {
            //DealerAuthorization param = new DealerAuthorization();
            //param.DmaId = dealerId;
            using (DealerAuthorizationDao dao = new DealerAuthorizationDao())
            {
                return dao.SelectByFilterLimit(param);
            }
        }
        #endregion


        /// <summary>
        /// Gets the Contract.
        /// </summary>
        /// <param name="contractId">The contract id.</param>
        /// <returns></returns>
        public DealerContract GetContract(Guid contractId)
        {
            DealerContract obj = null;
            using (DealerContractDao dao = new DealerContractDao())
            {
                obj = dao.GetObject(contractId);
            }
            return obj;
        }

        /// <summary>
        /// Deletes the contract.
        /// </summary>
        /// <param name="contractId">The contract id.</param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerContracts, Description = "合同信息", Permissoin = PermissionType.Delete)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Authorization, Title = "合同信息", Message = "删除合同", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public bool DeleteContract(Guid contractId)
        {
            int rows = 0;

            using (DealerContractDao dao = new DealerContractDao())
            {
                rows = dao.Delete(contractId);
            }

            return rows > 0;
        }


        /// <summary>
        /// Deletes the contract.
        /// </summary>
        /// <param name="contractId">The contract id.</param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerContracts, Description = "合同信息", Permissoin = PermissionType.Write)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Authorization, Title = "合同信息", Message = "合同信息维护", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public bool SaveContract(DealerContract contract)
        {
            int rows = 0;

            using (DealerContractDao dao = new DealerContractDao())
            {
                DealerContract obj = dao.GetObject(contract.Id.Value);

                if (obj != null)
                {
                    obj.DmaId = contract.DmaId;
                    obj.ContractNumber = contract.ContractNumber;
                    obj.ContractYears = contract.ContractYears;

                    if (contract.StartDate != null)
                        obj.StartDate = contract.StartDate;

                    if (contract.StopDate != null)
                        obj.StopDate = contract.StopDate;

                    obj.LastUpdateDate = DateTime.Now;
                    obj.LastUpdateUser = new Guid(_context.User.Id);

                    rows = dao.Update(obj);

                    return rows > 0;
                }
                else
                {
                    contract.LastUpdateDate = DateTime.Now;
                    contract.LastUpdateUser = new Guid(_context.User.Id);

                    contract.CreateDate = contract.LastUpdateDate;
                    contract.CreateUser = contract.LastUpdateUser;

                    dao.Insert(contract);

                    return true;
                }
            }

        }

        /// <summary>
        /// Deletes the authorization.
        /// </summary>
        /// <param name="authId">The auth id.</param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerAuthorizations, Description = "授权信息", Permissoin = PermissionType.Delete)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Authorization, Title = "授权信息", Message = "删除授权", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public bool DeleteAuthorization(Guid authId)
        {
            int rows = 0;
            using (TransactionScope trans = new TransactionScope())
            {
                using (DealerAuthorizationDao dao = new DealerAuthorizationDao())
                {
                    //Added By Song Yuqi On 2016-06-02
                    //若删除授权会自动记录到日志表中
                    Hashtable table = new Hashtable();
                    table.Add("Id", authId);
                    table.Add("OperationType", "Delete");
                    table.Add("UserId", _context.User.Id);

                    dao.InsertDealerAuthorizationLog(table);

                    rows = dao.Delete(authId);

                    trans.Complete();
                }
            }

            return rows > 0;
        }

        /// <summary>
        /// Checks the authorization parts.
        /// 检查选择的分类是否已存在，如果存在则验证通不过则返回false, 验证通过返回true
        /// </summary>
        /// <param name="categoryID">The category ID.</param>
        /// <param name="dealerID">The dealer ID.</param>
        /// <param name="flag">The flag.</param>
        /// <returns></returns>
        public bool CheckAuthorizationParts(Guid categoryID, Guid dealerID, out int flag)
        {
            using (DealerAuthorizationDao dao = new DealerAuthorizationDao())
            {
                return dao.CheckAuthorizationParts(categoryID, dealerID, out flag);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool SaveAuthorizationChanges(DealerAuthorization data, string OptionsStatus)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                DealerAuthorizationDao dao = new DealerAuthorizationDao();

                if (OptionsStatus == "Deleted")
                {
                    dao.Delete(data.Id.Value);
                }

                if (OptionsStatus == "Created")
                {
                    data.LastUpdateDate = DateTime.Now;
                    data.LastUpdateUser = new Guid(_context.User.Id);

                    data.CreateDate = data.LastUpdateDate;
                    data.CreateUser = data.LastUpdateUser;

                    dao.Insert(data);
                }

                if (OptionsStatus == "Updated")
                {
                    data.LastUpdateDate = DateTime.Now;
                    data.LastUpdateUser = new Guid(_context.User.Id);

                    dao.Update(data);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }

        [AuthenticateHandler(ActionName = Action_DealerAuthorizations, Description = "授权信息", Permissoin = PermissionType.Write)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Authorization, Title = "授权信息", Message = "针对经销商的具体授权的新增、修改、删除", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public bool SaveAuthorizationOfDealerChanges(ChangeRecords<DealerAuthorization> data)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                DealerAuthorizationDao dao = new DealerAuthorizationDao();

                foreach (DealerAuthorization authorization in data.Deleted)
                {
                    dao.Delete(authorization.Id.Value);
                }

                foreach (DealerAuthorization authorization in data.Created)
                {
                    authorization.LastUpdateDate = DateTime.Now;
                    authorization.LastUpdateUser = new Guid(_context.User.Id);

                    authorization.CreateDate = authorization.LastUpdateDate;
                    authorization.CreateUser = authorization.LastUpdateUser;

                    dao.Insert(authorization);
                }


                foreach (DealerAuthorization authorization in data.Updated)
                {
                    authorization.LastUpdateDate = DateTime.Now;
                    authorization.LastUpdateUser = new Guid(_context.User.Id);

                    dao.Update(authorization);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }

        [AuthenticateHandler(ActionName = Action_DealerAuthorizations, Description = "授权信息", Permissoin = PermissionType.Write)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Authorization, Title = "授权医院", Message = "给具体授权产品分类指定可销售医院", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public bool SaveHospitalOfAuthorization(Guid datId, IDictionary<string, string>[] changes, SelectTerritoryType selectType, string hosProvince, string hosCity, string hosDistrict, Guid productLineId, string hosRemark, DateTime AuthStartDate, DateTime AuthStopDate)
        {
            bool result = false;
            if (selectType == SelectTerritoryType.Default)
            {
                if (changes.Length > 0)
                {
                    using (TransactionScope trans = new TransactionScope())
                    {
                        DealerHospitalDao dao = new DealerHospitalDao();

                        foreach (Dictionary<string, string> hospital in changes)
                        {
                            dao.AttachHospitalToAuthorization(datId, new Guid(hospital["Key"]), hosRemark, AuthStartDate, AuthStopDate);
                        }

                        trans.Complete();
                    }

                    result = true;
                }
            }
            else
            {
                int rows = 0;


                using (TransactionScope trans = new TransactionScope())
                {
                    DealerHospitalDao dao = new DealerHospitalDao();

                    string hos_City = hosCity;
                    string hos_District = hosDistrict;

                    foreach (Dictionary<string, string> territory in changes)
                    {
                        if (selectType == SelectTerritoryType.District)
                            hos_District = territory["Value"];
                        else
                        {
                            hos_District = string.Empty;
                            hos_City = territory["Value"];
                        }
                        rows += dao.AttachHospitalToAuthorization(datId, hosProvince, hos_City, hos_District, productLineId, hosRemark, AuthStartDate, AuthStopDate);
                    }
                    if (rows > 0)
                    {
                        trans.Complete();
                    }
                }

                if (rows > 0)
                    result = true;
            }

            return result;
        }

        [AuthenticateHandler(ActionName = Action_DealerAuthorizations, Description = "授权信息", Permissoin = PermissionType.Delete)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Authorization, Title = "授权医院", Message = "删除具体授权产品分类的关联医院", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public void DetachHospitalFromAuthorization(Guid datId, Guid[] changes)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                DealerHospitalDao dao = new DealerHospitalDao();

                foreach (Guid item in changes)
                {
                    dao.DetachHospitalFromAuthorization(datId, item);
                }

                trans.Complete();
            }
        }

        public void CopyHospitalFromOtherAuth(Guid datId, Guid fromDatId, DateTime startDate, DateTime endDate)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                DealerHospitalDao dao = new DealerHospitalDao();

                dao.AttachHospitalAuthFromOtherAuth(datId, fromDatId, startDate, endDate);

                trans.Complete();
            }
        }

        //added by songyuqi on 20100901
        public bool VerifyDealerIsUniqueness(Guid dealerID)
        {
            int num = 0;

            using (TransactionScope trans = new TransactionScope())
            {
                DealerContractDao dao = new DealerContractDao();
                num = dao.VerifyDealerIsUniqueness(dealerID);

                if (num > 0)
                    return false;
                else
                    return true;
            }
        }

        public bool SaveHositalAuthDate(Guid datId, Guid hosId, DateTime authStartDate, DateTime authEndDate)
        {
            bool result = false;

            using (DealerAuthorizationDao dao = new DealerAuthorizationDao())
            {
                Hashtable table = new Hashtable();
                table.Add("DatId", datId);
                table.Add("HosId", hosId);
                table.Add("HosAuthStartDate", authStartDate.ToString("yyyy-MM-dd"));
                table.Add("HosAuthEndDate", authEndDate.ToString("yyyy-MM-dd"));
                result = dao.SaveHositalAuthDate(table) > 0 ? true : false;
            }

            return result;
        }

        public Hashtable GetDealerSpecialAuthByType(Hashtable table, DealerAuthorizationType type, Guid dealerId, Guid productLineid)
        {

            using (DealerAuthorizationDao authDao = new DealerAuthorizationDao())
            {
                DealerAuthorization authObj = new DealerAuthorization();

                authObj.ProductLineBumId = productLineid;
                authObj.DmaId = dealerId;
                authObj.Type = type.ToString();

                IList<DealerAuthorization> autoList = authDao.SelectByFilter(authObj);

                int SpecialAuthCount = 0;
                if (autoList != null)
                {
                    SpecialAuthCount = autoList.Count();
                }

                table.Add("OrderAuthCount", SpecialAuthCount);
            }
            return table;
        }

        public DataSet SelectByDealerDealerContractActiveFlag(Hashtable obj)
        {
            using (DealerContractDao dao = new DealerContractDao())
            {
                return dao.SelectByDealerDealerContractActiveFlag(obj);
            }
        }
    }
}
