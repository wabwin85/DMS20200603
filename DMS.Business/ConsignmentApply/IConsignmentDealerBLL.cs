using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using DMS.Model;
namespace DMS.Business
{
    public interface IConsignmentDealerBLL
    {
        DataSet GetConsignmentDealer(Hashtable table);
        bool ChcekCfnSumbit(Guid CAH_ID, Guid DealerId, string ProductLineId, string CMID, out string rtnVal, out string rtnMsg, out string RtnRegMsg);
        bool InsertDealer(string[] Constring, string CM_ID);
        bool DeleteDealer(Guid CdId);
        bool DelletePling(Guid id);
        DataSet GetConsignmentContractDealer(Hashtable table);
    }
}
