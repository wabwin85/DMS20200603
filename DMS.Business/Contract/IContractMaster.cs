using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using DMS.Model;
    using System.Data;
    using System.Collections;
    public interface IContractMaster
    {
        DataSet QueryForContractMaster(Hashtable table, int start, int limit, out int totalRowCount);
        ContractMasterDM GetContractMasterByCmID(Hashtable table);
        ContractMasterDM GetContractMasterByDealerID(Guid dealerID);
        int UpdateContractMasterStatus(Hashtable obj);

        void UpdateContractFrom3(ContractMasterDM contractMasterDM);
        void InsertContractFrom3(ContractMasterDM contractMasterDM);

        void UpdateContractFrom4(ContractMasterDM contractMasterDM);
        void InsertContractFrom4(ContractMasterDM contractMasterDM);

        void UpdateContractFrom5(ContractMasterDM contractMasterDM);
        void InsertContractFrom5(ContractMasterDM contractMasterDM);

        DataSet SelectActiveContractCount(Hashtable obj);

        string BindContractMasterId(Guid DealerId, string contractId, string parmetType);
    }
}
