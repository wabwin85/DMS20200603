using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using DMS.Model;
    using System.Data;
    using System.Collections;

    public interface IContractRenewalService
    {
        ContractRenewal GetContractRenewalByID(Guid creId);
        int UpdateRenewalCmidByConid(Hashtable obj);

        int UpdateRenewalFromMark(Hashtable obj);
    }
}
