using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace DMS.Business.Contract
{
    using DMS.DataAccess;
    using DMS.Model;
    using System.Collections;
    using System.Data;
    using Grapecity.DataAccess.Transaction;
    using Lafite.RoleModel.Security;

    public class ThirdPartyDisclosureService : IThirdPartyDisclosureService
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        public void SaveThirdPartyDisclosure(ThirdPartyDisclosure thirdParty)
        {
            using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
            {
                dao.Insert(thirdParty);
            }
        }

        public DataSet GetThirdPartyDisclosureQuery(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
            {
                return dao.GetThirdPartyDisclosureQuery(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet GetThirdPartyDisclosureQuery(Hashtable obj)
        {
            using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
            {
                return dao.GetThirdPartyDisclosureQuery(obj);
            }
        }

        public DataSet GetThirdPartyDisclosureQueryNoPL(Hashtable obj)
        {
            using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
            {
                return dao.GetThirdPartyDisclosureQueryNoPL(obj);
            }
        }

        public DataSet GetThirdPartyDisclosureById(Guid Id) 
        {
            using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
            {
                return dao.GetObject(Id);
            }
        }

        public int DeleteThirdPartyDisclosureById(Guid Id) 
        {
            using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
            {
                return dao.Delete(Id);
            }
        }

        public int UpdateThirdPartyDisclosureById(ThirdPartyDisclosure thirdParty) 
        {
            using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
            {
                return dao.Update(thirdParty);
            }
        }

        public bool SynchronousHospitalToThirdParty(Guid DmaId)
        {
            bool result = false;
            Hashtable obj = new Hashtable();
            obj.Add("DmaId", DmaId.ToString());
            obj.Add("RtnVal", "");
            obj.Add("RtnMsg", "");
            using (TransactionScope trans = new TransactionScope())
            {
                using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
                {
                    //dao.DeleteThirdPartyDisclosureByAuthorized(obj);
                    dao.SynchronousHospitalToThirdParty(obj);
                }
                trans.Complete();
                result = true;
            }
            return result;
        }

        public void SetHospitalNoDisclosure(string[] Id)
        {
            Hashtable param = new Hashtable();
            param.Add("Id", Id);
            using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
            {
                dao.SetHospitalNoDisclosure(param);
            }
        }

        public int ApprovalThirdParty(Hashtable obj)
        {
            using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
            {
                return  dao.ApprovalThirdParty(obj);
            }
        }

        public DataSet GetThirdPartyBuType(Hashtable obj)
        {
            using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
            {
                return dao.GetThirdPartyBuType(obj);
            }
        }
        public DataSet QueryThirdPartyDisclosure(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            obj.Add("OwnerCorpId", this._context.User.CorpId);

            using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
            {
                return dao.QueryThirdPartyDisclosure(obj, start, limit, out totalRowCount);
            }
        }
       
        public DataSet ExportThirdPartyDisclosure(Hashtable obj)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            obj.Add("OwnerCorpId", this._context.User.CorpId);
            using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
            {
                return dao.ExportThirdPartyDisclosure(obj);
            }
        }
        public DataSet SelectThirdPartyDisclosureHospitBU(Hashtable obj)
        {
            using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
            {
                return dao.SelectThirdPartyDisclosureHospitBU(obj);
            }
        }
        public bool InsertContractLog(Hashtable obj)
        {
            bool reslut=false;
          using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
            {
                 dao.InsertContractLog(obj);
                 reslut=true;
            }
            return reslut;
        }

        public DataSet ThirdPartyDisclosureHospitBU(Hashtable obj)
        {
            using (ThirdPartyDisclosureDao dao = new ThirdPartyDisclosureDao())
            {
                return dao.ThirdPartyDisclosureHospitBU(obj);
            }
        }

        public DataSet DealerAuthorizationHospital(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.DealerAuthorizationHospital(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet SelectThirdPartyDisclosureList(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.SelectThirdPartyDisclosureList(obj, start, limit, out totalRowCount);
            }
        }

        public int UpdateThirdPartyDisclosureListById(ThirdPartyDisclosureList thirdParty)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.UpdateThirdPartyDisclosureList(thirdParty);
            }
        }

        public void SaveThirdPartyDisclosureList(ThirdPartyDisclosureList thirdParty)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                dao.Insert(thirdParty);
            }
        }

        public int DeleteThirdPartyDisclosureListById(Guid Id)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.Delete(Id);
            }
        }

        public DataSet GetThirdPartyDisclosureListById(Guid Id)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.GetObject(Id);
            }
        }

        public int ApprovalThirdPartyDisclosureList(Hashtable obj)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.ApprovalThirdPartyDisclosureList(obj);
            }
        }

        public DataSet ThirdPartyDisclosureListByBU(Hashtable obj)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.ThirdPartyDisclosureListByBU(obj);
            }

        }

        public int RefuseThirdPartyDisclosureList(Hashtable obj)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.RefuseThirdPartyDisclosureList(obj);
            }
        }

        public DataSet SelectThirdPartyDisclosureList(Hashtable obj)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.SelectThirdPartyDisclosureList(obj);
            }
        }

        public DataSet GetThirdPartyDisclosureListBuType(Hashtable obj)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.GetThirdPartyDisclosureListBuType(obj);
            }
        }

        public DataSet SelectThirdPartyDisclosureListHospitBU(Hashtable obj)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.SelectThirdPartyDisclosureListHospitBU(obj);
            }
        }

        public int UpdateThirdPartyDisclosureListend(Hashtable obj)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.UpdateThirdPartyDisclosureListend(obj);
            }
        }

        public void InsertThirdPartyDisclosureListLp(ThirdPartyDisclosureList thirdParty)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                dao.InsertThirdPartyDisclosureListLp(thirdParty);
            }
        }

        public DataSet SelectThirdPartyDisclosureListType(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.SelectThirdPartyDisclosureListType(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet SelectThirdPartylist(Hashtable obj)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.SelectThirdPartylist(obj);
            }
        }

        public DataSet ThirdPartylist(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.ThirdPartylist(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet ThirdPartylist(Hashtable obj)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.ThirdPartylist(obj);
            }
        }

       

        public int updateendThirdPartyList(Hashtable obj)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.updateendThirdPartyList(obj);
            }
        }

        public int endThirdPartyList(Hashtable obj)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.endThirdPartyList(obj);
            }
        }

        public DataSet Authorinformation(Hashtable obj)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.Authorinformation(obj);
            }

        }

        public DataSet ThirdPartyDisclosureListALL(Hashtable obj)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.ThirdPartyDisclosureListALL(obj);
            }
        }

        public DataSet ExportThirdPartylist(Hashtable obj)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.ExportThirdPartylist(obj);
            }
        }

        public int TerminationThirdPartyList(Hashtable obj)
        {
            using (ThirdPartyDisclosureListDao dao = new ThirdPartyDisclosureListDao())
            {
                return dao.TerminationThirdPartyList(obj);
            }
        }
    }
}
