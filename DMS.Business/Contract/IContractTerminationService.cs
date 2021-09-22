using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using DMS.Model;
    using System.Data;
    using System.Collections;
    public interface IContractTerminationService
    {
        ContractTermination GetContractTerminationByID(Guid creId);
        int UpdateTerminationCmidByConid(Hashtable obj);

        TerminationForm GetTerminationFormByDealerId(Guid dealerId);
        TerminationForm GetTerminationFormByObj(Hashtable obj);

        int UpdateTerminationStatusByConid(Hashtable obj);

        DataSet GetTermination(string ContractId);
        DataSet GetTerminationall(string ContractId);

        void insertTerminationMainTemp(Hashtable hs);
        void insertTerminationEndFormTemp(Hashtable hs);
        void insertTerminationHandoverTemp(Hashtable hs);
        void insertTerminationNCMTemp(Hashtable hs);
        void insertTerminationStatusTemp(Hashtable hs);
        bool SaveAmendmentUpdate(string TempId);

        DataSet GetUpdatelog(string contractid, int start, int limit, out int totalRowCount);
    }
}
