using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;
using Lafite.RoleModel.Domain;
using DMS.ViewModel.Consign.Common;
namespace DMS.ViewModel.Consign
{
     public class ConsignmentTerminationInfoVO : BaseBusinessVO
    {
        [LogAttribute]
        public KeyValue IptContractNo;
        [LogAttribute]
        public KeyValue IptBu;
        public String IptContractName;
        public String IptBeginDate;
        public String IptEndDate;
        public String IptRemark;
        [LogAttribute]
        public String IptReason;
        [LogAttribute]
        public String IptTerminationNo;

        

        public String QryStatus;
        
        public ConsignContract IptConsignContract;
        
        public ApplyBasic IptApplyBasic;

        public IList<KeyValue> LstBu;

        public IList<Hashtable> LstConsignContract;

        public ArrayList LstContract;
        [LogAttribute]
        public KeyValue IptDealer;

        public ArrayList LstDelaer;

        public bool CheckCreateUser;
    }
}
