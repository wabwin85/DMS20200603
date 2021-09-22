using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model;
using System.Data;
using System.Collections;
using DMS.Model.Consignment;

namespace DMS.Business
{
    public interface IConsignmentMasterBLL
    {
        ConsignmentMaster GetConsignmentMasterKey(Guid id);
        void InsertPurchaseOrderHeader(ConsignmentMaster obj);
        bool Submit(ConsignmentMaster header, string DMA_ID);
        DataSet SelectConsignmentMasterByFilter(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet SelectConsignmentMasterById(Guid obj, int start, int limit, out int totalRowCount);
        ConsignmentMaster SelectConsignmentMasterById(Guid Id);
        bool SaveDraft(ConsignmentMaster consignmentMaster);
        bool RevokeOrder(Guid id);
        bool DeleteDraft(Guid Id);
        bool DeleteCfns(Guid Id);
        bool DeleteCfn(Guid Id);
        bool UpdateCfn(ConsignmentCfn consignmentCfn);
        ConsignmentCfn GetConsignmentCfnById(Guid id);
        DataSet GetConsignmentCfnById(Guid id, int start, int limit, out int totalRowCount);
        DataSet SelectConsignmentMasterByealer(string CmId, int start, int limit, out int totalRowCount);
        DataSet QeryConsignmentMasterDealerSearch(Hashtable ht, int start, int limit, out int totalRowCount);
        bool CheckedSubmit(Guid CM_ID, string ProductLineId,string name, out string rtnVal, out string rtnMsg, out string RtnRegMsg);
        DataSet GetConsignmentMasterAll(string status);
        DataSet QuqerConsignmentAuthorizationby(Hashtable ht, int start, int limit, out int totalRowCount);
        DataSet GetDelareProductLineby(string DamId);
        DataSet GetProductLineConsignmenby(string ProductLineId,string DMAID);
        bool InsertConsignmentAuthorizationby(Hashtable ht);
        bool UpdateConsignmentAuthorizationby(Hashtable ht);
        DataSet SelecConsignmentAuthorizationby(string CAID);
        bool Updatstopby(string CAID);
        bool Updatrecoveryby(string CAID);
        DataSet SelecConsignmentdatetimeby(Hashtable ht);
       bool DeleteConsignmentDealerby(string CMID);
       DataSet SelecConsignmentAuthorizationCount(Hashtable tb);
        ContractHeaderPO GetContractHeaderPOById(Guid Id);
    }
}
