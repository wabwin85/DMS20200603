using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using DMS.DataAccess;
    using DMS.Model;
    using System.Collections;
    using System.Data;
    using Lafite.RoleModel.Security.Authorization;
    using Lafite.RoleModel.Security;
    using Grapecity.DataAccess.Transaction;

    public class ContractMaster : IContractMaster
    {
        public const string Action_ContractMaster = "ContractMaster";

        private IRoleModelContext _context = RoleModelContext.Current;

        #region Select
        [AuthenticateHandler(ActionName = Action_ContractMaster, Description = "合同维护", Permissoin = PermissionType.Read)]
        public DataSet QueryForContractMaster(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("OwnerCorpId", this._context.User.CorpId);

            using (ContractMasterDao dao = new ContractMasterDao())
            {
                return dao.SelectForContractMaster(table, start, limit, out totalRowCount);
            }
        }

        public ContractMasterDM GetContractMasterByCmID(Hashtable table)
        {
            using (ContractMasterDao dao = new ContractMasterDao())
            {
                return dao.GetContractMasterByCmID(table);
            }
        }

        public ContractMasterDM GetContractMasterByDealerID(Guid dealerID)
        {
            using (ContractMasterDao dao = new ContractMasterDao())
            {
                return dao.GetContractMasterByDealerID(dealerID);
            }
        }

        public void UpdateContractFrom3(ContractMasterDM contractMasterDM) 
        {
            using (ContractMasterDao dao = new ContractMasterDao())
            {
                dao.UpdateContractFrom3(contractMasterDM);
            }
        }

        public void InsertContractFrom3(ContractMasterDM contractMasterDM)
        {
            using (ContractMasterDao dao = new ContractMasterDao())
            {
                dao.InsertContractFrom3(contractMasterDM);
            }
        }

        public void UpdateContractFrom4(ContractMasterDM contractMasterDM)
        {
            using (ContractMasterDao dao = new ContractMasterDao())
            {
                dao.UpdateContractFrom4(contractMasterDM);
            }
        }

        public void InsertContractFrom4(ContractMasterDM contractMasterDM)
        {
            using (ContractMasterDao dao = new ContractMasterDao())
            {
                dao.InsertContractFrom4(contractMasterDM);
            }
        }

        public void UpdateContractFrom5(ContractMasterDM contractMasterDM)
        {
            using (ContractMasterDao dao = new ContractMasterDao())
            {
                dao.UpdateContractFrom5(contractMasterDM);
            }
        }

        public void InsertContractFrom5(ContractMasterDM contractMasterDM)
        {
            using (ContractMasterDao dao = new ContractMasterDao())
            {
                dao.InsertContractFrom5(contractMasterDM);
            }
        }

        public int UpdateContractMasterStatus(Hashtable obj) 
        {
            using (ContractMasterDao dao = new ContractMasterDao())
            {
                return dao.UpdateContractMasterStatus(obj);
            }
        }

        public DataSet SelectActiveContractCount(Hashtable obj)
        {
            using (ContractMasterDao dao = new ContractMasterDao())
            {
                return dao.SelectActiveContractCount(obj);
            }
        }

        public string BindContractMasterId(Guid DealerId,string contractId,string parmetType)
        {
            string cmid = "";
            using (TransactionScope trans = new TransactionScope())
            {
                ContractMasterDao dao = new ContractMasterDao();
                try
                {   //1.确认是否有CmId
                     ContractMasterDM cm= dao.GetContractMasterByDealerID(DealerId);
                     if (cm != null)
                     {
                         cmid = cm.CmId.ToString();
                     }
                     else
                     {
                         cmid = Guid.NewGuid().ToString();
                         //2. 维护信息表
                         Hashtable obj = new Hashtable();
                         obj.Add("CmId", cmid);
                         obj.Add("DmaId", DealerId);
                         obj.Add("ContractId", contractId);
                         obj.Add("ParmetType", parmetType);
                         dao.ContractMasterMaintain(obj);
                     }
                     //3. 更新合同表

                     Hashtable obj2 = new Hashtable();
                     obj2.Add("CmId", cmid);
                     obj2.Add("DmaId", DealerId);
                     obj2.Add("ContractId", contractId);
                     obj2.Add("ParmetType", parmetType);
                     dao.UpdateAppointmentCmId(obj2);
                    
                    trans.Complete();
                }
                catch { }
            }
            return cmid;
        }
        #endregion

    }
}
