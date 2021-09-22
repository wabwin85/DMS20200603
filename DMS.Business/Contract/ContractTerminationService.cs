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
    public class ContractTerminationService : IContractTerminationService
    {
        public ContractTermination GetContractTerminationByID(Guid creId)
        {
            using (ContractTerminationDao dao = new ContractTerminationDao())
            {
                return dao.GetObject(creId);
            }
        }

        public int UpdateTerminationCmidByConid(Hashtable obj)
        {
            using (ContractTerminationDao dao = new ContractTerminationDao())
            {
                return dao.UpdateTerminationCmidByConid(obj);
            }
        }

        public TerminationForm GetTerminationFormByDealerId(Guid dealerId)
        {
            using (TerminationFormDao dao = new TerminationFormDao())
            {
                return dao.GetObject(dealerId);
            }
        }


        public int UpdateTerminationStatusByConid(Hashtable obj)
        {
            using (ContractTerminationDao dao = new ContractTerminationDao())
            {
               return dao.UpdateTerminationStatusByConid(obj);
            }
        }

        public TerminationForm GetTerminationFormByObj(Hashtable obj)
        {
            using (TerminationFormDao dao = new TerminationFormDao())
            {
                return dao.GetTerminationFormByObj(obj);
            }
        }

        public DataSet GetTermination(string ContractNo)
        {
            using (TerminationFormDao dao = new TerminationFormDao())
            {
                return dao.GetTermination(ContractNo);
            }
        }

        public DataSet GetTerminationall(string ContractId)
        {
            using (TerminationFormDao dao = new TerminationFormDao())
            {
                return dao.GetTerminationall(ContractId);
            }
        }

        public void insertTerminationMainTemp(Hashtable hs)
        {
            using (TerminationFormDao dao = new TerminationFormDao())
            {
                 dao.insertTerminationMainTemp(hs);
            }
        }

        public void insertTerminationEndFormTemp(Hashtable hs)
        {
            using (TerminationFormDao dao = new TerminationFormDao())
            {
                 dao.insertTerminationEndFormTemp(hs);
            }
        }

        public void insertTerminationHandoverTemp(Hashtable hs)
        {
            using (TerminationFormDao dao = new TerminationFormDao())
            {
                 dao.insertTerminationHandoverTemp(hs);
            }
        }

        public void insertTerminationNCMTemp(Hashtable hs)
        {
            using (TerminationFormDao dao = new TerminationFormDao())
            {
                 dao.insertTerminationNCMTemp(hs);
            }
        }
        public void insertTerminationStatusTemp(Hashtable hs)
        {
            using (TerminationFormDao dao = new TerminationFormDao())
            {
                 dao.insertTerminationStatusTemp(hs);
            }
        }

        public bool SaveAmendmentUpdate(string TempId)
        {
            bool result = false;
            ContractAmendmentDao headerDao = new ContractAmendmentDao();
            {
                headerDao.AmendmentInitialize(TempId, "Termination");
                result = true;
            }
            return result;
        }

        public DataSet GetUpdatelog(string contractid, int start, int limit, out int totalRowCount)
        {
            Hashtable table = new Hashtable();
            table.Add("ContractId", contractid);
            using (TerminationFormDao dao = new TerminationFormDao())
            {
                return dao.GetUpdatelog(table, start, limit, out totalRowCount);
            }
        }
    }
}
