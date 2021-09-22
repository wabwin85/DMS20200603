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
    public class ContractRenewalService : IContractRenewalService
    {
        public ContractRenewal GetContractRenewalByID(Guid creId)
        {
            using (ContractRenewalDao dao = new ContractRenewalDao())
            {
                return dao.GetObject(creId);
            }
        }

        public int UpdateRenewalCmidByConid(Hashtable obj)
        {
            using (ContractRenewalDao dao = new ContractRenewalDao())
            {
                return dao.UpdateRenewalCmidByConid(obj);
            }
        }

        public int UpdateRenewalFromMark(Hashtable obj)
        {
            using (ContractRenewalDao dao = new ContractRenewalDao())
            {
                return dao.UpdateRenewalFromMark(obj);
            }
        }
    }
}
